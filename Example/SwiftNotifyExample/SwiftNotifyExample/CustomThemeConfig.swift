//
// Created by Johnny Choi on 5/3/2022.
// Copyright (c) 2022 Johnny@Co-fire. All rights reserved.
//

import Foundation
import SwiftNotify

struct CustomThemeConfig: ThemeConfig {
    var bodyTextColor: UIColor = .white

    var bodyTextFont: UIFont = .systemFont(ofSize: 18)

    var bodyBackgroundColor: UIColor = .black

    var bodyTextAlignment: NSTextAlignment = .center

    var iconViewWidth: CGFloat = 100

    var iconViewHeight: CGFloat = 100

    var iconViewContentMode: UIView.ContentMode = .scaleAspectFit

    var iconViewCornerRadius: CGFloat = 35

    var iconImageTintColor: UIColor? = nil

    var cornerRadius: CGFloat = 20

    var padding: CGFloat = 15

    var levelConfigs: [LevelsEnum: LevelConfig] = [
        .success: Success(),
        .fail: Fail(),
        .info: Info(),
        .warning: Warning()
    ]

    struct Success: LevelConfig {
        var backgroundColor: UIColor? = .lightGray
        var iconImage: UIImage? = SwiftNotify.Icons.Success
    }

    struct Fail: LevelConfig {
        var backgroundColor: UIColor? = .systemPink
        var iconImage: UIImage? = SwiftNotify.Icons.Fail
    }

    struct Info: LevelConfig {
        var backgroundColor: UIColor? = .systemPurple
        var iconImage: UIImage? = SwiftNotify.Icons.Info
    }

    struct Warning: LevelConfig {
        var backgroundColor: UIColor? = .systemYellow
        var iconImage: UIImage? = SwiftNotify.Icons.Warning
    }
}
