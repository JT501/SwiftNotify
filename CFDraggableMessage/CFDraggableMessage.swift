//
//  CFDraggableMessage.swift
//  Dynamic Demo
//
//  Created by Johnny Choi on 9/11/2016.
//  Copyright © 2016 Johnny@Co-fire. All rights reserved.
//

import Foundation
import UIKit

open class CFDraggableMessage: NSObject {
    
    let fieldMargin : CGFloat = 300
    let minMagnitude : CGFloat = 8
    let magnitudePadding : CGFloat = 300
    let defaultMagnitude : CGFloat = 12
    let reduceAngularVelocityFactor : Float = 0.8
    
    var messageView: UIView!
    var messageLabel: UILabel!
    var containerView: UIView!
    var panGesture : UIPanGestureRecognizer!
    var tapGesture : UITapGestureRecognizer!
    var animator : UIDynamicAnimator!
    var gravityBehaviour : UIGravityBehavior!
    var collisionBehaviour : UICollisionBehavior!
    var attachmentBehaviour : UIAttachmentBehavior!
    var snapBehaviour : UISnapBehavior!
    var startpoint = CGPoint()
    
    public override init() {
        super.init()
    }
    
    open func createMessageView(withText text: String) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 70))
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = UIColor.black
        
        let viewLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 70))
        viewLabel.text = text
        viewLabel.textAlignment = .center
        viewLabel.textColor = UIColor.white
        viewLabel.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2)
        view.addSubview(viewLabel)
        
        return view
    }
    
    open func showMessage(withText text: String, viewController: UIViewController) {
        let view = createMessageView(withText: text)
        self.showMessage(withView: view, viewController: viewController)
    }
    
    open func showMessage(withView view: UIView, viewController: UIViewController) {
        
        guard let appDelegate = UIApplication.shared.delegate else { return }
        guard let keyWindow = appDelegate.window! else { return }
        
        self.animator = UIDynamicAnimator(referenceView: keyWindow)
        
        self.messageView = view
        
        self.containerView = UIView()
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(CFDraggableMessage.pan))
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(CFDraggableMessage.tap))
        self.containerView.addGestureRecognizer(self.panGesture)
        self.containerView.addGestureRecognizer(self.tapGesture)
        self.containerView.isUserInteractionEnabled = true
        
        self.containerView.frame = CGRect(x: 0, y: 0, width: 250, height: 70)
        self.containerView.backgroundColor = UIColor.clear
        self.containerView.addSubview(self.messageView)
        self.containerView.bringSubview(toFront: self.messageView)
        self.messageView.autoresizingMask = [.flexibleWidth]
        self.containerView.autoresizingMask = [.flexibleWidth]
        
        keyWindow.addSubview(self.containerView)
        
        self.startpoint = keyWindow.center
        self.addSnap(view: self.containerView, toPoint: self.startpoint)
    }
    
    open func dismissMessage() {
        if let containerView = self.containerView {
            self.dismissMessage(messageView: containerView)
        }
        else {
            print("No container view")
        }
    }
    
    // MARK: - Private Method
    func pan(gesture: UIPanGestureRecognizer) {
        let gestureView = gesture.view!
        let dragPoint : CGPoint = gesture.location(in: gestureView)
        let viewCenter = gestureView.center
        let movedDistance = distance(from: startpoint, to: viewCenter)
        
        if gesture.state == UIGestureRecognizerState.began {
            //Start Dragging
            removeSnap(view: gestureView)
            
            let offsetFromCenter: UIOffset = UIOffsetMake(
                dragPoint.x - gestureView.bounds.size.width  / 2.0,
                dragPoint.y - gestureView.bounds.size.height / 2.0
            )
            let anchorPoint: CGPoint = gesture.location(in: gestureView.superview)
            
            attachmentBehaviour = UIAttachmentBehavior(item: gestureView, offsetFromCenter: offsetFromCenter, attachedToAnchor: anchorPoint)
            self.animator.addBehavior(attachmentBehaviour)
        }
        else if gesture.state == UIGestureRecognizerState.changed {
            //Dragging
            let touchPoint : CGPoint = gesture.location(in: gestureView.superview)
            attachmentBehaviour.anchorPoint = touchPoint
        }
        else if gesture.state == UIGestureRecognizerState.ended {
            self.animator.removeAllBehaviors()
            
            if movedDistance < 50 {
                addSnap(view: gestureView, toPoint: self.startpoint)
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
                itemBehaviour.action = { [weak self] in self?.removeView(gestureView: gestureView) }
                self.animator.addBehavior(itemBehaviour)
            }
        }
    }
    
    func dismissMessage(messageView: UIView) {
        animator.removeAllBehaviors()
        
        if let gestureViewGestureRecognizers = messageView.gestureRecognizers {
            for gestureRecongnizers in gestureViewGestureRecognizers {
                messageView.removeGestureRecognizer(gestureRecongnizers)
            }
        }
        
        gravityBehaviour = UIGravityBehavior(items: [messageView])
        gravityBehaviour.action = { [weak self] in
            self?.removeView(gestureView: messageView)
        }
        animator.addBehavior(gravityBehaviour)
    }
    
    
    func tap(gesture: UITapGestureRecognizer) {
        guard let gestureView = gesture.view else { return }
        dismissMessage(messageView: gestureView)
    }
    
    func addSnap(view: UIView, toPoint: CGPoint) {
        snapBehaviour = UISnapBehavior(item: view, snapTo: toPoint)
        snapBehaviour.damping = 0.5
        self.animator.addBehavior(snapBehaviour)
    }
    
    func removeSnap(view: UIView) {
        self.animator.removeBehavior(snapBehaviour)
    }
    
    func resetViews() {
        print("view removed")
        self.containerView.removeFromSuperview()
        self.containerView = nil
        self.messageView = nil
        self.messageLabel = nil
    }
    
    func removeView(gestureView: UIView) {
        if gestureView.superview != nil {
            if gestureView.frame.origin.y >= (gestureView.superview!.bounds.origin.y + gestureView.superview!.bounds.size.height + 250) {
                self.resetViews()
            }
            else if (gestureView.frame.origin.y + gestureView.frame.size.height) <= (gestureView.superview!.bounds.origin.y - 250) {
                self.resetViews()
            }
            else if (gestureView.frame.origin.x + gestureView.frame.size.width) <= (gestureView.superview!.bounds.origin.x - 250) {
                self.resetViews()
            }
            else if gestureView.frame.origin.x >= (gestureView.superview!.bounds.origin.x + gestureView.frame.size.width + 250 ) {
                self.resetViews()
            }
        }
    }
    
    func distance(from:CGPoint, to:CGPoint) -> CGFloat {
        let xDist = (to.x - from.x)
        let yDist = (to.y - from.y)
        return sqrt((xDist * xDist) + (yDist * yDist))
    }
}
