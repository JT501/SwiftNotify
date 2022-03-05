//
//  SwiftMessageProtocols.swift
//  SwiftNotify
//
//  Created by Johnny Tsoi on 10/11/2016.
//  Copyright © 2022 Johnny Tsoi@JT501. All rights reserved.
//

import Foundation
import UIKit

public protocol SwiftNotifyDelegate: AnyObject {
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
protocol NotifyDelegate: AnyObject {
    func notifierDidAppear()
    func notifierStartDragging(atPoint: CGPoint)
    func notifierIsDragging(atPoint: CGPoint)
    func notifierEndDragging(atPoint: CGPoint)
    func notifierDidDisappear(notifier: Notice)
    func notifierIsTapped()
}
