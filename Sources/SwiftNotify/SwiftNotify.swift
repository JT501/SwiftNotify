//
//  SwiftNotify.swift
//  SiwftNotify
//
//  Created by Johnny Choi on 9/11/2016.
//  Copyright © 2016 Johnny@Co-fire. All rights reserved.
//

import UIKit


open class SwiftNotify: NotifierDelegate {
    private init() {}

    static let shared = SwiftNotify()
    let noticeManager = NoticeManager.shared

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
        public var thresholdDistance: CGFloat = 50
        public var minPushForce: CGFloat = 8
        public var pushForceFactor: CGFloat = 0.005
        public var defaultPushForce: CGFloat = 12
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

    // MARK: - Public functions
    /**
    Show message with config and add tap handler to it
    */
    func present(config: Config, view: UIView, tapHandler: (() -> Void)? = nil) {
        let notice = Notice(config: config, view: view, tapHandler: tapHandler, delegate: self)
        noticeManager.addPendingNotice(notice)
    }

    open func present(config: Config, view: UIView) {
        present(config: config, view: view, tapHandler: nil)
    }

    open func present(view: UIView) {
        present(config: defaultConfig, view: view)
    }

    public typealias ViewProvider = () -> UIView

    func present(config: Config, viewProvider: @escaping ViewProvider) {
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
        noticeManager.dismissCurrentNotices()
    }

    func hide(notice: Notice) {
        noticeManager.dismissNotice(notice)
    }

    open func hideAll() {
        noticeManager.removeAllPendingNotices()
        noticeManager.dismissCurrentNotices()
    }

    open weak var delegate: SwiftNotifyDelegate!
    public var defaultConfig = Config()

    // MARK: - MessengerDelegate
    func notifierDidAppear() {
        if let delegate = delegate {
            delegate.swiftNotifyDidAppear()
        }
    }

    func notifierStartDragging(atPoint: CGPoint) {
        if let delegate = delegate {
            delegate.swiftNotifyStartDragging(atPoint: atPoint)
        }
//        self.msgToAutoHide = nil
    }

    func notifierIsDragging(atPoint: CGPoint) {
        if let delegate = delegate {
            delegate.swiftNotifyIsDragging(atPoint: atPoint)
        }
    }

    func notifierEndDragging(atPoint: CGPoint) {
        if let delegate = delegate {
            delegate.swiftNotifyEndDragging(atPoint: atPoint)
        }
//        self.queueAutoHide()
    }

    func notifierDidDisappear(notifier: Notice) {
        if let delegate = delegate {
            delegate.swiftNotifyDidDisappear()
        }
//        self.syncQueue.async {
//            self.messageQueue = self.messageQueue.filter { $0 !== notifier }
//            self.currentMsg = nil
//        }
    }

    func notifierIsTapped() {
        if let delegate = delegate {
            delegate.swiftNotifyIsTapped()
        }
//        self.msgToAutoHide = nil
//        hide()
    }
}

/* MARK: - Static APIs **/
extension SwiftNotify {

    public static weak var delegate: SwiftNotifyDelegate? {
        get {
            shared.delegate
        }
        set {
            shared.delegate = newValue
        }
    }

    public static func present(view: UIView) {
        shared.present(view: view)
    }

    public static func present(config: Config, view: UIView) {
        shared.present(config: config, view: view)
    }

    public static func present(config: Config, view: UIView, tapHandler: (() -> Void)? = nil) {
        shared.present(config: config, view: view, tapHandler: tapHandler)
    }

    public static func present(viewProvider: @escaping ViewProvider) {
        shared.present(viewProvider: viewProvider)
    }

    public static func present(config: Config, viewProvider: @escaping ViewProvider) {
        shared.present(config: config, viewProvider: viewProvider)
    }

    public static func hide() {
        shared.hide()
    }

    public static func hideAll() {
        shared.hideAll()
    }
}
