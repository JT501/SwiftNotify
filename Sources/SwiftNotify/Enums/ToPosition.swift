//
// Created by Johnny Choi on 5/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

/// Represent the position of the window where a notice will snap to
/// from specific ``FromPosition``.
public enum ToPosition {
    
    /// Top of the window
    ///
    /// - Parameter offset: Offset to the top
    case top(offset: CGFloat = 100.0)
    
    /// Center of the window
    case center
    
    /// Bottom of the window
    ///
    /// - Parameter offset: Offset to the bottom
    case bottom(offset: CGFloat = 50.0)
    
    /// Custom `CGPoint` position
    case custom(CGPoint)
}
