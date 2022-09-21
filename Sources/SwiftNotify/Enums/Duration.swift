//
// Created by Johnny Choi on 5/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import Foundation

/// Represents the duration (in ms) of a notice
public enum Duration: CaseIterable, Hashable {
    public static var allCases: [Duration] = [short, long, forever]

    /// 2 seconds
    case short

    /// 4 seconds
    case long

    /// Forever until dismiss manually
    case forever

    /// Custom duration in ms
    case custom(Int)

    var value: Int? {
        switch self {
        case .short:
            return 2000
        case .long:
            return 4000
        case .forever:
            return nil
        case .custom(let ms):
            return ms
        }
    }
}

