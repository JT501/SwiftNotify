//
// Created by Johnny Choi on 3/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import Foundation

open class ToastDark: ThemeProtocol {
    public typealias E = DefaultNoticeLevels
    public typealias V = ToastView

    // Toast does not have title
    public var titleTextColor: UIColor = .clear

    public var bodyTextColor: UIColor = .white

    public var typeDictionary: [E: NoticeLevelProtocol] = [
        .success: Success(),
        .fail: Fail(),
        .info: Info(),
        .warning: Warning(),
    ]
}

fileprivate struct Success: NoticeLevelProtocol {
    let backgroundColor: UIColor = DefaultColors.SuccessDark
}

fileprivate struct Fail: NoticeLevelProtocol {
    let backgroundColor: UIColor = DefaultColors.FailDark
}

fileprivate struct Info: NoticeLevelProtocol {
    let backgroundColor: UIColor = DefaultColors.InfoDark
}

fileprivate struct Warning: NoticeLevelProtocol {
    let backgroundColor: UIColor = DefaultColors.WarningDark
}