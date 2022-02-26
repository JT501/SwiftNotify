//
//  ToastVC.swift
//  SwiftNotifyExample
//
//  Created by Johnny Choi on 25/11/2016.
//  Copyright © 2016 Johnny@Co-fire. All rights reserved.
//

import UIKit
import SwiftNotify

class ToastVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showToastView() {
        
        let toastView = SwiftNotifyView.toastWith(text: "This is a Toast",
                                               theme: .info(.light))
        
        let toastViewD = SwiftNotifyView.toastWith(text: "Tap here to hide the toast",
                                                theme: .info(.dark))
        
        let toastView2 = SwiftNotifyView.toastWith(text: "You can try to tap 'hide' button to hide this toast.",
                                                theme: .success(.light))
        
        let toastView2D = SwiftNotifyView.toastWith(text: "You can try to tap 'hide all' button to hide all toast in queue.",
                                                 theme: .success(.dark))
        
        let toastView3 = SwiftNotifyView.toastWith(text: "Urh! 404 Girlfriend not found.",
                                                theme: .fail(.light))
        
        let toastView3D = SwiftNotifyView.toastWith(text: "Too many toasts here",
                                                 theme: .fail(.dark))
        
        let toastView4 = SwiftNotifyView.toastWith(text: "You are currently in Friendzone",
                                                theme: .warning(.light))
        
        let toastView4D = SwiftNotifyView.toastWith(text: "This should be the last toast in first queue",
                                                 theme: .warning(.dark))
        
        var toastViewConfig = SwiftNotify.Config()
        toastViewConfig.initPosition = .bottom(.random)
        toastViewConfig.appearPosition = .bottom
        toastViewConfig.thresholdDistance = 30
        toastViewConfig.hideTime = .never
        toastViewConfig.angularResistance = 1
        
        SwiftNotify.present(config: toastViewConfig, view: toastView)
        SwiftNotify.present(config: toastViewConfig, view: toastView2)
        SwiftNotify.present(config: toastViewConfig, view: toastView3)
        SwiftNotify.present(config: toastViewConfig, view: toastView4)
        
        SwiftNotify.present(config: toastViewConfig, view: toastViewD)
        SwiftNotify.present(config: toastViewConfig, view: toastView2D)
        SwiftNotify.present(config: toastViewConfig, view: toastView3D)
        SwiftNotify.present(config: toastViewConfig, view: toastView4D)
    }
    
    @IBAction func hideMessage() {
        SwiftNotify.hide()
    }
    
    @IBAction func hideAll() {
        SwiftNotify.hideAll()
    }

}
