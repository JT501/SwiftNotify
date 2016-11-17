//
//  CFMessageProtocols.swift
//  CFDraggableMessage
//
//  Created by Johnny Choi on 10/11/2016.
//  Copyright © 2016 Johnny Choi@Co-Fire. All rights reserved.
//

import Foundation

public protocol CFMessageDelegate {
    func cfMessageDidAppear()
    func cfMessageIsDragging(atPoint: CGPoint)
    func cfMessageDidTap()
    func cfMessageDidDismiss()
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
