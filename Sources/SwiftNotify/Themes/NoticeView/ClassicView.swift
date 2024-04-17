//
//  TitleView.swift
//  SwiftNotify
//
//  Created by Johnny Tsoi on 18/11/2016.
//  Copyright © 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

/// **Classic** Notice view
open class ClassicView: NoticeViewBase {

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Create a **classic** notice view
    ///
    /// - Parameters:
    ///   - titleText: The title
    ///   - bodyText: The message
    ///   - themeConfig: Theme configuration
    ///   - level: Notice level
    public required init(
            titleText: String?,
            bodyText: String?,
            themeConfig: ThemeConfig,
            level: Level
    ) {
        guard let levelConfig = themeConfig.levelConfigs[level] else { fatalError("Level not found in theme config") }
        super.init(
                titleText: titleText,
                titleTextColor: levelConfig.titleTextColor ?? themeConfig.titleTextColor,
                titleTextFont: themeConfig.titleTextFont,
                titleTextAlignment: themeConfig.titleTextAlignment,
                titleBackgroundColor: levelConfig.titleBackgroundColor ?? themeConfig.titleBackgroundColor,
                bodyText: bodyText,
                bodyTextColor: levelConfig.bodyTextColor ?? themeConfig.bodyTextColor,
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
                padding: themeConfig.padding
        )
    }
}

