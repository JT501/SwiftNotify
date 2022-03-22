//
// Created by Johnny Choi on 22/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

class TestableLongPressRecognizer: UILongPressGestureRecognizer {
    private var testTarget: AnyObject?
    private var testAction: Selector?

    private var mockState: UIGestureRecognizer.State?

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

    /// Mock Long Press Gesture
    ///
    /// - Parameter state: Long Press's state
    func mockLongPress(state: UIGestureRecognizer.State) {
        mockState = state
        _ = testTarget?.perform(testAction, with: self)
    }
}
