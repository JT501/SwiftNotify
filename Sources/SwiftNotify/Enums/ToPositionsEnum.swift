//
// Created by Johnny Choi on 5/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import Foundation

public enum ToPositionsEnum {
    case top(offset: CGFloat = 100.0)
    case center
    case bottom(offset: CGFloat = 50.0)
    case custom(CGPoint)
}
