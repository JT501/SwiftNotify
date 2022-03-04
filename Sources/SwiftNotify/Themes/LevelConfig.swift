//
// Created by Johnny Choi on 2/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import Foundation

public protocol LevelConfig {
    var backgroundColor: UIColor? { get }
    var titleTextColor: UIColor? { get }
    var titleBackgroundColor: UIColor? { get }
    var bodyTextColor: UIColor? { get }
    var bodyBackgroundColor: UIColor? { get }
    var iconImage: UIImage? { get }
    var iconImageTintColor: UIColor? { get }
}

/// Optional protocol variables with default values
extension LevelConfig {
    public var backgroundColor: UIColor? { nil }
    public var titleTextColor: UIColor? { nil }
    public var titleBackgroundColor: UIColor? { nil }
    public var bodyTextColor: UIColor? { nil }
    public var bodyBackgroundColor: UIColor? { nil }
    public var iconImage: UIImage? { nil }
    public var iconImageTintColor: UIColor? { nil }
}