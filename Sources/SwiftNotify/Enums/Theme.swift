//
// Created by Johnny Choi on 5/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import Foundation

/// Represents the notice theme
public enum Theme: String, CaseIterable {
    /// Classic theme
    case classic = "Classic"
    
    /// Classic theme (Dark Mode)
    case classicDark = "Classic Dark"
    
    /// Cyber theme
    case cyber = "Cyber"
    
    /// Cyber theme (Dark Mode)
    case cyberDark = "Cyber Dark"
    
    /// Toast theme
    case toast = "Toast"
    
    /// Toast theme (Dark Mode)
    case toastDark = "Toast Dark"
}
