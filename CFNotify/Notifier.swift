//
//  Messager.swift
//  CFNotify
//
//  Created by Johnny on 12/11/2016.
//  Copyright © 2016 Johnny Choi@Co-Fire. All rights reserved.
//

import UIKit

class Notifier: NSObject, UIGestureRecognizerDelegate {
    
    let config: CFNotify.Config
    let view: UIView
    let containerView: UIView
    let panRecognizer: UIPanGestureRecognizer
    let tapRecognizer: UITapGestureRecognizer
    var animator: UIDynamicAnimator
    var snapPoint: CGPoint
    var snapBehaviour : UISnapBehavior!
    var attachmentBehaviour : UIAttachmentBehavior!
    var gravityBehaviour : UIGravityBehavior!
    var collisionBehaviour : UICollisionBehavior!
    var isHidding: Bool
    weak var delegate: NotifierDelegate?
    var fieldMargin: CGFloat  //Margin to remove message from view
    var angularVelocity: CGFloat = 0
    let tapAction: (()->Void)?
    
    init(config: CFNotify.Config, view: UIView, tapHandler: (()->Void)?, delegate: NotifierDelegate) {
        self.config = config
        self.view = view
        self.containerView = UIView()
        self.panRecognizer = UIPanGestureRecognizer()
        self.tapRecognizer = UITapGestureRecognizer()
        self.animator = UIDynamicAnimator()
        self.snapPoint = CGPoint.zero
        self.isHidding = false
        self.delegate = delegate
        self.fieldMargin = (view.bounds.width > view.bounds.height) ? view.bounds.width : view.bounds.height
        self.tapAction = tapHandler
        
        super.init()
        self.panRecognizer.addTarget(self, action: #selector(Notifier.pan(gesture:)))
        self.panRecognizer.maximumNumberOfTouches = 1
        self.tapRecognizer.addTarget(self, action: #selector(Notifier.tap(gesture:)))
    }
    
    var hideTime: TimeInterval? {
        let duration: TimeInterval?
        switch self.config.hideTime {
        case .default:
            duration = 3.0
        case .never:
            duration = nil
        case .custom(let seconds):
            duration = seconds
        }
        return duration
    }
    
    func present(completion: @escaping (_ completed: Bool) -> Void){
        guard let appDelegate = UIApplication.shared.delegate else { return }
        guard let keyWindow = appDelegate.window! else { return }
        
        self.animator = UIDynamicAnimator(referenceView: keyWindow)
        
        let initPoint: CGPoint
        switch self.config.initPosition {
        case .top(let position):
            switch position {
            case .center:
                initPoint = CGPoint(keyWindow.bounds.midX, 0 - self.view.bounds.height)
            case .left:
                initPoint = CGPoint(0 - self.view.bounds.width, 0 - self.view.bounds.height)
            case .right:
                initPoint = CGPoint(keyWindow.bounds.width, 0 - self.view.bounds.height)
            case .random:
                initPoint = CGPoint(randomBetweenNumbers(firstNum: 0 - self.view.bounds.width, secondNum: keyWindow.bounds.width + self.view.bounds.width), 0 - self.view.bounds.height)
            }
        case .bottom(let position):
            switch position {
            case .center:
                initPoint = CGPoint(keyWindow.bounds.midX, keyWindow.bounds.height)
            case .left:
                initPoint = CGPoint(0 - self.view.bounds.width, keyWindow.bounds.height)
            case .right:
                initPoint = CGPoint(keyWindow.bounds.width, keyWindow.bounds.height)
            case .random:
                initPoint = CGPoint(randomBetweenNumbers(firstNum: 0 - self.view.bounds.width, secondNum: keyWindow.bounds.width + self.view.bounds.width), keyWindow.bounds.height)
            }
        case .left:
            initPoint = CGPoint(0 - self.view.bounds.width, keyWindow.bounds.midY)
        case .right:
            initPoint = CGPoint(keyWindow.bounds.width, keyWindow.bounds.midY)
        case .custom(let point):
            initPoint = point
        }
        
        self.view.frame.origin = CGPoint.zero
        self.containerView.frame.origin = initPoint
        self.containerView.bounds = self.view.bounds
        self.containerView.backgroundColor = UIColor.clear
        self.containerView.addSubview(self.view)
        self.containerView.bringSubview(toFront: self.view)
        self.containerView.addGestureRecognizer(self.panRecognizer)
        if self.tapAction == nil {
            self.containerView.addGestureRecognizer(self.tapRecognizer)
        }
        
        keyWindow.addSubview(self.containerView)
        
        if let delegate = self.delegate {
            delegate.notifierDidAppear()
        }
        
        switch self.config.appearPosition {
        case .bottom:
            self.snapPoint = CGPoint(x: keyWindow.bounds.midX, y: keyWindow.bounds.bottom - 50 - self.containerView.bounds.midY)
        case .center:
            self.snapPoint = keyWindow.bounds.center
        case .top:
            self.snapPoint = CGPoint(x: keyWindow.bounds.midX, y: 70 + self.containerView.bounds.height/2)
        case .custom(let point):
            self.snapPoint = point
        }
        self.addSnap(view: self.containerView, toPoint: self.snapPoint) { (completed) in
            completion(completed)
        }
    }
    
    func hide() {
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
                    delegate.notifierDidDisappear(notifier: strongSelf)
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
                self.isHidding = true
                completion(false)
            }
        }
    }
    
    func addSnap(view: UIView, toPoint: CGPoint, completion: ((_ completed: Bool) -> Void)? = nil) {
        var counter = 0
        snapBehaviour = UISnapBehavior(item: view, snapTo: toPoint)
        snapBehaviour.damping = self.config.snapDamping
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
            if let delegate = self.delegate {
                delegate.notifierStartDragging(atPoint: dragPoint)
            }
            self.animator.removeAllBehaviors()
            
            let anchorPoint: CGPoint = gesture.location(in: gestureView.superview)
            attachmentBehaviour = UIAttachmentBehavior(item: gestureView, offsetFromCenter: offsetFromCenterInView, attachedToAnchor: anchorPoint)
            
            lastTime = CFAbsoluteTime()
            lastAngle = CGFloat(self.angleOfView(view: gestureView))
            
            attachmentBehaviour.action = { [weak self] in
                guard let strongSelf = self else { return }
                //Calculate Angular Velocity
                let time = CFAbsoluteTimeGetCurrent()
                let angle = CGFloat(strongSelf.angleOfView(view: gestureView))
                if time > lastTime {
                    strongSelf.angularVelocity = (angle - lastAngle) / CGFloat((time - lastTime))
                    lastTime = time
                    lastAngle = angle
                }
            }
            
            self.animator.addBehavior(attachmentBehaviour)
        //Dragging
        case .changed:
            let touchPoint : CGPoint = gesture.location(in: gestureView.superview)
            attachmentBehaviour.anchorPoint = touchPoint
            if let delegate = delegate {
                delegate.notifierIsDragging(atPoint: touchPoint)
            }
        //End Dragging
        case .ended:
            if let delegate = self.delegate {
                delegate.notifierEndDragging(atPoint: dragPoint)
            }

            self.animator.removeAllBehaviors()
            
            if movedDistance < self.config.thresholdDistance {
                addSnap(view: gestureView, toPoint: self.snapPoint)
            }
            else
            {
                animator.removeAllBehaviors()
                if let gestureViewGestureRecognizers = gestureView.gestureRecognizers {
                    for gestureRecongnizers in gestureViewGestureRecognizers {
                        gestureView.removeGestureRecognizer(gestureRecongnizers)
                    }
                }
                
                //Add Push Behaviour
                let pushBehavior = UIPushBehavior(items: [gestureView], mode: UIPushBehaviorMode.instantaneous)
                pushBehavior.pushDirection = vector
                
                let pushMagnitude : CGFloat = pushBehavior.magnitude * self.config.pushForceFactor
                let massFactor: CGFloat = (gestureView.bounds.height * gestureView.bounds.width) / (100*100)
                
                pushBehavior.magnitude = (pushMagnitude > self.config.minPushForce) ? pushMagnitude*massFactor : self.config.defaultPushForce*massFactor
//                pushBehavior.setTargetOffsetFromCenter(offsetFromCenterInWindow, for: gestureView)
                self.animator.addBehavior(pushBehavior)
                
                //Add Item Behaviour
                let itemBehaviour = UIDynamicItemBehavior(items: [gestureView])
                itemBehaviour.addAngularVelocity(angularVelocity * self.config.angularVelocityFactor, for: gestureView)
                itemBehaviour.angularResistance = self.config.angularResistance
                
                itemBehaviour.action = { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.removeFromSuperView(completion: { [weak self] (completed) in
                        guard let strongSelf = self else { return }
                        if let delegate = strongSelf.delegate, completed {
                            delegate.notifierDidDisappear(notifier: strongSelf)
                        }
                    })
                }
                self.animator.addBehavior(itemBehaviour)
            }
        default:
            break
        }
    }
    
    @objc func tap(gesture: UITapGestureRecognizer) {
        if let delegate = self.delegate {
            delegate.notifierIsTapped()
        }
        if let tapAction = self.tapAction {
            tapAction()
        }
    }
    
    func distance(from:CGPoint, to:CGPoint) -> CGFloat {
        let xDist = (to.x - from.x)
        let yDist = (to.y - from.y)
        return sqrt((xDist * xDist) + (yDist * yDist))
    }
    
    func angleOfView(view: UIView) -> Float {
        return Float(atan2(view.transform.b, view.transform.a))
    }
    
    //http://stackoverflow.com/questions/26029393/random-number-between-two-decimals-in-swift
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
}
