//
//  ClassicVC.swift
//  CFNotifyExample
//
//  Created by Johnny Choi on 25/11/2016.
//  Copyright © 2016 Johnny@Co-fire. All rights reserved.
//

import UIKit
import CFNotify

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
        let classicView = CFNotifyView.classicWith(title: "Information",
                                                   body: "This is Classic View alert.",
                                                   theme: .info(.light))
        let classicViewD = CFNotifyView.classicWith(title: "Information",
                                                    body: "You can tap the message to hide it.",
                                                    theme: .info(.dark))
        
        let classicView2 = CFNotifyView.classicWith(title: "Success",
                                                    body: "Great. The message is shown successfully.",
                                                    theme: .success(.light))
        
        let classicView2D = CFNotifyView.classicWith(title: "Success",
                                                     body: "You can try to tap 'hide' button to hide this alert.",
                                                     theme: .success(.dark))
        
        let classicView3 = CFNotifyView.classicWith(title: "Error",
                                                    body: "Urh! 404 Girlfriend not found.",
                                                    theme: .fail(.light))
        
        let classicView3D = CFNotifyView.classicWith(title: "Error",
                                                     body: "You can try to tap 'hide all' button to hide all alerts in queue.",
                                                     theme: .fail(.dark))
        
        let classicView4 = CFNotifyView.classicWith(title: "Warning",
                                                    body: "You are currently in Friendzone",
                                                    theme: .warning(.light))
        
        let classicView4D = CFNotifyView.classicWith(title: "Warning",
                                                     body: "This should be the last one in first queue",
                                                     theme: .warning(.dark))
        
        var classicViewConfig = CFNotify.Config()
        classicViewConfig.initPosition = .top(.random)
        classicViewConfig.appearPosition = .top
        classicViewConfig.hideTime = .never
        
        CFNotify.present(config: classicViewConfig, view: classicView)
        CFNotify.present(config: classicViewConfig, view: classicView2)
        CFNotify.present(config: classicViewConfig, view: classicView3)
        CFNotify.present(config: classicViewConfig, view: classicView4)
        
        CFNotify.present(config: classicViewConfig, view: classicViewD)
        CFNotify.present(config: classicViewConfig, view: classicView2D)
        CFNotify.present(config: classicViewConfig, view: classicView3D)
        CFNotify.present(config: classicViewConfig, view: classicView4D)
    }
    
    @IBAction func hideMessage() {
        CFNotify.hide()
    }
    
    @IBAction func hideAll() {
        CFNotify.hideAll()
    }

}
