//
// Created by Johnny Choi on 5/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

public enum FromPositionsEnum {
    case top(HorizontalPosition)
    case bottom(HorizontalPosition)
    case left
    case right
    case custom(CGPoint)

    public enum HorizontalPosition {
        case left
        case right
        case center
        case random
    }
}
