//
//  SwiftMessageProtocols.swift
//  SwiftNotify
//
//  Created by Johnny Choi on 10/11/2016.
//  Copyright © 2016 Johnny Choi@Co-Fire. All rights reserved.
//

import Foundation
import UIKit

public protocol SwiftNotifyDelegate: class {
    func swiftNotifyDidAppear()
    func swiftNotifyStartDragging(atPoint: CGPoint)
    func swiftNotifyIsDragging(atPoint: CGPoint)
    func swiftNotifyEndDragging(atPoint: CGPoint)
    func swiftNotifyDidDisappear()
    func swiftNotifyIsTapped()
}

// Make the protocol methods to be optional
public extension SwiftNotifyDelegate {
    func swiftNotifyDidAppear() {}
    func swiftNotifyStartDragging(atPoint: CGPoint) {}
    func swiftNotifyIsDragging(atPoint: CGPoint) {}
    func swiftNotifyEndDragging(atPoint: CGPoint) {}
    func swiftNotifyDidDisappear() {}
    func swiftNotifyIsTapped() {}
}

// Internal Use
protocol NotifierDelegate: class {
    func notifierDidAppear()
    func notifierStartDragging(atPoint: CGPoint)
    func notifierIsDragging(atPoint: CGPoint)
    func notifierEndDragging(atPoint: CGPoint)
    func notifierDidDisappear(notifier: Notifier)
    func notifierIsTapped()
}
