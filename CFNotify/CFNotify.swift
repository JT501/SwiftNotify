//
//  CFNotify.swift
//  CFNotify
//
//  Created by Johnny Choi on 9/11/2016.
//  Copyright © 2016 Johnny@Co-fire. All rights reserved.
//

import UIKit

private let globalInstance = CFNotify()

open class CFNotify: NotifierDelegate {
    
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
        case random
    }
    
    public enum AppearPosition {
        case top
        case center
        case bottom
        case custom(CGPoint)
    }
    
    public enum HideTime {
        case `default`
        case never
        case custom(seconds: TimeInterval)
    }
    
    public struct Config {
        public init() {}
        public var initPosition = InitPosition.top(.center)
        public var appearPosition = AppearPosition.center
        public var hideTime = HideTime.default
        /**
        The max. drag distance that the view will return to snap point.
        If exceed the thresholdDistance, the view will hide.
        Default: 50
        */
        public var thresholdDistance : CGFloat = 50
        public var minPushForce : CGFloat = 8
        public var pushForceFactor : CGFloat = 0.005
        public var defaultPushForce : CGFloat = 12
        /**
        Rotation speed factor, default: 0.8
        - 0.0 : View will not rotate
        - The higher factor, the faster rotation
        */
        public var angularVelocityFactor: CGFloat = 0.8
        /**
        Rotation resistance, default: 1.2
        */
        public var angularResistance: CGFloat = 1.2
        public var snapDamping: CGFloat = 0.3
    }
    
    public init() {}
    
    // MARK: - Public functions
    /**
    Show message with config and add tap handler to it
    */
    open func present(config: Config, view: UIView, tapHandler: (()->Void)? = nil) {
        syncQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                let message = Notifier(config: config, view: view, tapHandler: tapHandler, delegate: strongSelf)
                strongSelf.enqueue(message: message)
            }
        }
    }
    
    open func present(config: Config, view: UIView) {
        present(config: config, view: view, tapHandler: nil)
    }
    
    open func present(view: UIView) {
        present(config: defaultConfig, view: view)
    }
    
    public typealias ViewProvider = () -> UIView
    
    open func present(config: Config, viewProvider: @escaping ViewProvider) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            let view = viewProvider()
            strongSelf.present(config: config, view: view)
        }
    }
    
    public func present(viewProvider: @escaping ViewProvider) {
        present(config: defaultConfig, viewProvider: viewProvider)
    }
    
    open func hide() {
        syncQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.hideCurrent()
        }
    }
    
    open func hideAll() {
        syncQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.messageQueue.removeAll()
            strongSelf.hideCurrent()
        }
    }
    
    open weak var delegate: CFNotifyDelegate!
    public var defaultConfig = Config()
    
    open var intervalBetweenMessages: TimeInterval = 0.5
    
    let syncQueue = DispatchQueue(label: "CFNotify.Queue", attributes: [])
    var messageQueue: [Notifier] = []
    var currentMsg: Notifier? = nil {
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
    
    func enqueue(message: Notifier) {
        messageQueue.append(message)
        dequeueNext()
    }
    
    func dequeueNext() {
//        print("Count = \(self.messageQueue.count)")
        guard self.currentMsg == nil else { return }
        guard messageQueue.count > 0 else { return }
        let current = messageQueue.removeFirst()
        self.currentMsg = current
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            current.present(completion: { (completed) in
                guard completed else { return }
                if completed {
                    strongSelf.queueAutoHide()
                }
            })
        }
    }
    
    fileprivate var msgToAutoHide: Notifier?
    
    fileprivate func queueAutoHide() {
        guard let currentMsg = self.currentMsg else { return }
        self.msgToAutoHide = currentMsg
        if let dissmissTime = currentMsg.hideTime {
            let delayTime = DispatchTime.now() + dissmissTime
            syncQueue.asyncAfter(deadline: delayTime, execute: { [weak self] in
                guard let strongSelf = self else { return }
                if strongSelf.msgToAutoHide !== currentMsg {
                    return
                }
                strongSelf.hide(messager: currentMsg)
            })
        }
    }
    
    func hide(messager: Notifier) {
        self.syncQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            if let currentMsg = strongSelf.currentMsg, messager === currentMsg {
                strongSelf.hideCurrent()
            }
        }
    }
    
    func hideCurrent() {
        guard let currentMsg = self.currentMsg else { return }
        guard !currentMsg.isHidding else { return }
        DispatchQueue.main.async {
            currentMsg.hide()
        }
    }
    
    // MARK: - MessengerDelegate
    func notifierDidAppear() {
        if let delegate = delegate {
            delegate.cfNotifyDidAppear()
        }
    }
    
    func notifierStartDragging(atPoint: CGPoint) {
        if let delegate = delegate {
            delegate.cfNotifyStartDragging(atPoint: atPoint)
        }
        self.msgToAutoHide = nil
    }
    
    func notifierIsDragging(atPoint: CGPoint) {
        if let delegate = delegate {
            delegate.cfNotifyIsDragging(atPoint: atPoint)
        }
    }
    
    func notifierEndDragging(atPoint: CGPoint) {
        if let delegate = delegate {
            delegate.cfNotifyEndDragging(atPoint: atPoint)
        }
        self.queueAutoHide()
    }
    
    func notifierDidDisappear(notifier: Notifier) {
        if let delegate = delegate {
            delegate.cfNotifyDidDisappear()
        }
        self.syncQueue.async {
            self.messageQueue = self.messageQueue.filter{ $0 !== notifier }
            self.currentMsg = nil
        }
    }
    
    func notifierIsTapped() {
        if let delegate = delegate {
            delegate.cfNotifyIsTapped()
        }
        self.msgToAutoHide = nil
        self.hideCurrent()
    }
}

/* MARK: - Static APIs **/
extension CFNotify {
    
    public static var sharedInstance: CFNotify {
        return globalInstance
    }
    
    public static weak var delegate: CFNotifyDelegate? {
        get {
            return globalInstance.delegate
        }
        set {
            globalInstance.delegate = newValue
        }
    }
    
    public static func present(view: UIView) {
        globalInstance.present(view: view)
    }
    
    public static func present(config: Config, view: UIView) {
        globalInstance.present(config: config, view: view)
    }
    
    public static func present(config: Config, view: UIView, tapHandler: (()->Void)? = nil) {
        globalInstance.present(config: config, view: view, tapHandler: tapHandler)
    }
    
    public static func present(viewProvider: @escaping ViewProvider) {
        globalInstance.present(viewProvider: viewProvider)
    }
    
    public static func present(config: Config, viewProvider: @escaping ViewProvider) {
        globalInstance.present(config: config, viewProvider: viewProvider)
    }
    
    public static func hide() {
        globalInstance.hide()
    }
    
    public static func hideAll() {
        globalInstance.hideAll()
    }
}
