//
// Created by Johnny Choi on 3/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import Foundation

public protocol ThemeProtocol {
    associatedtype E: RawRepresentable & Hashable
    associatedtype V: NoticeView

    var titleTextFont: UIFont { get }
    var titleTextAlignment: NSTextAlignment { get }

    var bodyTextFont: UIFont { get }
    var bodyTextAlignment: NSTextAlignment { get }

    var iconViewWidth: CGFloat { get }
    var iconViewHeight: CGFloat { get }
    var iconViewContentMode: UIView.ContentMode { get }
    var iconViewCornerRadius: CGFloat { get }

    var cornerRadius: CGFloat { get }
    var paddingOffset: CGFloat { get }

    var typeDictionary: [E: NoticeTypeProtocol] { get }
}