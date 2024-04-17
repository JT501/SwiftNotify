//
// Created by Johnny Choi on 5/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

/// Represents notice views
public protocol NoticeView: UIView {
    /// Create a notice view
    ///
    /// - Parameters:
    ///   - titleText: Title string
    ///   - bodyText: Body string
    ///   - themeConfig: Theme configuration
    ///   - level: Notice's level
    init(
            titleText: String?,
            bodyText: String?,
            themeConfig: ThemeConfig,
            level: Level
    )
}

