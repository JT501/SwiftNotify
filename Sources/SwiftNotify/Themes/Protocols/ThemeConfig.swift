//
// Created by Johnny Choi on 5/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

/// SwiftNotify Theme Protocol
public protocol ThemeConfig {
    var titleTextColor: UIColor { get }
    var titleTextFont: UIFont { get }
    var titleBackgroundColor: UIColor { get }
    var titleTextAlignment: NSTextAlignment { get }

    var bodyTextColor: UIColor { get }
    var bodyTextFont: UIFont { get }
    var bodyBackgroundColor: UIColor { get }
    var bodyTextAlignment: NSTextAlignment { get }

    var iconViewWidth: CGFloat { get }
    var iconViewHeight: CGFloat { get }
    var iconViewContentMode: UIView.ContentMode { get }
    var iconViewCornerRadius: CGFloat { get }
    var iconImageTintColor: UIColor? { get }

    var cornerRadius: CGFloat { get }
    var padding: CGFloat { get }

    var levelConfigs: [Level: LevelConfig] { get }
}

extension ThemeConfig {
    public var titleTextColor: UIColor { .white }
    public var titleTextFont: UIFont { .boldSystemFont(ofSize: 16) }
    public var titleBackgroundColor: UIColor { .clear }
    public var titleTextAlignment: NSTextAlignment { .left }
    public var blurEffectStyle: UIBlurEffect.Style? { nil }
}
