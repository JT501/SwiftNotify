//
//  CFMessageProtocols.swift
//  CFNotify
//
//  Created by Johnny Choi on 10/11/2016.
//  Copyright © 2016 Johnny Choi@Co-Fire. All rights reserved.
//

import Foundation
import UIKit

public protocol CFNotifyDelegate: class {
    func cfNotifyDidAppear()
    func cfNotifyStartDragging(atPoint: CGPoint)
    func cfNotifyIsDragging(atPoint: CGPoint)
    func cfNotifyEndDragging(atPoint: CGPoint)
    func cfNotifyDidDisappear()
    func cfNotifyIsTapped()
}

// Make the protocol methods to be optional
public extension CFNotifyDelegate {
    func cfNotifyDidAppear() {}
    func cfNotifyStartDragging(atPoint: CGPoint) {}
    func cfNotifyIsDragging(atPoint: CGPoint) {}
    func cfNotifyEndDragging(atPoint: CGPoint) {}
    func cfNotifyDidDisappear() {}
    func cfNotifyIsTapped() {}
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
