//
// Created by Johnny Choi on 2/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

/// Represents configurations for theming a notice by level
public protocol LevelConfig {
    
    /// Notice background color
    var backgroundColor: UIColor? { get set }
    
    /// Notice title text color
    var titleTextColor: UIColor? { get set }
    
    /// Notice title label background color
    var titleBackgroundColor: UIColor? { get set }
    
    /// Notice body text color
    var bodyTextColor: UIColor? { get set }
    
    /// Notice body label background color
    var bodyBackgroundColor: UIColor? { get set }
    
    /// Notice icon image
    var iconImage: UIImage? { get set }
    
    /// Notice icon image tint color
    var iconImageTintColor: UIColor? { get set }
}

/// Optional protocol variables with default values
extension LevelConfig {
    public var backgroundColor: UIColor? {
        get { nil }
        set {}
    }
    public var titleTextColor: UIColor? {
        get { nil }
        set {}
    }
    public var titleBackgroundColor: UIColor? {
        get { nil }
        set {}
    }
    public var bodyTextColor: UIColor? {
        get { nil }
        set {}
    }
    public var bodyBackgroundColor: UIColor? {
        get { nil }
        set {}
    }
    public var iconImage: UIImage? {
        get { nil }
        set {}
    }
    public var iconImageTintColor: UIColor? {
        get { nil }
        set {}
    }
}
