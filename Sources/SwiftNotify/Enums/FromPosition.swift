//
// Created by Johnny Choi on 5/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

/// Represents the starting position where a notice is created.
///
/// The `FromPosition` is outside the visible bound of window.
public enum FromPosition {
    
    /// Outside the top of the window's bound
    case top(HorizontalPosition)
    
    /// Outside the bottom of the window's bound
    case bottom(HorizontalPosition)
    
    /// Outside the left of the window's bound
    case left
    
    /// Outside the right of the window's bound
    case right
    
    /// Custom `CGPoint` position
    case custom(CGPoint)

    /// Represents the horizontal position of ``top(_:)`` and ``bottom(_:)``
    public enum HorizontalPosition: String {
        case left
        case right
        case center
        
        /// Random position
        case random
    }
}
