//
// Created by Johnny Choi on 2/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

public protocol LevelConfig {
    var backgroundColor: UIColor? { get set }
    var titleTextColor: UIColor? { get set }
    var titleBackgroundColor: UIColor? { get set }
    var bodyTextColor: UIColor? { get set }
    var bodyBackgroundColor: UIColor? { get set }
    var iconImage: UIImage? { get set }
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
