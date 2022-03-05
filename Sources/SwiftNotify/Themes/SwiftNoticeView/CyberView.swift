//
//  TitleView.swift
//  SwiftNotify
//
//  Created by Johnny Tsoi on 22/11/2016.
//  Copyright © 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

open class CyberView: NoticeViewBase {
    /// Blur Effect
    private let blurEffect: UIBlurEffect

    private let blurEffectView: UIVisualEffectView
    private let vibrancyEffect: UIVibrancyEffect
    private let vibrancyEffectView: UIVisualEffectView

    // MARK: - Initialization
    public init(title: String? = nil, body: String? = nil, image: UIImage? = nil, blurStyle: UIBlurEffect.Style) {
        blurEffect = UIBlurEffect(style: blurStyle)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)

        let image = image?.withRenderingMode(.alwaysTemplate)

        super.init(titleText: title, bodyText: body, iconImage: image)
    }

    public required convenience init(
            titleText: String?,
            bodyText: String?,
            themeConfig: ThemeConfig,
            level: NoticeLevels
    ) {
        let levelConfig = themeConfig.levelConfigs[.success]!
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
                blurEffectStyle: themeConfig.blurEffectStyle!
        )
    }

    public init(
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
            blurEffectStyle: UIBlurEffect.Style
    ) {
        blurEffect = UIBlurEffect(style: blurEffectStyle)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
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

