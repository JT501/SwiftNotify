//
// Created by Johnny Choi on 5/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import Foundation

/// Represents the duration of a notice
public enum Duration {

    /// 2 seconds
    case short

    /// 4 seconds
    case long

    /// Forever until dismiss manually
    case forever

    /// Custom duration (in seconds)
    case custom(duration: DispatchTimeInterval)
}
