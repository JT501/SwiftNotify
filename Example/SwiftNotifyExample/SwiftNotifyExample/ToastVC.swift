//
//  ToastVC.swift
//  SwiftNotifyExample
//
//  Created by Johnny Tsoi on 25/11/2016.
//  Copyright © 2022 Johnny@Co-fire. All rights reserved.
//

import UIKit
import SwiftNotify

class ToastVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SN.defaultTheme = .toast
        SN.defaultFromPosition = .bottom(.random)
        SN.defaultToPosition = .bottom()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showToastView() {

        SN.show(message: "Hello ! I am a Toast", level: .info)

        SN.show(message: "Tap here to hide the toast",
                theme: .toastDark,
                level: .info,
                duration: .forever
        ) { SN.dismiss(byId: $0) }

        SN.show(message: "You can try to tap 'hide' button to hide this toast.", level: .success)

        SN.show(
                message: "You can try to tap 'hide all' button to hide all toast in queue.",
                theme: .toastDark,
                level: .success
        )

        SN.show(message: "Urh! 404 Girlfriend not found.", level: .fail)

        SN.show(message: "Too many toasts here", theme: .toastDark, level: .fail)

        SN.show(message: "You are currently in Friendzone", level: .warning)

        SN.show(message: "This should be the last toast in first queue", theme: .toastDark, level: .warning)
    }

    @IBAction func hideMessage() {
        SN.dismiss()
    }

    @IBAction func hideAll() {
        SN.dismissAll()
    }

}
