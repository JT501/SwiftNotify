//
// Created by Johnny Choi on 3/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import Foundation

/// SwiftNotify **Classic Dark** theme
class ClassicDark: ThemeProtocol {
    typealias E = DefaultNoticeType
    typealias V = ClassicView

    let titleTextColor: UIColor = .white

    let bodyTextColor: UIColor = .white

    let iconImageTintColor: UIColor? = .white

    let cornerRadius: CGFloat = 10
    let paddingOffset: CGFloat = 10

    let typeDictionary: [E: NoticeTypeProtocol] = [
        .success: Success(),
        .fail: Fail(),
        .info: Info(),
        .warning: Warning()
    ]
}

private struct Success: NoticeTypeProtocol {
    let backgroundColor: UIColor = DefaultColors.SuccessDark
    let iconImage: UIImage? = DefaultIcons.SuccessSolid
}

private struct Fail: NoticeTypeProtocol {
    let backgroundColor: UIColor = DefaultColors.FailDark
    let iconImage: UIImage? = DefaultIcons.FailSolid
}

private struct Info: NoticeTypeProtocol {
    let backgroundColor: UIColor = DefaultColors.InfoDark
    let iconImage: UIImage? = DefaultIcons.InfoSolid
}

private struct Warning: NoticeTypeProtocol {
    let backgroundColor: UIColor = DefaultColors.WarningDark
    let iconImage: UIImage? = DefaultIcons.WarningSolid
}


