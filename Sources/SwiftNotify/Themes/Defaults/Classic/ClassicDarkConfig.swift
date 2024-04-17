//
// Created by Johnny Choi on 5/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

/// Represents the config used for **Classic Dark Theme**
public struct ClassicDarkConfig: ThemeConfig {

    public var titleTextColor: UIColor
    public var titleTextFont: UIFont
    public var titleBackgroundColor: UIColor
    public var titleTextAlignment: NSTextAlignment
    public var bodyTextColor: UIColor
    public var bodyTextFont: UIFont
    public var bodyBackgroundColor: UIColor
    public var bodyTextAlignment: NSTextAlignment
    public var iconViewWidth: CGFloat
    public var iconViewHeight: CGFloat
    public var iconViewContentMode: UIView.ContentMode
    public var iconViewCornerRadius: CGFloat
    public var iconImageTintColor: UIColor?
    public var cornerRadius: CGFloat
    public var padding: CGFloat
    public var levelConfigs: [Level: LevelConfig]

    /// Creates a config value based on given parameters.
    ///
    /// - Parameters:
    ///   - titleTextColor: Title text color
    ///   - titleTextFont: Title text font
    ///   - titleBackgroundColor: Title label background color
    ///   - titleTextAlignment: Title text alignment
    ///   - bodyTextColor: Body text color
    ///   - bodyTextFont: Body text font
    ///   - bodyBackgroundColor: Body label background color
    ///   - bodyTextAlignment: Body text alignment
    ///   - iconViewWidth: Icon view width
    ///   - iconViewHeight: Icon view height
    ///   - iconViewContentMode: Icon view's content mode
    ///   - iconViewCornerRadius: Icon view's corner radius
    ///   - iconImageTintColor: Icon image's tint color
    ///   - cornerRadius: Notice view's corner radius
    ///   - padding: Notice content padding
    ///   - levelConfigs: Configs for each level
    public init(
            titleTextColor: UIColor = .white,
            titleTextFont: UIFont = .boldSystemFont(ofSize: 16),
            titleBackgroundColor: UIColor = .clear,
            titleTextAlignment: NSTextAlignment = .left,
            bodyTextColor: UIColor = .white,
            bodyTextFont: UIFont = .systemFont(ofSize: 13, weight: UIFont.Weight.regular),
            bodyBackgroundColor: UIColor = .clear,
            bodyTextAlignment: NSTextAlignment = .left,
            iconViewWidth: CGFloat = 50,
            iconViewHeight: CGFloat = 50,
            iconViewContentMode: UIView.ContentMode = .scaleAspectFit,
            iconViewCornerRadius: CGFloat = 25,
            iconImageTintColor: UIColor? = .white,
            cornerRadius: CGFloat = 10,
            padding: CGFloat = 10,
            levelConfigs: [Level: LevelConfig] = [
                .success: Success(),
                .fail: Fail(),
                .info: Info(),
                .warning: Warning()
            ]
    ) {
        self.titleTextColor = titleTextColor
        self.titleTextFont = titleTextFont
        self.titleBackgroundColor = titleBackgroundColor
        self.titleTextAlignment = titleTextAlignment
        self.bodyTextColor = bodyTextColor
        self.bodyTextFont = bodyTextFont
        self.bodyBackgroundColor = bodyBackgroundColor
        self.bodyTextAlignment = bodyTextAlignment
        self.iconViewWidth = iconViewWidth
        self.iconViewHeight = iconViewHeight
        self.iconViewContentMode = iconViewContentMode
        self.iconViewCornerRadius = iconViewCornerRadius
        self.iconImageTintColor = iconImageTintColor
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.levelConfigs = levelConfigs
    }

    /// Config used for level **Success**
    public struct Success: LevelConfig {
        public var backgroundColor: UIColor? = Notify.Colors.DarkGreen
        public var iconImage: UIImage? = Notify.Icons.SuccessSolid

        public init() {}
    }

    /// Config used for level **Fail**
    public struct Fail: LevelConfig {
        public var backgroundColor: UIColor? = Notify.Colors.DarkRed
        public var iconImage: UIImage? = Notify.Icons.FailSolid

        public init() {}
    }

    /// Config used for level **Info**
    public struct Info: LevelConfig {
        public var backgroundColor: UIColor? = Notify.Colors.DarkBlue
        public var iconImage: UIImage? = Notify.Icons.InfoSolid

        public init() {}
    }

    /// Config used for level **Warning**
    public struct Warning: LevelConfig {
        public var backgroundColor: UIColor? = Notify.Colors.Orange
        public var iconImage: UIImage? = Notify.Icons.WarningSolid

        public init() {}
    }
}
