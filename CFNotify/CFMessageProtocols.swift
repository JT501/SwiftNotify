//
//  CFMessageProtocols.swift
//  CFNotify
//
//  Created by Johnny Choi on 10/11/2016.
//  Copyright © 2016 Johnny Choi@Co-Fire. All rights reserved.
//

import Foundation
import UIKit

public protocol CFMessageDelegate: class {
    func cfMessageDidAppear()
    func cfMessageStartDragging(atPoint: CGPoint)
    func cfMessageIsDragging(atPoint: CGPoint)
    func cfMessageEndDragging(atPoint: CGPoint)
    func cfMessageDidDisappear()
    func cfMessageIsTapped()
}

// Make the protocol methods to be optional
public extension CFMessageDelegate {
    func cfMessageDidAppear() {}
    func cfMessageStartDragging(atPoint: CGPoint) {}
    func cfMessageIsDragging(atPoint: CGPoint) {}
    func cfMessageEndDragging(atPoint: CGPoint) {}
    func cfMessageDidDisappear() {}
    func cfMessageIsTapped() {}
}

// Internal Use
protocol MessengerDelegate: class {
    func messengerDidAppear()
    func messengerStartDragging(atPoint: CGPoint)
    func messengerIsDragging(atPoint: CGPoint)
    func messengerEndDragging(atPoint: CGPoint)
    func messengerDidDisappear(messenger: Messenger)
    func messengerIsTapped()
}
