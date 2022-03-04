//
// Created by Johnny Choi on 5/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import Foundation

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
    public var levelConfigs: [NoticeLevels: LevelConfig]

    public struct Success: LevelConfig {
        public let backgroundColor: UIColor? = DefaultColors.SuccessDark
        public let iconImage: UIImage? = DefaultIcons.SuccessSolid

        public init() {}
    }

    public struct Fail: LevelConfig {
        public let backgroundColor: UIColor? = DefaultColors.FailDark
        public let iconImage: UIImage? = DefaultIcons.FailSolid

        public init() {}
    }

    public struct Info: LevelConfig {
        public let backgroundColor: UIColor? = DefaultColors.InfoDark
        public let iconImage: UIImage? = DefaultIcons.InfoSolid

        public init() {}
    }

    public struct Warning: LevelConfig {
        public let backgroundColor: UIColor? = DefaultColors.WarningDark
        public let iconImage: UIImage? = DefaultIcons.WarningSolid

        public init() {}
    }

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
            levelConfigs: [NoticeLevels: LevelConfig] = [
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
}