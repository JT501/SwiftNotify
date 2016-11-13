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
    let tapRecognizer: UITapGestureRecognizer
    var animator: UIDynamicAnimator
    var startPoint: CGPoint
    var snapBehaviour : UISnapBehavior!
    var attachmentBehaviour : UIAttachmentBehavior!
    var gravityBehaviour : UIGravityBehavior!
    var collisionBehaviour : UICollisionBehavior!
    var isDismissing: Bool
    weak var delegate: MessengerDelegate?
    
    // Constants
    let fieldMargin: CGFloat = 300
    let minMagnitude : CGFloat = 8
    let magnitudePadding : CGFloat = 300
    let defaultMagnitude : CGFloat = 12
    let reduceAngularVelocityFactor : Float = 0.8
    
    init(config: CFMessage.Config, view: UIView, delegate: MessengerDelegate) {
        self.config = config
        self.view = view
        self.containerView = UIView()
        self.panRecognizer = UIPanGestureRecognizer()
        self.tapRecognizer = UITapGestureRecognizer()
        self.animator = UIDynamicAnimator()
        self.startPoint = CGPoint.zero
        self.isDismissing = false
        self.delegate = delegate
        
        super.init()
        self.panRecognizer.addTarget(self, action: #selector(Messenger.pan(gesture:)))
        self.tapRecognizer.addTarget(self, action: #selector(Messenger.tap(gesture:)))
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
            self.startPoint = CGPoint(x: keyWindow.bounds.size.width / 2, y: keyWindow.bounds.size.height - 30)
        case .center:
            self.startPoint = CGPoint(x: keyWindow.bounds.size.width / 2, y: keyWindow.bounds.size.height / 2)
        case .top:
            self.startPoint = CGPoint(x: keyWindow.bounds.size.width / 2, y: 30)
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
            if containerView.frame.origin.y >= (containerView.superview!.bounds.origin.y + containerView.superview!.bounds.size.height + fieldMargin) {
                self.containerView.removeFromSuperview()
                completion(true)
            }
            //BOTTOM
            else if (containerView.frame.origin.y + containerView.frame.size.height) <= (containerView.superview!.bounds.origin.y - fieldMargin) {
                self.containerView.removeFromSuperview()
                completion(true)
            }
            //RIGHT
            else if (containerView.frame.origin.x + containerView.frame.size.width) <= (containerView.superview!.bounds.origin.x - fieldMargin) {
                self.containerView.removeFromSuperview()
                completion(true)
            }
            //LEFT
            else if containerView.frame.origin.x >= (containerView.superview!.bounds.origin.x + containerView.superview!.bounds.size.width + fieldMargin) {
                self.containerView.removeFromSuperview()
                completion(true)
            }
            else {
                self.isDismissing = true
                completion(false)
            }
        }
    }
    
    func addSnap(view: UIView, toPoint: CGPoint, completion: @escaping (_ completed: Bool) -> Void) {
        var counter = 0
        snapBehaviour = UISnapBehavior(item: view, snapTo: toPoint)
        snapBehaviour.damping = 0.5
        snapBehaviour.action = {
            if self.distance(from: view.center, to: toPoint) < 1 && counter == 0 {
                counter += 1
                completion(true)
            } else {
                completion(false)
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
        let viewCenter = gestureView.center
        let movedDistance = distance(from: startPoint, to: viewCenter)

//        self._isDragging = true

        switch gesture.state {
        //Start Dragging
        case .began:
            if let delegate = self.delegate {
                delegate.messengerStartDragging(atPoint: dragPoint)
            }
            self.animator.removeAllBehaviors()
            
            let offsetFromCenter: UIOffset = UIOffsetMake(
                dragPoint.x - gestureView.bounds.size.width  / 2.0,
                dragPoint.y - gestureView.bounds.size.height / 2.0
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
            
//            self._isDragging = false
            self.animator.removeAllBehaviors()
            
            if movedDistance < 50 {
                addSnap(view: gestureView, toPoint: self.startPoint, completion: {_ in })
            }
            else
            {
                animator.removeAllBehaviors()
                gestureView.removeGestureRecognizer((gestureView.gestureRecognizers?[0])!)
                
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
