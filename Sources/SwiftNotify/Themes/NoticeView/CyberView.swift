//
//  TitleView.swift
//  SwiftNotify
//
//  Created by Johnny Tsoi on 22/11/2016.
//  Copyright © 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

/// **Cyber** Notice view
open class CyberView: NoticeViewBase {
    /// Blur Effect
    private let blurEffect: UIBlurEffect

    private let blurEffectView: UIVisualEffectView
    private let vibrancyEffect: UIVibrancyEffect
    private let vibrancyEffectView: UIVisualEffectView
    
    /// Create a **cyber** notice view
    ///
    /// - Parameters:
    ///   - titleText: The title
    ///   - bodyText: The message
    ///   - cyberThemeConfig: Cyber Theme configuration
    ///   - level: Notice level
    public convenience init(
        titleText: String?,
        bodyText: String?,
        cyberThemeConfig: CyberThemeConfig,
        level: Level
    ) {
        self.init(titleText: titleText, bodyText: bodyText, themeConfig: cyberThemeConfig, level: level)
    }

    /// Create a **cyber** notice view
    ///
    /// - Parameters:
    ///   - titleText: The title
    ///   - bodyText: The message
    ///   - themeConfig: Cyber Theme configuration
    ///   - level: Notice level
    public required convenience init(
            titleText: String?,
            bodyText: String?,
            themeConfig: ThemeConfig,
            level: Level
    ) {
        guard let themeConfig = themeConfig as? CyberThemeConfig else { fatalError("themeConfig is not CyberThemeConfig") }
        guard let levelConfig = themeConfig.levelConfigs[level] else { fatalError("Level not found in theme config") }
        self.init(
                titleText: titleText,
                titleTextColor: levelConfig.titleTextColor ?? themeConfig.titleTextColor,
                titleTextFont: themeConfig.titleTextFont,
                titleTextAlignment: themeConfig.titleTextAlignment,
                titleBackgroundColor: levelConfig.titleBackgroundColor ?? themeConfig.titleBackgroundColor,
                bodyText: bodyText,
                bodyTextColor: levelConfig.bodyTextColor ?? themeConfig.titleTextColor,
                bodyTextFont: themeConfig.bodyTextFont,
                bodyTextAlignment: themeConfig.bodyTextAlignment,
                bodyBackgroundColor: levelConfig.bodyBackgroundColor ?? themeConfig.bodyBackgroundColor,
                iconImage: levelConfig.iconImage,
                iconViewWidth: themeConfig.iconViewWidth,
                iconViewHeight: themeConfig.iconViewHeight,
                iconViewContentMode: themeConfig.iconViewContentMode,
                iconViewCornerRadius: themeConfig.iconViewCornerRadius,
                iconViewTintColor: levelConfig.iconImageTintColor ?? themeConfig.iconImageTintColor,
                width: UIScreen.main.bounds.size.width * 0.8,
                height: 0,
                backgroundColor: levelConfig.backgroundColor,
                cornerRadius: themeConfig.cornerRadius,
                padding: themeConfig.padding,
                blurEffectStyle: themeConfig.blurEffectStyle,
                vibrancyEffectStyle: themeConfig.vibrancyEffectStyle
        )
    }

    init(
            titleText: String?,
            titleTextColor: UIColor,
            titleTextFont: UIFont,
            titleTextAlignment: NSTextAlignment,
            titleBackgroundColor: UIColor,
            bodyText: String?,
            bodyTextColor: UIColor,
            bodyTextFont: UIFont,
            bodyTextAlignment: NSTextAlignment,
            bodyBackgroundColor: UIColor,
            iconImage: UIImage?,
            iconViewWidth: CGFloat,
            iconViewHeight: CGFloat,
            iconViewContentMode: ContentMode,
            iconViewCornerRadius: CGFloat,
            iconViewTintColor: UIColor?,
            width: CGFloat,
            height: CGFloat,
            backgroundColor: UIColor?,
            cornerRadius: CGFloat,
            padding: CGFloat,
            blurEffectStyle: UIBlurEffect.Style,
            vibrancyEffectStyle: UIVibrancyEffectStyle
    ) {
        blurEffect = UIBlurEffect(style: blurEffectStyle)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect, style: vibrancyEffectStyle)
        vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)

        super.init(
                titleText: titleText,
                titleTextColor: titleTextColor,
                titleTextFont: titleTextFont,
                titleTextAlignment: titleTextAlignment,
                titleBackgroundColor: titleBackgroundColor,
                bodyText: bodyText,
                bodyTextColor: bodyTextColor,
                bodyTextFont: bodyTextFont,
                bodyTextAlignment: bodyTextAlignment,
                bodyBackgroundColor: bodyBackgroundColor,
                iconImage: iconImage,
                iconViewWidth: iconViewWidth,
                iconViewHeight: iconViewHeight,
                iconViewContentMode: iconViewContentMode,
                iconViewCornerRadius: iconViewCornerRadius,
                iconViewTintColor: iconViewTintColor,
                width: width,
                height: height,
                backgroundColor: backgroundColor,
                cornerRadius: cornerRadius,
                padding: padding
        )
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addToSubViews() {
        vibrancyEffectView.frame = bounds
        if let iconView = iconView {
            vibrancyEffectView.contentView.addSubview(iconView)
        }
        if let titleLabel = titleLabel {
            vibrancyEffectView.contentView.addSubview(titleLabel)
        }
        if let bodyLabel = bodyLabel {
            vibrancyEffectView.contentView.addSubview(bodyLabel)
        }
        blurEffectView.contentView.addSubview(vibrancyEffectView)

        blurEffectView.frame = bounds
        addSubview(blurEffectView)
    }
}

