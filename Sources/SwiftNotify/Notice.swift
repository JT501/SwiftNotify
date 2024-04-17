//
//  Notifier.swift
//  SwiftNotify
//
//  Created by Johnny on 12/11/2016.
//  Copyright © 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

/// A Notice object which stores the configuration and handles all the interactions and animations.
open class Notice: NSObject, NoticeProtocol {

    /// Type alias for on tap closure.
    public typealias TapCallback = (String) -> Void

    public let id: String
    public private(set) var isDismissing: Bool
    public let duration: Duration

    /// Configurations for animations physics.
    public let config: PhysicsConfig

    /// The notice view.
    public let view: UIView

    /// The position where the notice should be created.
    public let fromPosition: FromPosition

    /// The position of the window where the notice will snap to.
    public let toPosition: ToPosition

    /// Handler closure when the notice is tapped
    public var tapHandler: TapCallback?

    /// Delegate for the notice
    weak var delegate: SwiftNotifyDelegate?

    /// String description of the notice
    public override var description: String {
        "Notice(id: \(id))"
    }

    let containerView: UIView
    let panRecognizer: UIPanGestureRecognizer
    let tapRecognizer: UITapGestureRecognizer
    let longPressRecognizer: UILongPressGestureRecognizer
    var animator: UIDynamicAnimator
    var snapPoint: CGPoint
    var snapBehaviour: UISnapBehavior!
    var attachmentBehaviour: UIAttachmentBehavior!
    var gravityBehaviour: UIGravityBehavior!
    var pushBehavior: UIPushBehavior!
    var itemBehaviour: UIDynamicItemBehavior!

    var fieldMargin: CGFloat  //Margin to remove message from view
    var angularVelocity: CGFloat = 0

    lazy private var userInfo: [AnyHashable: NoticeInfo] = [
        NoticeInfo.userInfoKey: NoticeInfo(id: id)
    ]

    override convenience init() {
        self.init(view: UIView(),
                  duration: .short,
                  fromPosition: .top(.random),
                  toPosition: .center,
                  tapHandler: nil,
                  config: SN.defaultPhysicsConfig)
    }

    /// Create a notice object
    ///
    /// - Parameters:
    ///   - id: Notice id. A random `UUID` string by default.
    ///   - view: Notice view.
    ///   - duration: he duration notice will stay on screen.
    ///    It will be auto dismissed when the duration passed.
    ///   - fromPosition: The position where the notice should be created.
    ///   - toPosition: The position of the window where the notice will be presented.
    ///   - tapHandler: Handler closure when the notice is tapped
    ///   - config: Configurations for animations physics.
    ///   - delegate: Delegate for the notice
    public init(
            id: String = UUID().uuidString,
            view: UIView,
            duration: Duration,
            fromPosition: FromPosition,
            toPosition: ToPosition,
            tapHandler: TapCallback?,
            config: PhysicsConfig,
            delegate: SwiftNotifyDelegate? = nil
    ) {
        self.id = id
        self.config = config
        self.view = view
        self.duration = duration
        self.fromPosition = fromPosition
        self.toPosition = toPosition
        self.delegate = delegate
        self.tapHandler = tapHandler

        containerView = UIView()
        panRecognizer = TestablePanRecognizer()
        tapRecognizer = TestableTapRecognizer()
        longPressRecognizer = TestableLongPressRecognizer()
        animator = UIDynamicAnimator()
        snapPoint = CGPoint.zero
        isDismissing = false
        fieldMargin = (view.bounds.width > view.bounds.height) ? view.bounds.width : view.bounds.height

        super.init()

        panRecognizer.addTarget(self, action: #selector(onPan(gesture:)))
        panRecognizer.maximumNumberOfTouches = 1
        tapRecognizer.addTarget(self, action: #selector(onTap(gesture:)))
        longPressRecognizer.addTarget(self, action: #selector(onLongPress(gesture:)))
        longPressRecognizer.minimumPressDuration = 0.25
        longPressRecognizer.allowableMovement = 0
        longPressRecognizer.delegate = self
    }

    func getInitPoint(in window: UIWindow, fromPosition: FromPosition) -> CGPoint {
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

    func getSnapPoint(in window: UIWindow, toPosition: ToPosition) -> CGPoint {
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

    func addSnapBehaviour(
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
            delegate.swiftNotifyDidAppear(notice: self)
        }

        snapPoint = getSnapPoint(in: window, toPosition: toPosition)

        addSnapBehaviour(for: containerView, toPoint: snapPoint) { (completed) in
            completion(completed)
        }
    }

    func removeFromSuperView(completion: @escaping CompletionCallBack) {
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
                        delegate.swiftNotifyDidDisappear(notice: self)
                    }
                }
                completion?(completed)
            })
        }

        animator.addBehavior(gravityBehaviour)
    }

    @objc private func onPan(gesture: UIPanGestureRecognizer) {
        let gestureView = gesture.view!
        let dragPoint: CGPoint = gesture.location(in: gestureView)
        let viewCenter = gestureView.center  //Center of message view in its superview
        let movedDistance = distance(from: snapPoint, to: viewCenter)

        let offsetFromCenterInView: UIOffset = UIOffset(
                horizontal: dragPoint.x - gestureView.bounds.midX,
                vertical: dragPoint.y - gestureView.bounds.midY
        )
        let velocity: CGPoint = gesture.velocity(in: gestureView.superview)
        let velocityMagnitude = sqrt(pow(velocity.x, 2) + pow(velocity.y, 2))

        var lastTime: CFAbsoluteTime
        var lastAngle: CGFloat

        switch gesture.state {
                //Start Dragging
        case .began:
            postStartPanningNotification()

            if let delegate = delegate {
                delegate.swiftNotifyStartPanning(at: dragPoint, notice: self)
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
                delegate.swiftNotifyIsPanning(at: touchPoint, notice: self)
            }
                // End Dragging
        case .ended:
            if let delegate = delegate {
                delegate.swiftNotifyEndPanning(at: dragPoint, notice: self)
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

                if velocityMagnitude < 100 {
                    gravityBehaviour = UIGravityBehavior(items: [containerView])
                    gravityBehaviour.action = { [weak self] in
                        guard let self = self else { return }
                        self.removeFromSuperView(completion: { [weak self] (completed) in
                            guard let self = self else { return }
                            if completed {
                                self.postDidDisappearNotification()
                                if let delegate = self.delegate {
                                    delegate.swiftNotifyDidDisappear(notice: self)
                                }
                            }
                        })
                    }

                    animator.addBehavior(gravityBehaviour)
                } else {
                    // If too slow, add some push
                    if (velocityMagnitude < 800) {
                        pushBehavior = UIPushBehavior(items: [gestureView], mode: .instantaneous)
                        pushBehavior.setAngle(atan2(velocity.y, velocity.x), magnitude: 12)

                        animator.addBehavior(pushBehavior)
                    }

                    //Add Item Behaviour
                    itemBehaviour = UIDynamicItemBehavior(items: [gestureView])
                    itemBehaviour.addAngularVelocity(angularVelocity, for: gestureView)
                    itemBehaviour.addLinearVelocity(velocity, for: gestureView)
                    itemBehaviour.angularResistance = config.angularResistance

                    itemBehaviour.action = { [weak self] in
                        guard let self = self else { return }

                        self.removeFromSuperView(completion: { [weak self] (completed) in
                            guard let self = self else { return }
                            if completed {
                                self.postDidDisappearNotification()
                                if let delegate = self.delegate {
                                    delegate.swiftNotifyDidDisappear(notice: self)
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

    @objc private func onTap(gesture: UITapGestureRecognizer) {
        if (gesture.state == .ended) {
            if let delegate = delegate {
                delegate.swiftNotifyIsTapped(notice: self)
            }

            if let tapAction = tapHandler {
                tapAction(id)
            }
        }
    }

    @objc private func onLongPress(gesture: UILongPressGestureRecognizer) {
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
}

extension Notice: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
            _ gestureRecognizer: UIGestureRecognizer,
            shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        gestureRecognizer == longPressRecognizer && otherGestureRecognizer == panRecognizer
    }
}
