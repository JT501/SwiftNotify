//
// Created by Johnny Choi on 1/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import Foundation

public class SwiftNotifyConfig {
    public init() {}

    public enum InitPosition {
        case top(HorizontalPosition)
        case bottom(HorizontalPosition)
        case left
        case right
        case custom(CGPoint)
    }

    public enum HorizontalPosition {
        case left
        case right
        case center
        case random
    }

    public enum AppearPosition {
        case top
        case center
        case bottom
        case custom(CGPoint)
    }

    public enum HideTime {
        case `default`
        case never
        case custom(seconds: TimeInterval)
    }

    public var initPosition = InitPosition.top(.center)
    public var appearPosition = AppearPosition.center
    public var hideTime = HideTime.default
    /**
        The max. drag distance that the view will return to snap point.
        If exceed the thresholdDistance, the view will hide.
        Default: 50
        */
    public var thresholdDistance: CGFloat = 50
    public var minPushForce: CGFloat = 8
    public var pushForceFactor: CGFloat = 0.005
    public var defaultPushForce: CGFloat = 12
    /**
        Rotation speed factor, default: 0.8
        - 0.0 : View will not rotate
        - The higher factor, the faster rotation
        */
    public var angularVelocityFactor: CGFloat = 0.8
    /**
        Rotation resistance, default: 1.2
        */
    public var angularResistance: CGFloat = 1.2
    public var snapDamping: CGFloat = 0.3
}
