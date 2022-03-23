//
// Created by Johnny Choi on 5/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

public struct CyberLightConfig: CyberThemeConfig {

    public var titleTextColor: UIColor = .white
    public var titleTextFont: UIFont = .boldSystemFont(ofSize: 16)
    public var titleBackgroundColor: UIColor = .clear
    public var titleTextAlignment: NSTextAlignment = .left
    public var bodyTextColor: UIColor = .white
    public var bodyTextFont: UIFont = .systemFont(ofSize: 13, weight: UIFont.Weight.regular)
    public var bodyBackgroundColor: UIColor = .clear
    public var bodyTextAlignment: NSTextAlignment = .left
    public var iconViewWidth: CGFloat = 50
    public var iconViewHeight: CGFloat = 50
    public var iconViewContentMode: UIView.ContentMode = .scaleAspectFit
    public var iconViewCornerRadius: CGFloat = 25
    public var iconImageTintColor: UIColor? = nil
    public var cornerRadius: CGFloat = 10
    public var padding: CGFloat = 10
    public var blurEffectStyle: UIBlurEffect.Style = .systemThinMaterialLight
    public var vibrancyEffectStyle: UIVibrancyEffectStyle = .label
    public var levelConfigs: [Level: LevelConfig] = [
        .success: Success(),
        .fail: Fail(),
        .info: Info(),
        .warning: Warning()
    ]

    public init() {}

    public struct Success: LevelConfig {
        public var backgroundColor: UIColor? = .clear
        public var iconImage: UIImage? = DefaultIcons.Success
        public var iconImageTintColor: UIColor? = DefaultColors.Success

        public init() {}
    }

    public struct Fail: LevelConfig {
        public var backgroundColor: UIColor? = .clear
        public var iconImage: UIImage? = DefaultIcons.Fail
        public var iconImageTintColor: UIColor? = DefaultColors.Fail

        public init() {}
    }

    public struct Info: LevelConfig {
        public var backgroundColor: UIColor? = .clear
        public var iconImage: UIImage? = DefaultIcons.Info
        public var iconImageTintColor: UIColor? = DefaultColors.InfoDark

        public init() {}
    }

    public struct Warning: LevelConfig {
        public var backgroundColor: UIColor? = .clear
        public var iconImage: UIImage? = DefaultIcons.Warning
        public var iconImageTintColor: UIColor? = DefaultColors.WarningDark

        public init() {}
    }
}
