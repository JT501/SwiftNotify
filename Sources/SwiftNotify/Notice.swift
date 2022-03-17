//
//  Notifier.swift
//  SwiftNotify
//
//  Created by Johnny on 12/11/2016.
//  Copyright © 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

public typealias CompletionCallBack = (_ completed: Bool) -> Void

public protocol NoticeProtocol {
    var id: String { get }
    var isHiding: Bool { get }
    var duration: DurationsEnum { get }

    func present(completion: @escaping CompletionCallBack)
    func dismiss(completion: CompletionCallBack?)
}

extension NoticeProtocol {
    public func dismiss(completion: CompletionCallBack? = nil) {
        dismiss(completion: completion)
    }
}

open class Notice: NSObject, NoticeProtocol {
    public typealias TapCallback = (String) -> Void

    public let id: String
    public let config: PhysicsConfig
    public let view: UIView
    public let duration: DurationsEnum
    public let fromPosition: FromPositionsEnum
    public let toPosition: ToPositionsEnum
    public let tapAction: TapCallback?

    public private(set) var isHiding: Bool

    weak var delegate: NoticeDelegate?

    private let containerView: UIView
    private let panRecognizer: UIPanGestureRecognizer
    private let tapRecognizer: UITapGestureRecognizer
    private let longPressRecognizer: UILongPressGestureRecognizer
    private var animator: UIDynamicAnimator
    private var snapPoint: CGPoint
    private var snapBehaviour: UISnapBehavior!
    private var attachmentBehaviour: UIAttachmentBehavior!
    private var gravityBehaviour: UIGravityBehavior!
    private var collisionBehaviour: UICollisionBehavior!

    private var fieldMargin: CGFloat  //Margin to remove message from view
    private var angularVelocity: CGFloat = 0

    lazy private var userInfo: [AnyHashable: NoticeInfo] = [
        NoticeInfo.userInfoKey: NoticeInfo(id: id)
    ]

    init(
            id: String = UUID().uuidString,
            view: UIView,
            duration: DurationsEnum,
            fromPosition: FromPositionsEnum,
            toPosition: ToPositionsEnum,
            tapHandler: TapCallback?,
            config: PhysicsConfig,
            delegate: NoticeDelegate
    ) {
        self.id = id
        self.config = config
        self.view = view
        self.duration = duration
        self.fromPosition = fromPosition
        self.toPosition = toPosition
        self.delegate = delegate

        containerView = UIView()
        panRecognizer = UIPanGestureRecognizer()
        tapRecognizer = UITapGestureRecognizer()
        longPressRecognizer = UILongPressGestureRecognizer()
        animator = UIDynamicAnimator()
        snapPoint = CGPoint.zero
        isHiding = false
        fieldMargin = (view.bounds.width > view.bounds.height) ? view.bounds.width : view.bounds.height
        tapAction = tapHandler

        super.init()

        panRecognizer.addTarget(self, action: #selector(Notice.pan(gesture:)))
        panRecognizer.maximumNumberOfTouches = 1
        tapRecognizer.addTarget(self, action: #selector(onTap(gesture:)))
        longPressRecognizer.addTarget(self, action: #selector(onLongPress(gesture:)))
        longPressRecognizer.minimumPressDuration = 0.25
        longPressRecognizer.allowableMovement = 0
        longPressRecognizer.delegate = self
    }

    public func present(completion: @escaping (_ completed: Bool) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate else {
            return
        }
        guard let keyWindow = appDelegate.window! else {
            return
        }

        animator = UIDynamicAnimator(referenceView: keyWindow)

        let initPoint: CGPoint
        switch fromPosition {
        case .top(let position):
            switch position {
            case .center:
                initPoint = CGPoint(keyWindow.bounds.midX, 0 - view.bounds.height)
            case .left:
                initPoint = CGPoint(0 - view.bounds.width, 0 - view.bounds.height)
            case .right:
                initPoint = CGPoint(keyWindow.bounds.width, 0 - view.bounds.height)
            case .random:
                initPoint = CGPoint(
                        randomBetweenNumbers(
                                firstNum: 0 - view.bounds.width,
                                secondNum: keyWindow.bounds.width + view.bounds.width
                        ),
                        0 - view.bounds.height
                )
            }
        case .bottom(let position):
            switch position {
            case .center:
                initPoint = CGPoint(keyWindow.bounds.midX, keyWindow.bounds.height)
            case .left:
                initPoint = CGPoint(0 - view.bounds.width, keyWindow.bounds.height)
            case .right:
                initPoint = CGPoint(keyWindow.bounds.width, keyWindow.bounds.height)
            case .random:
                initPoint = CGPoint(
                        randomBetweenNumbers(
                                firstNum: 0 - view.bounds.width,
                                secondNum: keyWindow.bounds.width + view.bounds.width
                        ),
                        keyWindow.bounds.height
                )
            }
        case .left:
            initPoint = CGPoint(0 - view.bounds.width, keyWindow.bounds.midY)
        case .right:
            initPoint = CGPoint(keyWindow.bounds.width, keyWindow.bounds.midY)
        case .custom(let point):
            initPoint = point
        }

        view.frame.origin = CGPoint.zero
        containerView.frame.origin = initPoint
        containerView.bounds = view.bounds
        containerView.backgroundColor = UIColor.clear
        containerView.addSubview(view)
        containerView.bringSubviewToFront(view)
        containerView.addGestureRecognizer(panRecognizer)
        containerView.addGestureRecognizer(tapRecognizer)
        containerView.addGestureRecognizer(longPressRecognizer)

        keyWindow.addSubview(containerView)

        if let delegate = delegate {
            delegate.noticeDidAppear(notice: self)
        }

        switch toPosition {
        case .bottom:
            snapPoint = CGPoint(x: keyWindow.bounds.midX, y: keyWindow.bounds.bottom - 50 - containerView.bounds.midY)
        case .center:
            snapPoint = keyWindow.bounds.center
        case .top:
            snapPoint = CGPoint(x: keyWindow.bounds.midX, y: 70 + containerView.bounds.height / 2)
        case .custom(let point):
            snapPoint = point
        }
        addSnap(view: containerView, toPoint: snapPoint) { (completed) in
            completion(completed)
        }
    }

    public func dismiss(completion: CompletionCallBack? = nil) {
        animator.removeAllBehaviors()

        if let gestureViewGestureRecognizers = containerView.gestureRecognizers {
            for gestureRecognizer in gestureViewGestureRecognizers {
                containerView.removeGestureRecognizer(gestureRecognizer)
            }
        }

        gravityBehaviour = UIGravityBehavior(items: [containerView])
        gravityBehaviour.action = { [weak self] in
            guard let self = self else { return }
            self.removeFromSuperView(completion: { [weak self] (completed) in
                guard let self = self else { return }
                if completed {
                    self.postDidDisappearNotification()
                    if let delegate = self.delegate {
                        delegate.noticeDidDisappear(notice: self)
                    }
                    completion?(true)
                }
            })
        }

        animator.addBehavior(gravityBehaviour)
    }

    func removeFromSuperView(completion: @escaping (_ completed: Bool) -> Void) {
        if containerView.superview != nil {
            //TOP
            if containerView.frame.top >= (containerView.superview!.bounds.bottom + fieldMargin) {
                containerView.removeFromSuperview()
                completion(true)
            }
            //BOTTOM
            else if (containerView.frame.bottom) <= (containerView.superview!.bounds.top - fieldMargin) {
                containerView.removeFromSuperview()
                completion(true)
            }
            //RIGHT
            else if (containerView.frame.right) <= (containerView.superview!.bounds.left - fieldMargin) {
                containerView.removeFromSuperview()
                completion(true)
            }
            //LEFT
            else if containerView.frame.left >= (containerView.superview!.bounds.right + fieldMargin) {
                containerView.removeFromSuperview()
                completion(true)
            } else {
                isHiding = true
                completion(false)
            }
        }
    }

    func addSnap(view: UIView, toPoint: CGPoint, completion: ((_ completed: Bool) -> Void)? = nil) {
        var counter = 0
        snapBehaviour = UISnapBehavior(item: view, snapTo: toPoint)
        snapBehaviour.damping = config.snapDamping
        snapBehaviour.action = {
            // Check if the view reach the snap point
            if self.distance(from: view.center, to: toPoint) < 1 && counter == 0 {
                counter += 1
                if let completion = completion {
                    completion(true)
                }
            } else {
                if let completion = completion {
                    completion(false)
                }
            }
        }
        animator.addBehavior(snapBehaviour)
    }

    func removeSnap(view: UIView) {
        animator.removeBehavior(snapBehaviour)
    }

    @objc func pan(gesture: UIPanGestureRecognizer) {
        let gestureView = gesture.view!
        let dragPoint: CGPoint = gesture.location(in: gestureView)
        let viewCenter = gestureView.center  //Center of message view in its superview
        let movedDistance = distance(from: snapPoint, to: viewCenter)

        let offsetFromCenterInView: UIOffset = UIOffset(
                horizontal: dragPoint.x - gestureView.bounds.midX,
                vertical: dragPoint.y - gestureView.bounds.midY
        )
        let velocity: CGPoint = gesture.velocity(in: gestureView.superview)
        let vector = CGVector(dx: (velocity.x), dy: (velocity.y))

        var lastTime: CFAbsoluteTime
        var lastAngle: CGFloat

        switch gesture.state {
                //Start Dragging
        case .began:
            postStartPanningNotification()

            if let delegate = delegate {
                delegate.noticeStartDragging(atPoint: dragPoint, notice: self)
            }
            animator.removeAllBehaviors()

            let anchorPoint: CGPoint = gesture.location(in: gestureView.superview)
            attachmentBehaviour = UIAttachmentBehavior(
                    item: gestureView,
                    offsetFromCenter: offsetFromCenterInView,
                    attachedToAnchor: anchorPoint
            )

            lastTime = CFAbsoluteTime()
            lastAngle = CGFloat(angleOfView(view: gestureView))

            attachmentBehaviour.action = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                //Calculate Angular Velocity
                let time = CFAbsoluteTimeGetCurrent()
                let angle = CGFloat(strongSelf.angleOfView(view: gestureView))
                if time > lastTime {
                    strongSelf.angularVelocity = (angle - lastAngle) / CGFloat((time - lastTime))
                    lastTime = time
                    lastAngle = angle
                }
            }

            animator.addBehavior(attachmentBehaviour)
                //Dragging
        case .changed:
            let touchPoint: CGPoint = gesture.location(in: gestureView.superview)
            attachmentBehaviour.anchorPoint = touchPoint
            if let delegate = delegate {
                delegate.noticeIsDragging(atPoint: touchPoint, notice: self)
            }
                // End Dragging
        case .ended:
            if let delegate = delegate {
                delegate.noticeEndDragging(atPoint: dragPoint, notice: self)
            }

            animator.removeAllBehaviors()

            if movedDistance < config.thresholdDistance {
                addSnap(view: gestureView, toPoint: snapPoint)
                postEndPanningNotDismissNotification()
            } else {
                animator.removeAllBehaviors()
                if let gestureViewGestureRecognizers = gestureView.gestureRecognizers {
                    for gestureRecognizer in gestureViewGestureRecognizers {
                        gestureView.removeGestureRecognizer(gestureRecognizer)
                    }
                }

                //Add Push Behaviour
                let pushBehavior = UIPushBehavior(items: [gestureView], mode: UIPushBehavior.Mode.instantaneous)
                pushBehavior.pushDirection = vector

                let pushMagnitude: CGFloat = pushBehavior.magnitude * config.pushForceFactor
                let massFactor: CGFloat = (gestureView.bounds.height * gestureView.bounds.width) / (100 * 100)

                pushBehavior.magnitude = (
                        pushMagnitude > config.minPushForce
                ) ? pushMagnitude * massFactor : config.defaultPushForce * massFactor
                //                pushBehavior.setTargetOffsetFromCenter(offsetFromCenterInWindow, for: gestureView)
                animator.addBehavior(pushBehavior)

                //Add Item Behaviour
                let itemBehaviour = UIDynamicItemBehavior(items: [gestureView])
                itemBehaviour.addAngularVelocity(angularVelocity * config.angularVelocityFactor, for: gestureView)
                itemBehaviour.angularResistance = config.angularResistance

                itemBehaviour.action = { [weak self] in
                    guard let self = self else { return }

                    self.removeFromSuperView(completion: { [weak self] (completed) in
                        guard let self = self else { return }
                        if completed {
                            self.postDidDisappearNotification()
                            if let delegate = self.delegate {
                                delegate.noticeDidDisappear(notice: self)
                            }
                        }
                    })
                }
                animator.addBehavior(itemBehaviour)
            }
        default:
            break
        }
    }

    @objc func onTap(gesture: UITapGestureRecognizer) {
        if let delegate = delegate {
            delegate.noticeIsTapped(notice: self)
        }

        if let tapAction = tapAction {
            tapAction(id)
        }
    }

    @objc func onLongPress(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            postStartPressingNotification()
        case .ended:
            postEndPressingNotification()
        default:
            break
        }
    }

    func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        let xDist = (to.x - from.x)
        let yDist = (to.y - from.y)
        return sqrt((xDist * xDist) + (yDist * yDist))
    }

    func angleOfView(view: UIView) -> Float {
        Float(atan2(view.transform.b, view.transform.a))
    }

    //http://stackoverflow.com/questions/26029393/random-number-between-two-decimals-in-swift
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }

    public override var description: String {
        "Notice(id: \(id))"
    }

    private func postStartPanningNotification() {
        postNotification(NoticeNotification.startPanning)
    }

    private func postEndPanningNotDismissNotification() {
        postNotification(NoticeNotification.endPanningNotDismiss)
    }

    private func postStartPressingNotification() {
        postNotification(NoticeNotification.startPressing)
    }

    private func postEndPressingNotification() {
        postNotification(NoticeNotification.endPressing)
    }

    private func postDidDisappearNotification() {
        postNotification(NoticeNotification.didDisappear)
    }

    private func postNotification(_ notificationName: Notification.Name) {
        NotificationCenter.default.post(
                name: notificationName,
                object: nil,
                userInfo: userInfo
        )
    }
}

extension Notice: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
            _ gestureRecognizer: UIGestureRecognizer,
            shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        gestureRecognizer == longPressRecognizer && otherGestureRecognizer == panRecognizer
    }
}
