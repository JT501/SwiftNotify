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
    /// Shared singleton instance used by all `SN` APIs. Cannot be modified.
    public static let `default` = SwiftNotify()

    /// SwiftNotify default icons enum
    public static let Icons = DefaultIcons.self

    /// SwiftNotify themes enum
    public static let Themes = NoticeThemes.self

    /// `DispatchQueue` for managing notices' lifecycle. **MUST** be a concurrent queue.
    public let noticeQueue: DispatchQueue

    /// `NoticeManager` instance used to manage notice queue
    public let noticeManager: NoticeManager

    /// Default theme for notice
    public var defaultTheme: NoticeThemes

    /// Default theme appearance configuration
    public var defaultThemeConfig: ThemeConfig?

    /// Default position outside visible view where the Notice born and move to ``ToPosition``
    public var defaultFromPosition: FromPosition

    /// Default position where the Notice stays before dismiss
    public var defaultToPosition: ToPosition

    /// Default duration of the notice stays on screen
    public var defaultNoticeDuration: NoticeDuration

    /// SwiftNotify configuration instance
    public var config = SwiftNotifyConfig()

    /// `SwiftNotifyDelegate` that handles notices interactions and events.
    public var delegate: SwiftNotifyDelegate?

    /// `DispatchTimeInterval` which is the interval between sequence of notices.
    public var intervalBetweenNotices: DispatchTimeInterval

    /// Create a `SwiftNotify` instance.
    ///
    /// - Parameters:
    ///   - noticeQueue:            `DispatchQueue` for managing notices' lifecycle. **MUST** be a concurrent queue.
    ///                             `DispatchQueue(label: "com.jt501.SwiftNotify.NoticeQueue", attributes: .concurrent)`
    ///                             by default.
    ///   - defaultTheme:           Default theme for notice. `NoticeThemes.Cyber` by default.
    ///   - defaultThemeConfig:     Default theme appearance configuration. `nil` by default.
    ///   - defaultFromPosition:    Default position outside visible view where the Notice born and move to `ToPosition`.
    ///                             `FromPosition.top(.HorizontalPosition.random)` by default.
    ///   - defaultToPosition:      Default position where the Notice stays before dismiss. `ToPosition.center` by default.
    ///   - defaultNoticeDuration:     Default duration of the notice stays on screen. ``NoticeDuration.short`` by default.
    ///   - intervalBetweenNotices: `DispatchTimeInterval` which is the interval between sequence of notices.
    ///                             `DispatchTimeInterval.milliseconds(500)` by default.
    ///   - delegate:               `SwiftNotifyDelegate` that handles notices interactions. `nil` by default.
    public init(
            noticeQueue: DispatchQueue = DispatchQueue(
                    label: "com.jt501.SwiftNotify.NoticeQueue",
                    attributes: .concurrent
            ),
            defaultTheme: NoticeThemes = .Cyber,
            defaultThemeConfig: ThemeConfig? = nil,
            defaultFromPosition: FromPosition = .top(.random),
            defaultToPosition: ToPosition = .top,
            defaultNoticeDuration: NoticeDuration = .short,
            intervalBetweenNotices: DispatchTimeInterval = .milliseconds(500),
            delegate: SwiftNotifyDelegate? = nil
    ) {
        self.noticeQueue = noticeQueue
        self.defaultTheme = defaultTheme
        self.defaultThemeConfig = defaultThemeConfig
        self.defaultFromPosition = defaultFromPosition
        self.defaultToPosition = defaultToPosition
        self.defaultNoticeDuration = defaultNoticeDuration
        self.delegate = delegate
        self.intervalBetweenNotices = intervalBetweenNotices

        noticeManager = NoticeManager(queue: noticeQueue)
    }

    /// - Remark: Public Functions

    /// Create `NoticeView`
    ///
    /// - Parameters:
    ///   - title:          title text of notice
    ///   - message:        message text of notice
    ///   - themeConfig:    theme appearance configuration
    ///   - level:          level of notice
    ///   - width:          width of notice. `UIScreen.main.bounds.size.width * 0.8` by default.
    ///   - height:         height of notice. Zero by default for auto calculation.
    /// - Returns:      `NoticeView`
    public func createNoticeView<V: NoticeView>(
            title: String?,
            message: String?,
            themeConfig: ThemeConfig,
            level: NoticeLevels,
            width: CGFloat = UIScreen.main.bounds.size.width * 0.8,
            height: CGFloat = 0
    ) -> V {
        V.init(titleText: title, bodyText: message, themeConfig: themeConfig, level: level)
    }

    /// Create a `Notice` and add to `noticeQueue`.
    ///
    /// - Note: The notice may not be shown immediately. It has to wait for other notices in queue to be dismiss.
    ///         The queue is FIFO.
    ///
    /// - Parameters:
    ///   - title:          title text of notice
    ///   - message:        message text of notice
    ///   - theme:          theme of notice
    ///   - themeConfig:
    ///   - level:          level of notice
    ///   - duration:
    ///   - fromPosition:
    ///   - toPosition:
    ///   - tapHandler:
    ///   - width:          width of notice. `UIScreen.main.bounds.size.width * 0.8` by default.
    ///   - height:
    public func show(
            title: String?,
            message: String?,
            theme: NoticeThemes? = nil,
            themeConfig: ThemeConfig? = nil,
            level: NoticeLevels,
            duration: NoticeDuration? = nil,
            fromPosition: FromPosition? = nil,
            toPosition: ToPosition? = nil,
            tapHandler: (() -> ())? = nil,
            width: CGFloat = UIScreen.main.bounds.size.width * 0.8,
            height: CGFloat = 0
    ) {
        // Use default theme if theme if nil
        let theme = theme ?? defaultTheme
        let duration = duration ?? defaultNoticeDuration
        let fromPosition = fromPosition ?? defaultFromPosition
        let toPosition = toPosition ?? defaultToPosition

        var noticeView: NoticeView

        switch theme {
        case .Classic:
            noticeView = createNoticeView(
                    title: title,
                    message: message,
                    themeConfig: themeConfig ?? defaultThemeConfig ?? ClassicLightConfig(),
                    level: level,
                    width: width,
                    height: height
            ) as ClassicView
        case .ClassicDark:
            noticeView = createNoticeView(
                    title: title,
                    message: message,
                    themeConfig: themeConfig ?? defaultThemeConfig ?? ClassicDarkConfig(),
                    level: level,
                    width: width,
                    height: height
            ) as ClassicView
        case .Cyber:
            noticeView = createNoticeView(
                    title: title,
                    message: message,
                    themeConfig: themeConfig ?? defaultThemeConfig ?? CyberLightConfig(),
                    level: level,
                    width: width,
                    height: height
            ) as CyberView
        case .CyberDark:
            noticeView = createNoticeView(
                    title: title,
                    message: message,
                    themeConfig: themeConfig ?? defaultThemeConfig ?? CyberDarkConfig(),
                    level: level,
                    width: width,
                    height: height
            ) as CyberView
        case .Toast:
            noticeView = createNoticeView(
                    title: title,
                    message: message,
                    themeConfig: themeConfig ?? defaultThemeConfig ?? ToastLightConfig(),
                    level: level,
                    width: width,
                    height: height
            ) as ToastView
        case .ToastDark:
            noticeView = createNoticeView(
                    title: title,
                    message: message,
                    themeConfig: themeConfig ?? defaultThemeConfig ?? ToastDarkConfig(),
                    level: level,
                    width: width,
                    height: height
            ) as ToastView
        }

        let notice = Notice(config: config, view: noticeView, tapHandler: tapHandler, delegate: self)
        noticeManager.addPendingNotice(notice)
    }

    public func show(
            title: String?,
            message: String,
            type: SwiftNotifyView.`NoticeType`,
            tapHandler: (() -> Void)? = nil
    ) {
        let noticeView: UIView
        switch config.theme {
        case .cyber:
            noticeView = SwiftNotifyView.cyberWith(title: title ?? "", body: message, type: type)
        case .classic:
            noticeView = SwiftNotifyView.classicWith(title: title ?? "", body: message, type: type)
        case .toast:
            noticeView = SwiftNotifyView.toastWith(text: message, type: type)
        }
        show(config: config, view: noticeView, tapHandler: tapHandler)
    }

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

    public enum FromPosition {
        case top(HorizontalPosition)
        case bottom(HorizontalPosition)
        case left
        case right
        case custom(CGPoint)

        public enum HorizontalPosition {
            case left
            case right
            case center
            case random
        }
    }

    public enum ToPosition {
        case top
        case center
        case bottom
        case custom(CGPoint)
    }

    public enum NoticeDuration {
        /// 2 seconds
        case short
        /// 4 seconds
        case long
        /// Disable auto dismiss
        case forever
        case custom(seconds: TimeInterval)
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
