//
// Created by Johnny Choi on 3/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import Foundation

/// SwiftNotify **Classic Dark** theme
class ClassicDark: ThemeProtocol {
    typealias E = DefaultNoticeLevels
    typealias V = ClassicView

    let titleTextColor: UIColor = .white

    let bodyTextColor: UIColor = .white

    let iconImageTintColor: UIColor? = .white

    let cornerRadius: CGFloat = 10
    let paddingOffset: CGFloat = 10

    let typeDictionary: [E: NoticeLevelProtocol] = [
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


