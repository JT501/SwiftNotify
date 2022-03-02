//
// Created by Johnny Choi on 2/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import Foundation

public protocol NoticeTypeProtocol {
    var backgroundColor: UIColor { get }
    var titleTextColor: UIColor { get }
    var titleBackgroundColor: UIColor { get }
    var bodyTextColor: UIColor { get }
    var bodyBackgroundColor: UIColor { get }
    var iconImage: UIImage? { get }
    var iconImageTintColor: UIColor? { get }
}

public enum DefaultNoticeType: String {
    case success
    case fail
    case info
    case warning
}