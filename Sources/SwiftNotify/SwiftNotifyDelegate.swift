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
    func swiftNotifyStartDragging(atPoint: CGPoint, notice: Notice)
    func swiftNotifyIsDragging(atPoint: CGPoint, notice: Notice)
    func swiftNotifyEndDragging(atPoint: CGPoint, notice: Notice)
    func swiftNotifyDidDisappear(notice: Notice)
    func swiftNotifyIsTapped(notice: Notice)
}

// Make the protocol methods to be optional
public extension SwiftNotifyDelegate {
    func swiftNotifyDidAppear(notice: Notice) {}
    func swiftNotifyStartDragging(atPoint: CGPoint, notice: Notice) {}
    func swiftNotifyIsDragging(atPoint: CGPoint, notice: Notice) {}
    func swiftNotifyEndDragging(atPoint: CGPoint, notice: Notice) {}
    func swiftNotifyDidDisappear(notice: Notice) {}
    func swiftNotifyIsTapped(notice: Notice) {}
}

// Internal Use
protocol NoticeDelegate: AnyObject {
    func noticeDidAppear(notice: Notice)
    func noticeStartDragging(atPoint: CGPoint, notice: Notice)
    func noticeIsDragging(atPoint: CGPoint, notice: Notice)
    func noticeEndDragging(atPoint: CGPoint, notice: Notice)
    func noticeDidDisappear(notice: Notice)
    func noticeIsTapped(notice: Notice)
}
