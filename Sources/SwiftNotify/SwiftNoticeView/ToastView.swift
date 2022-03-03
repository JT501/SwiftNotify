//
//  SwiftMessageView.swift
//  SwiftNotify
//
//  Created by Johnny Tsoi on 10/11/2016.
//  Copyright © 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

open class ToastView: NoticeView {

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

    /// Custom init from theme and level
    public required init<T: ThemeProtocol>(
            titleText: String?,
            bodyText: String?,
            theme: T,
            level: T.E,
            width: CGFloat,
            height: CGFloat
    ) {
        super.init(
                titleText: titleText,
                bodyText: bodyText,
                theme: theme,
                level: level,
                width: width,
                height: height)
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

        var viewWidth = labelSize.width + padding * 2
        var viewHeight = labelSize.height + padding * 2

        bounds.width = viewWidth
        bounds.height = viewHeight

        bodyLabel?.bounds.size = labelSize
        bodyLabel?.center = bounds.center
    }
}
