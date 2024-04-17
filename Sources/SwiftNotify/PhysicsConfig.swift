//
// Created by Johnny Choi on 5/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

/// Represents the configuration for interactive animations.
public struct PhysicsConfig {
    
    /// The max. drag distance from center of a notice view to snap point which
    ///  the notice will return to its snap point (``ToPosition``).
    ///
    /// If it exceeds the ``thresholdDistance``, the view will be dismissed.
    /// The default value is 50.0.
    public var thresholdDistance: CGFloat = 50.0

    /// Rotation resistance.
    ///
    /// Valid range is 0 through `CGFLOAT_MAX`. The greater the value,
    /// the greater the angular damping and the faster rotation slows to a stop.
    /// The default value is 1.0.
    public var angularResistance: CGFloat = 1.0

    /// The amount of oscillation of a dynamic item during the conclusion of a notice snap.
    ///
    /// The valid range for damping extends from 0.0, for maximum oscillation, through 1.0,
    /// for minimum oscillation.
    /// The default value is 0.3.
    public var snapDamping: CGFloat = 0.3

    
    /// Create a Physics Config based on given parameters.
    /// - Parameters:
    ///   - thresholdDistance: The max. drag distance from center of a notice view to snap point which
    ///  the notice will return to its snap point (``ToPosition``).
    ///   - angularResistance: Rotation resistance.
    ///   - snapDamping: The amount of oscillation of a dynamic item during the conclusion of a notice snap.
    public init(
            thresholdDistance: CGFloat = 50.0,
            angularResistance: CGFloat = 1.0,
            snapDamping: CGFloat = 0.3
    ) {
        self.thresholdDistance = thresholdDistance
        self.angularResistance = angularResistance
        self.snapDamping = snapDamping
    }
}
