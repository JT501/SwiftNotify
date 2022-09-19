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
    func swiftNotifyDidAppear(notice: Notice)
    func swiftNotifyStartPanning(atPoint: CGPoint, notice: Notice)
    func swiftNotifyIsPanning(atPoint: CGPoint, notice: Notice)
    func swiftNotifyEndPanning(atPoint: CGPoint, notice: Notice)
    func swiftNotifyDidDisappear(notice: Notice)
    func swiftNotifyIsTapped(notice: Notice)
}

// Make the protocol methods to be optional
public extension SwiftNotifyDelegate {
    func swiftNotifyDidAppear(notice: Notice) {}
    func swiftNotifyStartPanning(atPoint: CGPoint, notice: Notice) {}
    func swiftNotifyIsPanning(atPoint: CGPoint, notice: Notice) {}
    func swiftNotifyEndPanning(atPoint: CGPoint, notice: Notice) {}
    func swiftNotifyDidDisappear(notice: Notice) {}
    func swiftNotifyIsTapped(notice: Notice) {}
}
