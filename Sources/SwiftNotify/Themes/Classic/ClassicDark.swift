//
// Created by Johnny Choi on 3/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import Foundation

/// SwiftNotify **Classic Dark** theme
open class ClassicDark: ThemeProtocol {
    public typealias E = DefaultNoticeLevels
    public typealias V = ClassicView

    public let titleTextColor: UIColor = .white

    public let bodyTextColor: UIColor = .white

    public let iconImageTintColor: UIColor? = .white

    public let cornerRadius: CGFloat = 10
    public let padding: CGFloat = 10

    public let typeDictionary: [E: NoticeLevelProtocol] = [
        .success: Success(),
        .fail: Fail(),
        .info: Info(),
        .warning: Warning()
    ]
}

private struct Success: NoticeLevelProtocol {
    let backgroundColor: UIColor = DefaultColors.SuccessDark
    let iconImage: UIImage? = DefaultIcons.SuccessSolid
}

private struct Fail: NoticeLevelProtocol {
    let backgroundColor: UIColor = DefaultColors.FailDark
    let iconImage: UIImage? = DefaultIcons.FailSolid
}

private struct Info: NoticeLevelProtocol {
    let backgroundColor: UIColor = DefaultColors.InfoDark
    let iconImage: UIImage? = DefaultIcons.InfoSolid
}

private struct Warning: NoticeLevelProtocol {
    let backgroundColor: UIColor = DefaultColors.WarningDark
    let iconImage: UIImage? = DefaultIcons.WarningSolid
}


