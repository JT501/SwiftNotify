//
//  CFDraggableMessage.swift
//  Dynamic Demo
//
//  Created by Johnny Choi on 9/11/2016.
//  Copyright © 2016 Johnny@Co-fire. All rights reserved.
//

import UIKit

private let globalInstance = CFMessage()

open class CFMessage: MessengerDelegate {
    
    public enum InitPosition {
        case top(HorizontalPosition)
        case bottom(HorizontalPosition)
        case left
        case right
        case custom(CGPoint)
    }
    
    public enum HorizontalPosition {
        case left
        case right
        case center
    }
    
    public enum AppearPosition {
        case top
        case center
        case bottom
        case custom(CGPoint)
    }
    
    public enum DismissTime {
        case `default`
        case never
        case custom(seconds: TimeInterval)
    }
    
    public struct Config {
        public init() {}
        public var initPosition = InitPosition.top(.center)
        public var appearPosition = AppearPosition.center
        public var dismissTime = DismissTime.default
        public var tapToDismiss = true
        public var thresholdDistance : CGFloat = 50
        public var minPushForce : CGFloat = 8
        public var pushForceFactor : CGFloat = 0.005
        public var defaultPushForce : CGFloat = 12
        public var angularVelocityFactor: CGFloat = 0.8
        public var angularResistance: CGFloat = 1.5
        public var snapDamping: CGFloat = 0.6
    }
    
    public init() {}
    
    open func show(config: Config, view: UIView, tapHandler: (()->Void)? = nil) {
        syncQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            let message = Messenger(config: config, view: view, tapHandler: tapHandler, delegate: strongSelf)
            strongSelf.enqueue(message: message)
        }
    }
    
    open func show(config: Config, view: UIView) {
        show(config: config, view: view, tapHandler: nil)
    }
    
    open func show(view: UIView) {
        show(config: defaultConfig, view: view)
    }
    
    public typealias ViewProvider = () -> UIView
    
    open func show(config: Config, viewProvider: @escaping ViewProvider) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            let view = viewProvider()
            strongSelf.show(config: config, view: view)
        }
    }
    
    public func show(viewProvider: @escaping ViewProvider) {
        show(config: defaultConfig, viewProvider: viewProvider)
    }
    
    open func dismiss() {
        syncQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.dismissCurrent()
        }
    }
    
    open func dismissAll() {
        syncQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.messageQueue.removeAll()
            strongSelf.dismissCurrent()
        }
    }
    
    open var delegate: CFMessageDelegate!
    public var defaultConfig = Config()
    
    open var intervalBetweenMessages: TimeInterval = 0.5
    
    let syncQueue = DispatchQueue(label: "CFMessage.Queue", attributes: [])
    var messageQueue: [Messenger] = []
    var currentMsg: Messenger? = nil {
        didSet {
            if oldValue != nil {
                let delayTime = DispatchTime.now() + intervalBetweenMessages
                syncQueue.asyncAfter(deadline: delayTime, execute: { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.dequeueNext()
                })
            }
        }
    }
    
    func enqueue(message: Messenger) {
        messageQueue.append(message)
        dequeueNext()
    }
    
    func dequeueNext() {
        print("Count = \(self.messageQueue.count)")
        guard self.currentMsg == nil else { return }
        guard messageQueue.count > 0 else { return }
        let current = messageQueue.removeFirst()
        self.currentMsg = current
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            current.show(completion: { (completed) in
                guard completed else { return }
                if completed {
                    if let delegate = strongSelf.delegate {
                        delegate.cfMessageDidAppear()
                    }
                    strongSelf.queueAutoDismiss()
                }
            })
        }
    }
    
    fileprivate var msgToAutoDismiss: Messenger?
    
    fileprivate func queueAutoDismiss() {
        guard let currentMsg = self.currentMsg else { return }
        self.msgToAutoDismiss = currentMsg
        if let dissmissTime = currentMsg.dismissTime {
            let delayTime = DispatchTime.now() + dissmissTime
            syncQueue.asyncAfter(deadline: delayTime, execute: { [weak self] in
                guard let strongSelf = self else { return }
                if strongSelf.msgToAutoDismiss !== currentMsg {
                    return
                }
                strongSelf.dismiss(messager: currentMsg)
            })
        }
    }
    
    func dismiss(messager: Messenger) {
        self.syncQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            if let currentMsg = strongSelf.currentMsg, messager === currentMsg {
                strongSelf.dismissCurrent()
            }
        }
    }
    
    func dismissCurrent() {
        guard let currentMsg = self.currentMsg else { return }
        guard !currentMsg.isDismissing else { return }
        DispatchQueue.main.async {
            currentMsg.dismiss()
        }
    }
    
    // MARK: - MessengerDelegate
    func messengerDidAppear() {
        
    }
    
    func messengerStartDragging(atPoint: CGPoint) {
        print("start dragging")
        self.msgToAutoDismiss = nil
    }
    
    func messengerIsDragging(atPoint: CGPoint) {
        
    }
    
    func messengerEndDragging(atPoint: CGPoint) {
        self.queueAutoDismiss()
    }
    
    func messengerDidDisappear(messenger: Messenger) {
        self.syncQueue.async {
            print("Removed")
            self.messageQueue = self.messageQueue.filter{ $0 !== messenger }
            self.currentMsg = nil
        }
    }
    
    func messengerIsTapped() {
        self.msgToAutoDismiss = nil
        self.dismissCurrent()
    }
}
