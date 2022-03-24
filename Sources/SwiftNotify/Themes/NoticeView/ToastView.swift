//
//  SwiftMessageView.swift
//  SwiftNotify
//
//  Created by Johnny Tsoi on 10/11/2016.
//  Copyright © 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

/// **Toast** Notice view
open class ToastView: NoticeViewBase {

    /// Max. width of message view
    private let maxWidth: CGFloat = UIScreen.main.bounds.size.width * 0.8

    /// Min. height of message view
    private let minHeight: CGFloat = 50
    
    /// Create a **toast** notice view
    /// - Parameters:
    ///   - bodyText: The message of notice
    ///   - themeConfig: Theme configuration
    ///   - level: Notice level
    public convenience required init(bodyText: String?, themeConfig: ThemeConfig, level: Level) {
        self.init(titleText: nil, bodyText: bodyText, themeConfig: themeConfig, level: level)
    }

    /// Create a **toast** notice view
    ///
    /// - Parameters:
    ///   - titleText: **Useless for toast view, since toast has no title**
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

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Resize to fit text
    override func resizeToFit() {
        var labelSize = getCalculatedLabelSize(text: bodyText, font: bodyTextFont)

        if labelSize.width > (maxWidth - padding * 2) {
            labelSize = getCalculatedLabelSize(
                    text: bodyText,
                    font: bodyTextFont,
                    width: maxWidth - padding * 2)
        }

        let viewWidth = labelSize.width + padding * 2
        let viewHeight = labelSize.height + padding * 2

        bounds.size.width = viewWidth
        bounds.size.height = viewHeight

        bodyLabel?.bounds.size = labelSize
        bodyLabel?.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
}
