//
//  SwiftNotify.swift
//  SwiftNotify
//
//  Created by Johnny Tsoi on 9/11/2016.
//  Copyright © 2022 Johnny@Co-fire. All rights reserved.
//

import UIKit

/// Reference to `SwiftNotify.default` for quick bootstrapping.
public let SN = SwiftNotify.default

/// Current SwiftNotify Version
public let version = "2.0.0"

open class SwiftNotify: NotifyDelegate {
    /// Shared singleton instance used by all `SF` APIs. Cannot be modified
    public static let `default` = SwiftNotify()

    /// `DispatchQueue` for managing notices' lifecycle. **MUST** be a concurrent queue.
    public let noticeQueue: DispatchQueue

    /// `NoticeManager` instance used to manage notice queue
    public let noticeManager: NoticeManager

    /// SwiftNotify configuration instance
    public var config = SwiftNotifyConfig()

    /// `SwiftNotifyDelegate` that handles notices interactions.
    public var delegate: SwiftNotifyDelegate?

    /// `DispatchTimeInterval` which is the interval between sequence of notices.
    public var intervalBetweenNotices: DispatchTimeInterval

    /// Create a `SwiftNotify` instance.
    ///
    /// - Parameters:
    ///   - noticeQueue:            `DispatchQueue` for managing notices' lifecycle. **MUST** be a concurrent queue.
    ///                             `DispatchQueue(label: "com.jt501.SwiftNotify.NoticeQueue", attributes: .concurrent)`
    ///                             by default.
    ///   - delegate:               `SwiftNotifyDelegate` that handles notices interactions. `nil` by default
    ///   - intervalBetweenNotices: `DispatchTimeInterval` which is the interval between sequence of notices.
    ///                             `DispatchTimeInterval.milliseconds(500)` by default.
    public init(
            noticeQueue: DispatchQueue = DispatchQueue(label: "com.jt501.SwiftNotify.NoticeQueue", attributes: .concurrent),
            delegate: SwiftNotifyDelegate? = nil,
            intervalBetweenNotices: DispatchTimeInterval = .milliseconds(500)
    ) {
        self.noticeQueue = noticeQueue
        self.delegate = delegate
        self.intervalBetweenNotices = intervalBetweenNotices

        noticeManager = NoticeManager(queue: noticeQueue)
    }

    // MARK: - Public functions
    /**
    Show message with config and add tap handler to it
    */
    public func show(config: SwiftNotifyConfig, view: UIView, tapHandler: (() -> Void)? = nil) {
        let notice = Notice(config: config, view: view, tapHandler: tapHandler, delegate: self)
        noticeManager.addPendingNotice(notice)
    }

    public func show(config: SwiftNotifyConfig, view: UIView) {
        show(config: config, view: view, tapHandler: nil)
    }

    public func show(view: UIView) {
        show(config: config, view: view)
    }

    public typealias ViewProvider = () -> UIView

    public func show(config: SwiftNotifyConfig, viewProvider: @escaping ViewProvider) {
        let view = viewProvider()
        show(config: config, view: view)
    }

    public func show(viewProvider: @escaping ViewProvider) {
        show(config: config, viewProvider: viewProvider)
    }

    public func dismiss() {
        noticeManager.dismissCurrentNotices()
    }

    public func dismiss(notice: Notice) {
        noticeManager.dismissNotice(notice)
    }

    public func dismissAll() {
        noticeManager.removeAllPendingNotices()
        noticeManager.dismissCurrentNotices()
    }


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
    }

    func notifierIsTapped() {
        if let delegate = delegate {
            delegate.swiftNotifyIsTapped()
        }
    }
}