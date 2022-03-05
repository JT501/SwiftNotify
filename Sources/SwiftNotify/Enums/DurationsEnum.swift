//
// Created by Johnny Choi on 5/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import Foundation

public enum DurationsEnum {
    /// 2 seconds
    case short
    /// 4 seconds
    case long
    /// Disable auto dismiss
    case forever
    /// Custom duration
    case custom(duration: DispatchTimeInterval)
}