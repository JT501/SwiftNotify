//
//  SwiftMessageView.swift
//  SwiftNotify
//
//  Created by Johnny Tsoi on 10/11/2016.
//  Copyright © 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

open class ToastView: NoticeViewBase {

    /// Max. width of message view
    private let maxWidth: CGFloat = UIScreen.main.bounds.size.width * 0.8

    /// Min. height of message view
    private let minHeight: CGFloat = 50

    // MARK: - Initialization
    public init(text: String) {
        super.init(
                bodyText: text,
                bodyTextFont: .boldSystemFont(ofSize: 17),
                bodyTextAlignment: .center
        )
    }

    public required init(
            titleText: String?,
            bodyText: String?,
            themeConfig: ThemeConfig,
            level: LevelsEnum
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

        bounds.width = viewWidth
        bounds.height = viewHeight

        bodyLabel?.bounds.size = labelSize
        bodyLabel?.center = bounds.center
    }
}
