//
// Created by Johnny Choi on 6/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

/// Represents cyber theme configurations
public protocol CyberThemeConfig: ThemeConfig {
    
    /// The cyber view blur effect style
    var blurEffectStyle: UIBlurEffect.Style { get }
    
    /// The cyber vuew vubrancy effect style
    var vibrancyEffectStyle: UIVibrancyEffectStyle { get }
}
