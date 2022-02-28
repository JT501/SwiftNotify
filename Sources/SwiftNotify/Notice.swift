//
//  Notifier.swift
//  SwiftNotify
//
//  Created by Johnny on 12/11/2016.
//  Copyright © 2016 Johnny Choi@Co-Fire. All rights reserved.
//

import UIKit

class Notice: NSObject, UIGestureRecognizerDelegate {

    var id: String = UUID().uuidString
    let config: SwiftNotify.Config
    let view: UIView
    let containerView: UIView
    let panRecognizer: UIPanGestureRecognizer
    let tapRecognizer: UITapGestureRecognizer
    var animator: UIDynamicAnimator
    var snapPoint: CGPoint
    var snapBehaviour: UISnapBehavior!
    var attachmentBehaviour: UIAttachmentBehavior!
    var gravityBehaviour: UIGravityBehavior!
    var collisionBehaviour: UICollisionBehavior!
    var isHiding: Bool
    weak var delegate: NotifierDelegate?
    var fieldMargin: CGFloat  //Margin to remove message from view
    var angularVelocity: CGFloat = 0
    let tapAction: (() -> Void)?

    lazy private var userInfo = [
        NoticeInfo.userInfoKey: NoticeInfo(id: self.id)
    ]

    init(config: SwiftNotify.Config, view: UIView, tapHandler: (() -> Void)?, delegate: NotifierDelegate) {
        self.config = config
        self.view = view
        containerView = UIView()
        panRecognizer = UIPanGestureRecognizer()
        tapRecognizer = UITapGestureRecognizer()
        animator = UIDynamicAnimator()
        snapPoint = CGPoint.zero
        isHiding = false
        self.delegate = delegate
        fieldMargin = (view.bounds.width > view.bounds.height) ? view.bounds.width : view.bounds.height
        tapAction = tapHandler

        super.init()
        panRecognizer.addTarget(self, action: #selector(Notice.pan(gesture:)))
        panRecognizer.maximumNumberOfTouches = 1
        tapRecognizer.addTarget(self, action: #selector(Notice.tap(gesture:)))
    }

    var hideTime: TimeInterval? {
        let duration: TimeInterval?
        switch config.hideTime {
        case .default:
            duration = 3.0
        case .never:
            duration = nil
        case .custom(let seconds):
            duration = seconds
        }
        return duration
    }

    func present(completion: @escaping (_ completed: Bool) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate else {
            return
        }
        guard let keyWindow = appDelegate.window! else {
            return
        }

        animator = UIDynamicAnimator(referenceView: keyWindow)

        let initPoint: CGPoint
        switch config.initPosition {
        case .top(let position):
            switch position {
            case .center:
                initPoint = CGPoint(keyWindow.bounds.midX, 0 - view.bounds.height)
            case .left:
                initPoint = CGPoint(0 - view.bounds.width, 0 - view.bounds.height)
            case .right:
                initPoint = CGPoint(keyWindow.bounds.width, 0 - view.bounds.height)
            case .random:
                initPoint = CGPoint(randomBetweenNumbers(firstNum: 0 - view.bounds.width, secondNum: keyWindow.bounds.width + view.bounds.width), 0 - view.bounds.height)
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
                initPoint = CGPoint(randomBetweenNumbers(firstNum: 0 - view.bounds.width, secondNum: keyWindow.bounds.width + view.bounds.width), keyWindow.bounds.height)
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
        if tapAction == nil {
            containerView.addGestureRecognizer(tapRecognizer)
        }

        keyWindow.addSubview(containerView)

        if let delegate = delegate {
            delegate.notifierDidAppear()
        }

        switch config.appearPosition {
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

    func hide() {
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
                        delegate.notifierDidDisappear(notifier: self)
                    }
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

        let offsetFromCenterInView: UIOffset = UIOffset(horizontal: dragPoint.x - gestureView.bounds.midX, vertical: dragPoint.y - gestureView.bounds.midY)
        let velocity: CGPoint = gesture.velocity(in: gestureView.superview)
        let vector = CGVector(dx: (velocity.x), dy: (velocity.y))

        var lastTime: CFAbsoluteTime
        var lastAngle: CGFloat

        switch gesture.state {
                //Start Dragging
        case .began:
            postStartDraggingNotification()

            if let delegate = delegate {
                delegate.notifierStartDragging(atPoint: dragPoint)
            }
            animator.removeAllBehaviors()

            let anchorPoint: CGPoint = gesture.location(in: gestureView.superview)
            attachmentBehaviour = UIAttachmentBehavior(item: gestureView, offsetFromCenter: offsetFromCenterInView, attachedToAnchor: anchorPoint)

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
                delegate.notifierIsDragging(atPoint: touchPoint)
            }
                //End Dragging
        case .ended:
            if let delegate = delegate {
                delegate.notifierEndDragging(atPoint: dragPoint)
            }

            animator.removeAllBehaviors()

            if movedDistance < config.thresholdDistance {
                addSnap(view: gestureView, toPoint: snapPoint)
                postEndDraggingNotDismissNotification()
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

                pushBehavior.magnitude = (pushMagnitude > config.minPushForce) ? pushMagnitude * massFactor : config.defaultPushForce * massFactor
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
                                delegate.notifierDidDisappear(notifier: self)
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

    @objc func tap(gesture: UITapGestureRecognizer) {
        if let delegate = delegate {
            delegate.notifierIsTapped()
        }
        if let tapAction = tapAction {
            tapAction()
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

    override var description: String {
        "Notice(id: \(id))"
    }

    private func postStartDraggingNotification() {
        postNotification(NoticeNotification.startDragging)
    }

    private func postEndDraggingNotDismissNotification() {
        postNotification(NoticeNotification.endDraggingNotDismiss)
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
