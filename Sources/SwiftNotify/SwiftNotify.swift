//
//  SwiftNotify.swift
//  SwiftNotify
//
//  Created by Johnny Tsoi on 9/11/2016.
//  Copyright © 2022 Johnny@Co-fire. All rights reserved.
//

import UIKit

/// Reference to ``SwiftNotify/default`` for quick bootstrapping.
public let SN = SwiftNotify.default

/// Current SwiftNotify Version
public let version = "2.0.0"

open class SwiftNotify: NoticeDelegate {
    /// Shared singleton instance used by all `SN` APIs. Cannot be modified.
    public static let `default` = SwiftNotify()

    /// SwiftNotify default icons enum
    public static let Icons = DefaultIcons.self

    /// `DispatchQueue` for managing notices' lifecycle. **MUST** be a concurrent queue.
    public let noticeQueue: DispatchQueue

    /// `NoticeManager` instance used to manage notice queue
    public let noticeManager: NoticeManager

    /// Default theme for notice
    public var defaultTheme: Theme

    /// Default theme appearance configuration
    public var defaultThemeConfig: ThemeConfig?

    /// Default position outside visible view where the Notice born and move to ``ToPosition``
    public var defaultFromPosition: FromPosition

    /// Default position where the Notice stays before dismiss
    public var defaultToPosition: ToPosition

    /// Default duration of the notice stays on screen
    public var defaultNoticeDuration: Duration

    /// Default configuration for animation's physics
    public var defaultPhysicsConfig: PhysicsConfig

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
    ///   - defaultNoticeDuration:  Default duration of the notice stays on screen. `DurationsEnum.short` by default.
    ///                             `DispatchTimeInterval.milliseconds(500)` by default.
    ///   - defaultPhysicsConfig:   Default configuration for animation's physics. `DefaultPhysicsConfig()` by default.
    ///   - intervalBetweenNotices: `DispatchTimeInterval` which is the interval between sequence of notices.
    ///   - delegate:               `SwiftNotifyDelegate` that handles notices interactions. `nil` by default.
    ///
    public init(
            noticeQueue: DispatchQueue = DispatchQueue(
                    label: "com.jt501.SwiftNotify.NoticeQueue",
                    attributes: .concurrent
            ),
            defaultTheme: Theme = .cyber,
            defaultThemeConfig: ThemeConfig? = nil,
            defaultFromPosition: FromPosition = .top(.random),
            defaultToPosition: ToPosition = .top(),
            defaultNoticeDuration: Duration = .short,
            defaultPhysicsConfig: PhysicsConfig = PhysicsConfig(),
            intervalBetweenNotices: DispatchTimeInterval = .milliseconds(500),
            delegate: SwiftNotifyDelegate? = nil
    ) {
        self.noticeQueue = noticeQueue
        self.defaultTheme = defaultTheme
        self.defaultThemeConfig = defaultThemeConfig
        self.defaultFromPosition = defaultFromPosition
        self.defaultToPosition = defaultToPosition
        self.defaultNoticeDuration = defaultNoticeDuration
        self.defaultPhysicsConfig = defaultPhysicsConfig
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
            level: Level,
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
    ///
    /// - Returns: Notice Id
    public func show(
            title: String? = nil,
            message: String? = nil,
            theme: Theme? = nil,
            themeConfig: ThemeConfig? = nil,
            level: Level,
            duration: Duration? = nil,
            fromPosition: FromPosition? = nil,
            toPosition: ToPosition? = nil,
            tapHandler: ((String) -> ())? = nil,
            width: CGFloat = UIScreen.main.bounds.size.width * 0.8,
            height: CGFloat = 0
    ) -> String {
        // Use default theme if theme if nil
        let theme = theme ?? defaultTheme
        let duration = duration ?? defaultNoticeDuration
        let fromPosition = fromPosition ?? defaultFromPosition
        let toPosition = toPosition ?? defaultToPosition

        var noticeView: NoticeView

        switch theme {
        case .classic:
            noticeView = createNoticeView(
                    title: title,
                    message: message,
                    themeConfig: themeConfig ?? defaultThemeConfig ?? ClassicLightConfig(),
                    level: level,
                    width: width,
                    height: height
            ) as ClassicView
        case .classicDark:
            noticeView = createNoticeView(
                    title: title,
                    message: message,
                    themeConfig: themeConfig ?? defaultThemeConfig ?? ClassicDarkConfig(),
                    level: level,
                    width: width,
                    height: height
            ) as ClassicView
        case .cyber:
            noticeView = createNoticeView(
                    title: title,
                    message: message,
                    themeConfig: themeConfig ?? defaultThemeConfig ?? CyberLightConfig(),
                    level: level,
                    width: width,
                    height: height
            ) as CyberView
        case .cyberDark:
            noticeView = createNoticeView(
                    title: title,
                    message: message,
                    themeConfig: themeConfig ?? defaultThemeConfig ?? CyberDarkConfig(),
                    level: level,
                    width: width,
                    height: height
            ) as CyberView
        case .toast:
            noticeView = createNoticeView(
                    title: title,
                    message: message,
                    themeConfig: themeConfig ?? defaultThemeConfig ?? ToastLightConfig(),
                    level: level,
                    width: width,
                    height: height
            ) as ToastView
        case .toastDark:
            noticeView = createNoticeView(
                    title: title,
                    message: message,
                    themeConfig: themeConfig ?? defaultThemeConfig ?? ToastDarkConfig(),
                    level: level,
                    width: width,
                    height: height
            ) as ToastView
        }

        let notice = Notice(
                view: noticeView,
                duration: duration,
                fromPosition: fromPosition,
                toPosition: toPosition,
                tapHandler: tapHandler,
                config: defaultPhysicsConfig,
                delegate: self
        )
        noticeManager.addPendingNotice(notice)

        return notice.id
    }

    public func dismiss() {
        noticeManager.dismissCurrentNotices()
    }

    public func dismiss(byId id: String) {
        noticeManager.dismissNotice(byId: id)
    }

    public func dismissAll() {
        noticeManager.removeAllPendingNotices()
        noticeManager.dismissCurrentNotices()
    }

    // MARK: - MessengerDelegate
    public func noticeDidAppear(notice: Notice) {
        if let delegate = delegate {
            delegate.swiftNotifyDidAppear(notice: notice)
        }
    }

    public func noticeStartPanning(atPoint: CGPoint, notice: Notice) {
        if let delegate = delegate {
            delegate.swiftNotifyStartPanning(atPoint: atPoint, notice: notice)
        }
    }

    public func noticeIsPanning(atPoint: CGPoint, notice: Notice) {
        if let delegate = delegate {
            delegate.swiftNotifyIsPanning(atPoint: atPoint, notice: notice)
        }
    }

    public func noticeEndPanning(atPoint: CGPoint, notice: Notice) {
        if let delegate = delegate {
            delegate.swiftNotifyEndPanning(atPoint: atPoint, notice: notice)
        }
    }

    public func noticeDidDisappear(notice: Notice) {
        if let delegate = delegate {
            delegate.swiftNotifyDidDisappear(notice: notice)
        }
    }

    public func noticeIsTapped(notice: Notice) {
        if let delegate = delegate {
            delegate.swiftNotifyIsTapped(notice: notice)
        }
    }
}
