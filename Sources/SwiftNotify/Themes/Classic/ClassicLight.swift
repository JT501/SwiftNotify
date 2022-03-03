//
// Created by Johnny Choi on 3/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import Foundation

/// SwiftNotify **Classic Light** theme
class ClassicLight: ThemeProtocol {
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
    let backgroundColor: UIColor = DefaultColors.Success
    let iconImage: UIImage? = UIImage(
            named: "icon_success",
            in: ResourceBundle,
            compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)
}

private struct Fail: NoticeTypeProtocol {
    let backgroundColor: UIColor = DefaultColors.Fail
    let iconImage: UIImage? = UIImage(
            named: "icon_fail",
            in: ResourceBundle,
            compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)
}

private struct Info: NoticeTypeProtocol {
    let backgroundColor: UIColor = DefaultColors.Info
    let iconImage: UIImage? = UIImage(
            named: "icon_info",
            in: ResourceBundle,
            compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)
}

private struct Warning: NoticeTypeProtocol {
    let backgroundColor: UIColor = DefaultColors.Warning
    let iconImage: UIImage? = UIImage(
            named: "icon_info",
            in: ResourceBundle,
            compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)
}


