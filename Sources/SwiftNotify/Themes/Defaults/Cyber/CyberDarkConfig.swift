//
// Created by Johnny Choi on 5/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

/// Represents the config used for **Cyber Dark Theme**
public struct CyberDarkConfig: CyberThemeConfig {

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
    public var blurEffectStyle: UIBlurEffect.Style
    public var vibrancyEffectStyle: UIVibrancyEffectStyle
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
    ///   - blurEffectStyle: Notice view blur effect style
    ///   - vibrancyEffectStyle: Notice view vibrancy effect style
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
            iconImageTintColor: UIColor? = nil,
            cornerRadius: CGFloat = 10,
            padding: CGFloat = 10,
            blurEffectStyle: UIBlurEffect.Style = .systemThinMaterialDark,
            vibrancyEffectStyle: UIVibrancyEffectStyle = .label,
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
        self.blurEffectStyle = blurEffectStyle
        self.vibrancyEffectStyle = vibrancyEffectStyle
        self.levelConfigs = levelConfigs
    }

    /// Config used for level **Success**
    public struct Success: LevelConfig {
        public var backgroundColor: UIColor? = .clear
        public var iconImage: UIImage? = DefaultIcons.SuccessSolid
        public var iconImageTintColor: UIColor? = DefaultColors.Success

        public init() {}
    }

    /// Config used for level **Fail**
    public struct Fail: LevelConfig {
        public var backgroundColor: UIColor? = .clear
        public var iconImage: UIImage? = DefaultIcons.FailSolid
        public var iconImageTintColor: UIColor? = DefaultColors.Fail

        public init() {}
    }

    /// Config used for level **Info**
    public struct Info: LevelConfig {
        public var backgroundColor: UIColor? = .clear
        public var iconImage: UIImage? = DefaultIcons.InfoSolid
        public var iconImageTintColor: UIColor? = DefaultColors.Info

        public init() {}
    }

    /// Config used for level **Warning**
    public struct Warning: LevelConfig {
        public var backgroundColor: UIColor? = .clear
        public var iconImage: UIImage? = DefaultIcons.WarningSolid
        public var iconImageTintColor: UIColor? = DefaultColors.Warning

        public init() {}
    }
}
