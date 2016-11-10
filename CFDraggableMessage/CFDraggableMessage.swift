//
//  CFDraggableMessage.swift
//  Dynamic Demo
//
//  Created by Johnny Choi on 9/11/2016.
//  Copyright © 2016 Johnny@Co-fire. All rights reserved.
//

import UIKit

open class CFDraggableMessage: NSObject {
    
    let fieldMargin : CGFloat = 300
    let minMagnitude : CGFloat = 8
    let magnitudePadding : CGFloat = 300
    let defaultMagnitude : CGFloat = 12
    let reduceAngularVelocityFactor : Float = 0.8
    
    open var delegate: CFMessageDelegate!
    open var isAutoDismiss : Bool = true
    open var autoDismissDelay : TimeInterval = 2.0
    
    var messageViews: [UIView] = []
    var messageLabels: [UILabel] = []
    var containerViews: [UIView] = []
    var panGesture : UIPanGestureRecognizer!
    var tapGesture : UITapGestureRecognizer!
    var animator : UIDynamicAnimator!
    var gravityBehaviour : UIGravityBehavior!
    var collisionBehaviour : UICollisionBehavior!
    var attachmentBehaviour : UIAttachmentBehavior!
    var snapBehaviour : UISnapBehavior!
    
    var tapAction: (()->Void)? = nil
    var dismissAction: (()->Void)? = nil
    var startpoint = CGPoint()
    var _isDragging: Bool = false
    var _isShowing: Bool = false
    let sysnQueue = DispatchQueue(label: "CFMessage.Queue", attributes: [])
    
    public override init() {
        super.init()
    }
    
    // MARK: - Public Method
    open func setDidTapAction(_ action: @escaping ()->Void ) {
        tapAction = action
    }
    
    open func setDidDismissAction(_ action: @escaping ()->Void) {
        dismissAction = action
    }
    
    open func isDragging() -> Bool {
        return self._isDragging
    }
    
    open func isShowing() -> Bool {
        return self._isShowing
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
    
    open func showMessage(withText text: String) {
        let view = createMessageView(withText: text)
        self.showMessage(withView: view)
    }
    
    open func showMessage(withView view: UIView) {
        
        guard let appDelegate = UIApplication.shared.delegate else { return }
        guard let keyWindow = appDelegate.window! else { return }
        
        self.animator = UIDynamicAnimator(referenceView: keyWindow)
        
        self.messageViews.append(view)
        guard let messageView = self.messageViews.last else { return }
        
        self.containerViews.append(UIView())
        guard let containerView = self.containerViews.last else { return }
        
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(CFDraggableMessage.pan))
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(CFDraggableMessage.tap))
        containerView.addGestureRecognizer(self.panGesture)
        containerView.addGestureRecognizer(self.tapGesture)
        containerView.isUserInteractionEnabled = true
        
        containerView.frame = CGRect(x: 0, y: 0, width: 250, height: 70)
        containerView.backgroundColor = UIColor.clear
        containerView.addSubview(messageView)
        containerView.bringSubview(toFront: messageView)
        
        keyWindow.addSubview(containerView)
        self._isShowing = true
        if let delegate = self.delegate {
            delegate.cfMessageDidAppear()
        }
        
        self.startpoint = keyWindow.center
        self.addSnap(view: containerView, toPoint: self.startpoint)
//        self.queueAutoDismiss()
    }
    
    open func dismissMessage() {
        if let containerView = self.containerViews.last {
            self.dismissMessage(messageView: containerView)
        }
        else {
            print("No container view")
        }
    }
    
    // MARK: - Private Method
    // MARK: Gesture Recognizer
    func pan(gesture: UIPanGestureRecognizer) {
        let gestureView = gesture.view!
        let dragPoint : CGPoint = gesture.location(in: gestureView)
        let viewCenter = gestureView.center
        let movedDistance = distance(from: startpoint, to: viewCenter)
        
        self._isDragging = true
        
        if let delegate = self.delegate {
            delegate.cfMessageIsDragging(atPoint: dragPoint)
        }
        
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
            self._isDragging = false
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
                itemBehaviour.action = { [weak self] in self?.removeView(view: gestureView) }
                self.animator.addBehavior(itemBehaviour)
            }
        }
    }
    
    func tap(gesture: UITapGestureRecognizer) {
        guard let gestureView = gesture.view else { return }
        
        // Message Did Tap Delegation
        if let delegate = self.delegate {
            delegate.cfMessageDidTap()
        }
        else if let tapAction = self.tapAction {
            tapAction()
        }
        
        dismissMessage(messageView: gestureView)
    }
    
    // MARK: Uilties Methods
    func queueAutoDismiss() {
        let dismissTime = DispatchTime.now() + autoDismissDelay
        sysnQueue.asyncAfter(deadline: dismissTime, execute: { [weak self] in
            guard let strongself = self else { return }
            guard let containerView = strongself.containerViews.last else { return }
            strongself.dismissMessage(messageView: containerView)
        })
    }
    
    func dismissMessage(messageView: UIView) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
        
            strongSelf.animator.removeAllBehaviors()
            
            if let gestureViewGestureRecognizers = messageView.gestureRecognizers {
                for gestureRecongnizers in gestureViewGestureRecognizers {
                    messageView.removeGestureRecognizer(gestureRecongnizers)
                }
            }
            
            strongSelf.gravityBehaviour = UIGravityBehavior(items: [messageView])
            strongSelf.gravityBehaviour.action = { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.removeView(view: messageView)
            }
            strongSelf.animator.addBehavior((strongSelf.gravityBehaviour)!)
            
            // Message Did Tap Delegation
            if let delegate = strongSelf.delegate {
                delegate.cfMessageDidDismiss()
            }
            else if let dismissAction = strongSelf.dismissAction {
                dismissAction()
            }
        }
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
        guard let containerView = self.containerViews.last else { return }
        containerView.removeFromSuperview()
        self.containerViews.removeLast()
        
        guard let messageView = self.messageViews.last else { return }
        self.messageViews.removeLast()
        
        guard let messageLabel = self.messageLabels.last else { return }
        self.messageLabels.removeLast()
        
        self._isShowing = false
    }
    
    func removeView(view: UIView) {
        if view.superview != nil {
            //TOP
            if view.frame.origin.y >= (view.superview!.bounds.origin.y + view.superview!.bounds.size.height + fieldMargin) {
                self.resetViews()
            }
            //BOTTOM
            else if (view.frame.origin.y + view.frame.size.height) <= (view.superview!.bounds.origin.y - fieldMargin) {
                self.resetViews()
            }
            //RIGHT
            else if (view.frame.origin.x + view.frame.size.width) <= (view.superview!.bounds.origin.x - fieldMargin) {
                self.resetViews()
            }
            //LEFT
            else if view.frame.origin.x >= (view.superview!.bounds.origin.x + view.superview!.bounds.size.width + fieldMargin) {
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
