//
// Created by Johnny Choi on 5/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

public protocol PhysicsConfig {
    /// The max. drag distance that the view will return to snap point.
    /// If it exceeds the thresholdDistance, the view will be dismissed.
    /// 50.0 by default
    var thresholdDistance: CGFloat { get set }
    var minPushForce: CGFloat { get set }
    var pushForceFactor: CGFloat { get set }
    var defaultPushForce: CGFloat { get set }
    /**
        Rotation speed factor, default: 0.8
        - 0.0 : View will not rotate
        - The higher factor, the faster rotation
        */
    var angularVelocityFactor: CGFloat { get set }
    /**
        Rotation resistance, default: 1.2
        */
    var angularResistance: CGFloat { get set }
    var snapDamping: CGFloat { get set }
}

public struct DefaultPhysicsConfig: PhysicsConfig {
    public var thresholdDistance: CGFloat = 50.0

    public var minPushForce: CGFloat = 8

    public var pushForceFactor: CGFloat = 0.005

    public var defaultPushForce: CGFloat = 12

    public var angularVelocityFactor: CGFloat = 0.8

    public var angularResistance: CGFloat = 1.2

    public var snapDamping: CGFloat = 0.3

    public init() {}
}
