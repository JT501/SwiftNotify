//
//  ClassicVC.swift
//  SwiftNotifyExample
//
//  Created by Johnny Tsoi on 25/11/2016.
//  Copyright © 2022 Johnny@Co-fire. All rights reserved.
//

import UIKit
import SwiftNotify

class ClassicVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SN.defaultTheme = .classic
        SN.defaultFromPosition = .top(.random)
        SN.defaultToPosition = .top()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showClassicView() {
        SN.show(title: "Information", message: "This is Classic View alert.", level: .info)

        SN.show(
                title: "Information",
                message: "You can tap this notice to hide it.",
                theme: .classicDark,
                level: .info,
                duration: .forever
        ) { SN.dismiss(byId: $0) }

        SN.show(title: "Success", message: "Great. The message is shown successfully.", level: .success)

        SN.show(
                title: "Success",
                message: "You can try to tap 'hide' button to hide this alert.",
                theme: .classicDark,
                level: .success
        )

        SN.show(title: "Error", message: "Urh! 404 Girlfriend not found.", level: .fail)

        SN.show(
                title: "Error",
                message: "You can try to tap 'hide all' button to hide all alerts in queue.",
                theme: .classicDark,
                level: .fail
        )

        SN.show(title: "Warning", message: "You are currently in Friendzone", level: .warning)

        SN.show(
                title: "Warning",
                message: "This should be the last one in first queue",
                theme: .classicDark,
                level: .warning
        )
    }

    @IBAction func hideMessage() {
        SN.dismiss()
    }

    @IBAction func hideAll() {
        SN.dismissAll()
    }

}
