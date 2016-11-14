//
//  Messager.swift
//  CFDraggableMessage
//
//  Created by Johnny on 12/11/2016.
//  Copyright © 2016 Johnny Choi@Co-Fire. All rights reserved.
//

import UIKit

class Messenger: NSObject {
    
    let config: CFMessage.Config
    let view: UIView
    let containerView: UIView
    let panRecognizer: UIPanGestureRecognizer
//    let panRecognizer2: UIPanGestureRecognizer
    let tapRecognizer: UITapGestureRecognizer
    var animator: UIDynamicAnimator
    var startPoint: CGPoint
    var snapBehaviour : UISnapBehavior!
    var attachmentBehaviour : UIAttachmentBehavior!
    var gravityBehaviour : UIGravityBehavior!
    var collisionBehaviour : UICollisionBehavior!
    var isDismissing: Bool
    weak var delegate: MessengerDelegate?
    var fieldMargin: CGFloat  //Margin to remove message from view
    
    // Constants
    let minMagnitude : CGFloat = 8
    let magnitudePadding : CGFloat = 300
    let defaultMagnitude : CGFloat = 12
    let reduceAngularVelocityFactor : Float = 0.8
    
    init(config: CFMessage.Config, view: UIView, delegate: MessengerDelegate) {
        self.config = config
        self.view = view
        self.containerView = UIView()
        self.panRecognizer = UIPanGestureRecognizer()
//        self.panRecognizer2 = UIPanGestureRecognizer()
        self.tapRecognizer = UITapGestureRecognizer()
        self.animator = UIDynamicAnimator()
        self.startPoint = CGPoint.zero
        self.isDismissing = false
        self.delegate = delegate
        self.fieldMargin = 300
        
        super.init()
        self.panRecognizer.addTarget(self, action: #selector(Messenger.pan(gesture:)))
//        self.panRecognizer2.addTarget(self, action: #selector(Messenger.pan(gesture:)))
        self.tapRecognizer.addTarget(self, action: #selector(Messenger.tap(gesture:)))
        self.fieldMargin = (view.bounds.width > view.bounds.height) ? view.bounds.width : view.bounds.height
    }
    
    var dismissTime: TimeInterval? {
        let duration: TimeInterval?
        switch self.config.dismissTime {
        case .default:
            duration = 2.0
        case .never:
            duration = nil
        case .custom(let seconds):
            duration = seconds
        }
        return duration
    }
    
    func show(completion: @escaping (_ completed: Bool) -> Void){
        guard let appDelegate = UIApplication.shared.delegate else { return }
        guard let keyWindow = appDelegate.window! else { return }
        
        self.animator = UIDynamicAnimator(referenceView: keyWindow)
        
        self.containerView.bounds = self.view.bounds
        self.containerView.backgroundColor = UIColor.clear
        self.containerView.addSubview(self.view)
        self.containerView.bringSubview(toFront: self.view)
        self.containerView.addGestureRecognizer(self.panRecognizer)
        if self.config.tapToDismiss {
            self.containerView.addGestureRecognizer(self.tapRecognizer)
        }
        
        keyWindow.addSubview(self.containerView)
        
        if let delegate = self.delegate {
            delegate.messengerDidAppear()
        }
        
        switch self.config.appearPosition {
        case .bottom:
            self.startPoint = CGPoint(x: keyWindow.bounds.midX, y: keyWindow.bounds.bottom - 30 - self.containerView.bounds.midY)
        case .center:
            self.startPoint = keyWindow.bounds.center
        case .top:
            self.startPoint = CGPoint(x: keyWindow.bounds.midX, y: 30 + self.containerView.bounds.midY)
        }
        self.addSnap(view: self.containerView, toPoint: self.startPoint) { (completed) in
            completion(completed)
        }
    }
    
    func dismiss() {
        self.animator.removeAllBehaviors()

        if let gestureViewGestureRecognizers = self.containerView.gestureRecognizers {
            for gestureRecongnizers in gestureViewGestureRecognizers {
                self.containerView.removeGestureRecognizer(gestureRecongnizers)
            }
        }

        self.gravityBehaviour = UIGravityBehavior(items: [self.containerView])
        self.gravityBehaviour.action = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.removeFromSuperView(completion: { (completed) in
                if let delegate = strongSelf.delegate, completed {
                    delegate.messengerDidDisappear(messenger: strongSelf)
                }
            })
        }
        
        self.animator.addBehavior(self.gravityBehaviour)
    }
    
    func removeFromSuperView(completion: @escaping (_ completed: Bool) -> Void) {
        if self.containerView.superview != nil {
            //TOP
            if containerView.frame.top >= (containerView.superview!.bounds.bottom + fieldMargin) {
                self.containerView.removeFromSuperview()
                completion(true)
            }
            //BOTTOM
            else if (containerView.frame.bottom) <= (containerView.superview!.bounds.top - fieldMargin) {
                self.containerView.removeFromSuperview()
                completion(true)
            }
            //RIGHT
            else if (containerView.frame.right) <= (containerView.superview!.bounds.left - fieldMargin) {
                self.containerView.removeFromSuperview()
                completion(true)
            }
            //LEFT
            else if containerView.frame.left >= (containerView.superview!.bounds.right + fieldMargin) {
                self.containerView.removeFromSuperview()
                completion(true)
            }
            else {
                self.isDismissing = true
                completion(false)
            }
        }
    }
    
    func addSnap(view: UIView, toPoint: CGPoint, completion: ((_ completed: Bool) -> Void)? = nil) {
        var counter = 0
        snapBehaviour = UISnapBehavior(item: view, snapTo: toPoint)
        snapBehaviour.damping = 0.5
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
        self.animator.addBehavior(snapBehaviour)
    }
    
    func removeSnap(view: UIView) {
        self.animator.removeBehavior(snapBehaviour)
    }
    
    func pan(gesture: UIPanGestureRecognizer) {
        let gestureView = gesture.view!
        let dragPoint : CGPoint = gesture.location(in: gestureView)
        let viewCenter = gestureView.center  //Center of message view in its superview
        let movedDistance = distance(from: startPoint, to: viewCenter)
        
        let offsetFromCenterInView: UIOffset = UIOffset(horizontal: dragPoint.x - gestureView.bounds.midX, vertical: dragPoint.y - gestureView.bounds.midY)
        var dragAngleInView : Float = atan2f(Float(offsetFromCenterInView.vertical), Float(offsetFromCenterInView.horizontal))
        dragAngleInView = (dragAngleInView > 0)  ? dragAngleInView - Float(M_PI*2) : dragAngleInView
//        print("dragAngleInView = \(dragAngleInView*180 / Float(M_PI))")
        
        let dragPointInWindow : CGPoint = gesture.location(in: gestureView.superview)
        let offsetFromCenterInWindow : UIOffset = UIOffset(horizontal: dragPointInWindow.x - viewCenter.x, vertical: dragPointInWindow.y - viewCenter.y)
        var dragAngleInWindow : Float = atan2f(Float(offsetFromCenterInWindow.vertical), Float(offsetFromCenterInWindow.horizontal))
        dragAngleInWindow = (dragAngleInWindow > 0) ? dragAngleInWindow - Float(M_PI*2) : dragAngleInWindow
//        print("dragAngleInWindow = \(dragAngleInWindow*180 / Float(M_PI))")
        
        var actualDraggedAngle = fabsf(dragAngleInWindow) - fabsf(dragAngleInView)
        actualDraggedAngle = (actualDraggedAngle > 0) ? actualDraggedAngle - Float(M_PI*2) : actualDraggedAngle
        actualDraggedAngle = fabsf(actualDraggedAngle)
        print("actualDraggedAngle = \(actualDraggedAngle*180 / Float(M_PI))")
        
        switch gesture.state {
        //Start Dragging
        case .began:
            if let delegate = self.delegate {
                delegate.messengerStartDragging(atPoint: dragPoint)
            }
            self.animator.removeAllBehaviors()
            
            let offsetFromCenter: UIOffset = UIOffsetMake(
                dragPoint.x - gestureView.bounds.midX,
                dragPoint.y - gestureView.bounds.midY
            )
            let anchorPoint: CGPoint = gesture.location(in: gestureView.superview)
            
            attachmentBehaviour = UIAttachmentBehavior(item: gestureView, offsetFromCenter: offsetFromCenter, attachedToAnchor: anchorPoint)
            self.animator.addBehavior(attachmentBehaviour)
        //Dragging
        case .changed:
            let touchPoint : CGPoint = gesture.location(in: gestureView.superview)
            attachmentBehaviour.anchorPoint = touchPoint
        //End Dragging
        case .ended:
            if let delegate = self.delegate {
                delegate.messengerEndDragging(atPoint: dragPoint)
            }

            self.animator.removeAllBehaviors()
            
            if movedDistance < self.config.thresholdDistance {
                addSnap(view: gestureView, toPoint: self.startPoint)
            }
            else
            {
                animator.removeAllBehaviors()
                if let gestureViewGestureRecognizers = gestureView.gestureRecognizers {
                    for gestureRecongnizers in gestureViewGestureRecognizers {
                        gestureView.removeGestureRecognizer(gestureRecongnizers)
                    }
                }
                
                let velocity: CGPoint = gesture.velocity(in: gestureView.superview)
                let vector = CGVector(dx: (velocity.x), dy: (velocity.y))
                
                //Add Push Behaviour
                let pushBehavior = UIPushBehavior(items: [gestureView], mode: UIPushBehaviorMode.instantaneous)
                pushBehavior.pushDirection = vector
                
                let pushMagnitude : CGFloat = pushBehavior.magnitude / magnitudePadding
                
                pushBehavior.magnitude = (pushMagnitude > minMagnitude) ? pushMagnitude : defaultMagnitude
                self.animator.addBehavior(pushBehavior)
                
                //Add Item Behaviour
                let itemBehaviour = UIDynamicItemBehavior(items: [gestureView])
                
                // calculate angles needed for angular velocity formula
                // https://github.com/u10int/URBMediaFocusViewController/blob/master/URBMediaFocusViewController.m#L691-L731
                let offsetFromCenter : UIOffset = UIOffset(horizontal: dragPoint.x - gestureView.bounds.midX, vertical: dragPoint.y - gestureView.bounds.midY)
                let radius = sqrtf(powf(Float(offsetFromCenter.horizontal), 2.0) + powf(Float(offsetFromCenter.vertical), 2.0))
                let velocityAngle : Float = atan2f(Float(velocity.y), Float(velocity.x))
                var locationAngle : Float = atan2f(Float(offsetFromCenter.vertical), Float(offsetFromCenter.horizontal))
                
                
                if (locationAngle > 0) {
                    locationAngle -= Float(M_PI * 2)
                }
                
                // rotation direction is dependent upon which corner was pushed relative to the center of the view
                // when velocity.y is positive, pushes to the right of center rotate clockwise, left is counterclockwise
                var direction : CGFloat = (dragPoint.x < gestureView.center.x) ? -1.0 : 1.0
                // when y component of velocity is negative, reverse direction
                if (velocity.y < 0) {
                    direction *= -1
                }
                
                if ((actualDraggedAngle*180 / Float(M_PI)) > 180 && offsetFromCenter.horizontal > 0) {
                    direction *= -1
                } else if ((actualDraggedAngle*180 / Float(M_PI)) < 180 && offsetFromCenter.horizontal < 0) {
                    direction *= -1
                }
                
                // angle (θ) is the angle between the push vector (V) and vector component parallel to radius, so it should always be positive
                let angle : Float = fabs(fabs(velocityAngle) - fabs(locationAngle))
                // angular velocity formula: w = (abs(V) * sin(θ)) / abs(r)
                var angularVelocity : Float = fabs((Float(fabs(pushMagnitude*magnitudePadding)) * sinf(angle)) / fabs(radius))
                
                // amount of angular velocity should be relative to how close to the edge of the view the force originated
                // angular velocity is reduced the closer to the center the force is applied
                // for angular velocity: positive = clockwise, negative = counterclockwise
                let xRatioFromCenter : CGFloat = fabs(offsetFromCenter.horizontal) / (gestureView.bounds.size.width / 2.0)
                let yRatioFromCetner : CGFloat = fabs(offsetFromCenter.vertical) / (gestureView.bounds.size.height / 2.0)
                angularVelocity *= (Float((xRatioFromCenter + yRatioFromCetner)) / 2.0);
                // reduce the angularVelocity (trial & error)
                angularVelocity *= reduceAngularVelocityFactor
                
                itemBehaviour.allowsRotation = true
                itemBehaviour.addAngularVelocity(CGFloat(angularVelocity) * direction, for: gestureView)
                itemBehaviour.action = { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.removeFromSuperView(completion: { [weak self] (completed) in
                        guard let strongSelf = self else { return }
                        if let delegate = strongSelf.delegate, completed {
                            delegate.messengerDidDisappear(messenger: strongSelf)
                        }
                    })
                }
                self.animator.addBehavior(itemBehaviour)
            }
        default:
            break
        }
    }
    
    func tap(gesture: UITapGestureRecognizer) {
        if let delegate = self.delegate {
            delegate.messengerIsTapped()
        }
    }
    
    func distance(from:CGPoint, to:CGPoint) -> CGFloat {
        let xDist = (to.x - from.x)
        let yDist = (to.y - from.y)
        return sqrt((xDist * xDist) + (yDist * yDist))
    }
}
