//
// Created by Johnny Choi on 2/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import Foundation

public protocol NoticeLevelProtocol {
    var backgroundColor: UIColor { get }
    var titleTextColor: UIColor? { get }
    var titleBackgroundColor: UIColor? { get }
    var bodyTextColor: UIColor? { get }
    var bodyBackgroundColor: UIColor? { get }
    var iconImage: UIImage? { get }
    var iconImageTintColor: UIColor? { get }
}

/// Optional protocol variables with default values
extension NoticeLevelProtocol {
    var titleTextColor: UIColor? { nil }
    var titleBackgroundColor: UIColor? { nil }
    var bodyTextColor: UIColor? { nil }
    var bodyBackgroundColor: UIColor? { nil }
    var iconImage: UIImage? { nil }
    var iconImageTintColor: UIColor? { nil }
}