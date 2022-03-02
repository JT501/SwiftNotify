//
// Created by Johnny Choi on 3/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import Foundation

class ClassicLight: ThemeProtocol {
    typealias E = DefaultNoticeType
    typealias V = ClassicView

    let titleTextFont: UIFont = .boldSystemFont(ofSize: 16)
    let titleTextAlignment: NSTextAlignment = .left

    let bodyTextFont: UIFont = .systemFont(ofSize: 13, weight: UIFont.Weight.regular)
    let bodyTextAlignment: NSTextAlignment = .left

    let iconViewWidth: CGFloat = 50
    let iconViewHeight: CGFloat = 50
    let iconViewContentMode: UIView.ContentMode = .scaleAspectFill
    let iconViewCornerRadius: CGFloat = 25

    let cornerRadius: CGFloat = 10
    let paddingOffset: CGFloat = 10

    let typeDictionary: [E: NoticeTypeProtocol] = [
        .success: Success(),
        .fail: Success(),
        .info: Success(),
        .warning: Success()
    ]
}

private struct Success: NoticeTypeProtocol {
    let backgroundColor: UIColor = UIColor(red: 65.0 / 256.0, green: 131.0 / 256.0, blue: 215.0 / 256.0, alpha: 1.0)
    let titleTextColor: UIColor = .white
    let titleBackgroundColor: UIColor = .clear
    let bodyTextColor: UIColor = .white
    let bodyBackgroundColor: UIColor = .clear
    let iconImage: UIImage? = UIImage(
            named: "icon_success",
            in: ResourceBundle,
            compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)
    let iconImageTintColor: UIColor? = .white
}
