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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showClassicView() {
        let classicView = SwiftNotifyView.classicWith(title: "Information",
                                                   body: "This is Classic View alert.",
                                                   theme: .info(.light))
        let classicViewD = SwiftNotifyView.classicWith(title: "Information",
                                                    body: "You can tap the message to hide it.",
                                                    theme: .info(.dark))
        
        let classicView2 = SwiftNotifyView.classicWith(title: "Success",
                                                    body: "Great. The message is shown successfully.",
                                                    theme: .success(.light))
        
        let classicView2D = SwiftNotifyView.classicWith(title: "Success",
                                                     body: "You can try to tap 'hide' button to hide this alert.",
                                                     theme: .success(.dark))
        
        let classicView3 = SwiftNotifyView.classicWith(title: "Error",
                                                    body: "Urh! 404 Girlfriend not found.",
                                                    theme: .fail(.light))
        
        let classicView3D = SwiftNotifyView.classicWith(title: "Error",
                                                     body: "You can try to tap 'hide all' button to hide all alerts in queue.",
                                                     theme: .fail(.dark))
        
        let classicView4 = SwiftNotifyView.classicWith(title: "Warning",
                                                    body: "You are currently in Friendzone",
                                                    theme: .warning(.light))
        
        let classicView4D = SwiftNotifyView.classicWith(title: "Warning",
                                                     body: "This should be the last one in first queue",
                                                     theme: .warning(.dark))
        
        var classicViewConfig = SwiftNotify.Config()
        classicViewConfig.initPosition = .top(.random)
        classicViewConfig.appearPosition = .top
        classicViewConfig.hideTime = .never
        classicViewConfig.snapDamping = 1.0
        
        
        SwiftNotify.present(config: classicViewConfig, view: classicView)
        SwiftNotify.present(config: classicViewConfig, view: classicView2)
        SwiftNotify.present(config: classicViewConfig, view: classicView3)
        SwiftNotify.present(config: classicViewConfig, view: classicView4)
        
        SwiftNotify.present(config: classicViewConfig, view: classicViewD)
        SwiftNotify.present(config: classicViewConfig, view: classicView2D)
        SwiftNotify.present(config: classicViewConfig, view: classicView3D)
        SwiftNotify.present(config: classicViewConfig, view: classicView4D)
    }
    
    @IBAction func hideMessage() {
        SwiftNotify.hide()
    }
    
    @IBAction func hideAll() {
        SwiftNotify.hideAll()
    }

}
