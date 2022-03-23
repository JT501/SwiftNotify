//
//  Notifier.swift
//  SwiftNotify
//
//  Created by Johnny on 12/11/2016.
//  Copyright © 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

open class Notice: NSObject, NoticeProtocol {
    public typealias TapCallback = (String) -> Void

    public let id: String
    public let config: PhysicsConfig
    public let view: UIView
    public let duration: DurationsEnum
    public let fromPosition: FromPositionsEnum
    public let toPosition: ToPositionsEnum
    public var tapAction: TapCallback?

    public private(set) var isDismissing: Bool

    weak var delegate: NoticeDelegate?

    internal let containerView: UIView
    internal let panRecognizer: UIPanGestureRecognizer
    internal let tapRecognizer: UITapGestureRecognizer
    internal let longPressRecognizer: UILongPressGestureRecognizer
    internal var animator: UIDynamicAnimator
    internal var snapPoint: CGPoint
    internal var snapBehaviour: UISnapBehavior!
    internal var attachmentBehaviour: UIAttachmentBehavior!
    internal var gravityBehaviour: UIGravityBehavior!
    internal var pushBehavior: UIPushBehavior!
    internal var itemBehaviour: UIDynamicItemBehavior!

    internal var fieldMargin: CGFloat  //Margin to remove message from view
    internal var angularVelocity: CGFloat = 0

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
            delegate: NoticeDelegate? = nil
    ) {
        self.id = id
        self.config = config
        self.view = view
        self.duration = duration
        self.fromPosition = fromPosition
        self.toPosition = toPosition
        self.delegate = delegate

        containerView = UIView()
        panRecognizer = TestablePanRecognizer()
        tapRecognizer = TestableTapRecognizer()
        longPressRecognizer = TestableLongPressRecognizer()
        animator = UIDynamicAnimator()
        snapPoint = CGPoint.zero
        isDismissing = false
        fieldMargin = (view.bounds.width > view.bounds.height) ? view.bounds.width : view.bounds.height
        tapAction = tapHandler

        super.init()

        panRecognizer.addTarget(self, action: #selector(onPan(gesture:)))
        panRecognizer.maximumNumberOfTouches = 1
        tapRecognizer.addTarget(self, action: #selector(onTap(gesture:)))
        longPressRecognizer.addTarget(self, action: #selector(onLongPress(gesture:)))
        longPressRecognizer.minimumPressDuration = 0.25
        longPressRecognizer.allowableMovement = 0
        longPressRecognizer.delegate = self
    }

    internal func getInitPoint(in window: UIWindow, fromPosition: FromPositionsEnum) -> CGPoint {
        switch fromPosition {
        case .top(let position):
            switch position {
            case .center:
                return CGPoint(x: window.bounds.midX, y: -view.bounds.height)
            case .left:
                return CGPoint(x: -view.bounds.width, y: -view.bounds.height)
            case .right:
                return CGPoint(x: window.bounds.width, y: -view.bounds.height)
            case .random:
                return CGPoint(
                        x: randomBetweenNumbers(
                                firstNum: -view.bounds.width,
                                secondNum: window.bounds.width + view.bounds.width
                        ),
                        y: -view.bounds.height
                )
            }
        case .bottom(let position):
            switch position {
            case .center:
                return CGPoint(x: window.bounds.midX, y: window.bounds.height)
            case .left:
                return CGPoint(x: -view.bounds.width, y: window.bounds.height)
            case .right:
                return CGPoint(x: window.bounds.width, y: window.bounds.height)
            case .random:
                return CGPoint(
                        x: randomBetweenNumbers(
                                firstNum: -view.bounds.width,
                                secondNum: window.bounds.width + view.bounds.width
                        ),
                        y: window.bounds.height
                )
            }
        case .left:
            return CGPoint(x: -view.bounds.width, y: window.bounds.midY)
        case .right:
            return CGPoint(x: window.bounds.width, y: window.bounds.midY)
        case .custom(let point):
            return point
        }
    }

    internal func getSnapPoint(in window: UIWindow, toPosition: ToPositionsEnum) -> CGPoint {
        switch toPosition {
        case .bottom(let offset):
            return CGPoint(x: window.bounds.midX, y: window.bounds.maxY - offset - containerView.bounds.midY)
        case .center:
            return window.center
        case .top(let offset):
            return CGPoint(x: window.bounds.midX, y: offset + containerView.bounds.minY)
        case .custom(let point):
            return point
        }
    }

    internal func addSnapBehaviour(
            for view: UIView,
            toPoint: CGPoint,
            completion: ((_ completed: Bool) -> Void)? = nil
    ) {
        var counter = 0
        snapBehaviour = UISnapBehavior(item: view, snapTo: toPoint)
        snapBehaviour.damping = config.snapDamping
        snapBehaviour.action = {
            // Check if the view reach the snap point
            if self.distance(from: view.center, to: toPoint) < 1 && counter == 0 {
                counter += 1
                completion?(true)
            } else {
                completion?(false)
            }
        }
        animator.addBehavior(snapBehaviour)
    }

    public func present(
            in window: UIWindow? = nil,
            completion: @escaping (_ completed: Bool) -> Void
    ) {
        let window = window ?? UIApplication.shared.delegate?.window!

        guard let window = window else { return }

        animator = UIDynamicAnimator(referenceView: window)

        let initPoint = getInitPoint(in: window, fromPosition: fromPosition)

        view.frame.origin = CGPoint.zero
        containerView.frame.origin = initPoint
        containerView.bounds = view.bounds
        containerView.backgroundColor = UIColor.clear
        containerView.addSubview(view)
        containerView.bringSubviewToFront(view)
        containerView.addGestureRecognizer(panRecognizer)
        containerView.addGestureRecognizer(tapRecognizer)
        containerView.addGestureRecognizer(longPressRecognizer)

        window.addSubview(containerView)

        if let delegate = delegate {
            delegate.noticeDidAppear(notice: self)
        }

        snapPoint = getSnapPoint(in: window, toPosition: toPosition)

        addSnapBehaviour(for: containerView, toPoint: snapPoint) { (completed) in
            completion(completed)
        }
    }

    internal func removeFromSuperView(completion: @escaping CompletionCallBack) {
        if containerView.superview != nil {
            //TOP
            if containerView.frame.minY >= (containerView.superview!.bounds.maxY + fieldMargin) {
                containerView.removeFromSuperview()
                completion(true)
            }
            //BOTTOM
            else if (containerView.frame.maxY) <= (containerView.superview!.bounds.minY - fieldMargin) {
                containerView.removeFromSuperview()
                completion(true)
            }
            //RIGHT
            else if (containerView.frame.maxX) <= (containerView.superview!.bounds.minX - fieldMargin) {
                containerView.removeFromSuperview()
                completion(true)
            }
            //LEFT
            else if containerView.frame.minX >= (containerView.superview!.bounds.maxY + fieldMargin) {
                containerView.removeFromSuperview()
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    public func dismiss(completion: CompletionCallBack? = nil) {
        isDismissing = true

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
                }
                completion?(completed)
            })
        }

        animator.addBehavior(gravityBehaviour)
    }

    @objc func onPan(gesture: UIPanGestureRecognizer) {
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
                delegate.noticeStartPanning(atPoint: dragPoint, notice: self)
            }
            animator.removeAllBehaviors()

            let anchorPoint: CGPoint = gesture.location(in: gestureView.superview)
            attachmentBehaviour = UIAttachmentBehavior(
                    item: gestureView,
                    offsetFromCenter: offsetFromCenterInView,
                    attachedToAnchor: anchorPoint
            )

            lastTime = CFAbsoluteTime()
            lastAngle = CGFloat(angleRotated(of: gestureView))

            attachmentBehaviour.action = { [weak self] in
                guard let self = self else {
                    return
                }
                //Calculate Angular Velocity
                let time = CFAbsoluteTimeGetCurrent()
                let angle = CGFloat(self.angleRotated(of: gestureView))
                if time > lastTime {
                    self.angularVelocity = (angle - lastAngle) / CGFloat((time - lastTime))
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
                delegate.noticeIsPanning(atPoint: touchPoint, notice: self)
            }
                // End Dragging
        case .ended:
            if let delegate = delegate {
                delegate.noticeEndPanning(atPoint: dragPoint, notice: self)
            }

            animator.removeAllBehaviors()

            if movedDistance < config.thresholdDistance {
                addSnapBehaviour(for: gestureView, toPoint: snapPoint)
                postEndPanningNotDismissNotification()
            } else {
                animator.removeAllBehaviors()

                if let gestureViewGestureRecognizers = gestureView.gestureRecognizers {
                    for gestureRecognizer in gestureViewGestureRecognizers {
                        gestureView.removeGestureRecognizer(gestureRecognizer)
                    }
                }

                //Add Push Behaviour
                pushBehavior = UIPushBehavior(items: [gestureView], mode: .instantaneous)
                pushBehavior.pushDirection = vector

                let pushMagnitude: CGFloat = pushBehavior.magnitude * config.pushForceFactor
                let massFactor: CGFloat = (gestureView.bounds.height * gestureView.bounds.width) / (100 * 100)

                if pushMagnitude < 1 {
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
                            }
                        })
                    }

                    animator.addBehavior(gravityBehaviour)
                } else {
                    pushBehavior.magnitude = (pushMagnitude > config.minPushForce) ?
                            pushMagnitude * massFactor : config.defaultPushForce * massFactor
                    //                pushBehavior.setTargetOffsetFromCenter(offsetFromCenterInWindow, for: gestureView)

                    animator.addBehavior(pushBehavior)

                    //Add Item Behaviour
                    itemBehaviour = UIDynamicItemBehavior(items: [gestureView])
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
            }
        default:
            break
        }
    }

    @objc func onTap(gesture: UITapGestureRecognizer) {
        if (gesture.state == .ended) {
            if let delegate = delegate {
                delegate.noticeIsTapped(notice: self)
            }

            if let tapAction = tapAction {
                tapAction(id)
            }
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

    private func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        let xDist = (to.x - from.x)
        let yDist = (to.y - from.y)
        return sqrt((xDist * xDist) + (yDist * yDist))
    }

    private func angleRotated(of view: UIView) -> Float {
        Float(atan2(view.transform.b, view.transform.a))
    }

    // http://stackoverflow.com/questions/26029393/random-number-between-two-decimals-in-swift
    private func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
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

    public override var description: String {
        "Notice(id: \(id))"
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
