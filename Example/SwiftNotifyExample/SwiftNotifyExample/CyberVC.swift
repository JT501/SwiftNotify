//
//  ViewController.swift
//  CFMessageExample
//
//  Created by Johnny on 9/11/2016.
//  Copyright © 2022 Johnny@Co-fire. All rights reserved.
//

import UIKit
import SwiftNotify

class CyberVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        SN.delegate = self
        SN.defaultTheme = .cyber
        SN.defaultFromPosition = .top(.random)
        SN.defaultToPosition = .center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showCyberView() {
        SN.show(title: "Success", message: "You made alert more playable !", level: .success)

        SN.show(
                title: "Success",
                message: "You can try to tap 'hide' button to hide this alert.",
                theme: .cyberDark,
                level: .success
        ) { SN.dismiss(byId: $0) }

        SN.show(title: "Info", message: "Try dragging this alert around !", level: .info)

        SN.show(
                title: "Info",
                message: "You can tap this alert to hide it.",
                theme: .cyberDark,
                level: .info,
                duration: .forever
        ) { SN.dismiss(byId: $0) }

        SN.show(title: "Info", message: "Try dragging this alert around !", level: .info)

        SN.show(
                title: "Fail",
                message: "You can try to tap 'hide all' button to hide all alerts in queue.",
                level: .fail
        )

        SN.show(title: "Fail", message: "404 Girlfriend not found", theme: .cyberDark, level: .fail)

        SN.show(title: "Warning", message: "You are currently in Friendzone", level: .warning)

        SN.show(
                title: "Warning",
                message: "This should be the last one in first queue",
                theme: .cyberDark,
                level: .warning
        )
    }

    @IBAction func hideMessage() {
        SN.dismissCurrent()
    }

    @IBAction func hideAll() {
        SN.clearAllNotices()
    }
}


// MARK: - SwiftNotifyDelegate

extension CyberVC: SwiftNotifyDelegate {
    func swiftNotifyDidAppear(notice: Notice) {
        print("Notice \(notice.id) is shown")
    }

    func swiftNotifyDidDisappear(notice: Notice) {
        print("Notice \(notice.id) is dismissed")
    }

    func swiftNotifyStartPanning(at point: CGPoint, notice: Notice) {
        print("Notice \(notice.id) start panning at \(point)")
    }

    func swiftNotifyIsPanning(at point: CGPoint, notice: Notice) {
        print("Notice \(notice.id) is panning at \(point)")
    }

    func swiftNotifyEndPanning(at point: CGPoint, notice: Notice) {
        print("Notice \(notice.id) end dragging")
    }

    func swiftNotifyIsTapped(notice: Notice) {
        print("Notice \(notice.id) is tapped")
    }
}