//
// Created by Johnny Choi on 21/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

class TestablePanRecognizer: UIPanGestureRecognizer {
    private var testTarget: AnyObject?
    private var testAction: Selector?

    private var mockState: UIGestureRecognizer.State?
    private var location: CGPoint?
    private var translation: CGPoint?
    private var velocity: CGPoint?

    override init(target: Any?, action: Selector?) {
        testTarget = target as AnyObject
        testAction = action
        super.init(target: target, action: action)
    }

    override func addTarget(_ target: Any, action: Selector) {
        testTarget = target as AnyObject
        testAction = action
        super.addTarget(target, action: action)
    }

    override var state: State {
        get {
            if let mockState = mockState {
                return mockState
            }
            return super.state
        }
        set {
            super.state = newValue
        }
    }

    override func velocity(in view: UIView?) -> CGPoint {
        if let velocity = velocity {
            return velocity
        }

        return super.velocity(in: view)
    }

    override func translation(in view: UIView?) -> CGPoint {
        if let translation = translation {
            return translation
        }

        return super.translation(in: view)
    }

    override func location(in view: UIView?) -> CGPoint {
        if let location = location {
            return location
        }

        return super.location(in: view)
    }

    /// Mock Pan Gesture
    ///
    /// - Parameters:
    ///   - location:       Pan's location
    ///   - translation:    Pan's translation
    ///   - velocity:       Pan's velocity
    ///   - state:          Pan's state
    func mockPan(
            location: CGPoint? = nil,
            translation: CGPoint? = nil,
            velocity: CGPoint? = nil,
            state: UIGestureRecognizer.State
    ) {
        self.location = location
        self.translation = translation
        self.velocity = velocity
        mockState = state
        _ = testTarget?.perform(testAction, with: self)
    }
}
