//
// Created by Johnny Choi on 5/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

/// Represents configurations for theming notices
public protocol ThemeConfig {
    /// Notice title text color
    var titleTextColor: UIColor { get }
    
    /// Notice title text font
    var titleTextFont: UIFont { get }
    
    /// Notice title label background color
    var titleBackgroundColor: UIColor { get }
    
    /// Notice title text alignment
    var titleTextAlignment: NSTextAlignment { get }

    /// Notice body text color
    var bodyTextColor: UIColor { get }
    
    /// Notice body text font
    var bodyTextFont: UIFont { get }
    
    /// Notice body label background color
    var bodyBackgroundColor: UIColor { get }
    
    /// Notice body text alignment
    var bodyTextAlignment: NSTextAlignment { get }

    /// Notice icon view width
    var iconViewWidth: CGFloat { get }
    
    /// Notice icon view height
    var iconViewHeight: CGFloat { get }
    
    /// Notice icon view's content mode
    var iconViewContentMode: UIView.ContentMode { get }
    
    /// Notice icon view's corner radius
    var iconViewCornerRadius: CGFloat { get }
    
    /// Notice icon image's tint color
    var iconImageTintColor: UIColor? { get }

    /// Notice view's corner radius
    var cornerRadius: CGFloat { get }
    
    /// Notice content padding
    var padding: CGFloat { get }

    /// Configurations for each level
    var levelConfigs: [Level: LevelConfig] { get }
}

extension ThemeConfig {
    public var titleTextColor: UIColor { .white }
    public var titleTextFont: UIFont { .boldSystemFont(ofSize: 16) }
    public var titleBackgroundColor: UIColor { .clear }
    public var titleTextAlignment: NSTextAlignment { .left }
    
    /// Notice view's blur effect style (for ``CyberView`` only)
    public var blurEffectStyle: UIBlurEffect.Style? { nil }
}
