//
// Created by Johnny Choi on 5/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import Foundation

public protocol NoticeView: UIView {
    init(
            titleText: String?,
            bodyText: String?,
            themeConfig: ThemeConfig,
            level: NoticeLevels
    )
}

