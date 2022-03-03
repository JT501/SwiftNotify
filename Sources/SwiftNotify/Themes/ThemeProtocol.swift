//
// Created by Johnny Choi on 3/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import Foundation

/// SwiftNotify Theme Protocol
public protocol ThemeProtocol {
    /// Notice Type Enum Type
    associatedtype E: RawRepresentable & Hashable

    /// Notice View Class Type
    associatedtype V: NoticeView

    var titleTextColor: UIColor { get }
    var titleTextFont: UIFont { get }
    var titleBackgroundColor: UIColor { get }
    var titleTextAlignment: NSTextAlignment { get }

    var bodyTextColor: UIColor { get }
    var bodyTextFont: UIFont { get }
    var bodyBackgroundColor: UIColor { get}
    var bodyTextAlignment: NSTextAlignment { get }

    var iconViewWidth: CGFloat { get }
    var iconViewHeight: CGFloat { get }
    var iconViewContentMode: UIView.ContentMode { get }
    var iconViewCornerRadius: CGFloat { get }
    var iconImageTintColor: UIColor? { get }

    var cornerRadius: CGFloat { get }
    var paddingOffset: CGFloat { get }

    var typeDictionary: [E: NoticeLevelProtocol] { get }
}

/// Optional protocol variables with default values
extension ThemeProtocol {
    public var titleTextFont: UIFont { .boldSystemFont(ofSize: 16) }
    public var titleBackgroundColor: UIColor { .clear }
    public var titleTextAlignment: NSTextAlignment { .left }

    public var bodyTextFont: UIFont { .systemFont(ofSize: 13, weight: UIFont.Weight.regular) }
    public var bodyBackgroundColor: UIColor { .clear }
    public var bodyTextAlignment: NSTextAlignment { .left }

    public var iconViewWidth: CGFloat { 50 }
    public var iconViewHeight: CGFloat { 50 }
    public var iconViewContentMode: UIView.ContentMode { .scaleAspectFit }
    public var iconViewCornerRadius: CGFloat { 25 }
    public var iconImageTintColor: UIColor? { nil }

    public var cornerRadius: CGFloat { 10 }
    public var paddingOffset: CGFloat { 10 }
}