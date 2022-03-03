//
//  TitleView.swift
//  SwiftNotify
//
//  Created by Johnny Tsoi on 18/11/2016.
//  Copyright © 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

open class ClassicView: NoticeView {

    public init(
            title: String? = nil,
            body: String? = nil,
            icon: UIImage? = nil) {
        super.init(titleText: title, bodyText: body, iconImage: icon)
    }

    public required init<T: ThemeProtocol>(titleText: String?, bodyText: String?, theme: T, level: T.E, width: CGFloat, height: CGFloat) {
        super.init(titleText: titleText, bodyText: bodyText, theme: theme, level: level)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

