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
        let classicView = CFNotifyView.classicWith(title: "Infomation", body: "You can tap the message to hide it.", theme: .Info(.Light))
        let classicViewD = CFNotifyView.classicWith(title: "Infomation", body: "You can tap the message to hide it.", theme: .Info(.Dark))
        
        let classicView2 = CFNotifyView.classicWith(title: "Success", body: "Great. The message is shown successfully.", theme: .Success(.Light))
        let classicView2D = CFNotifyView.classicWith(title: "Success", body: "Great. The message is shown successfully.", theme: .Success(.Dark))
        
        let classicView3 = CFNotifyView.classicWith(title: "Error", body: "Urh! 404 Girlfriend not found.", theme: .Fail(.Light))
        let classicView3D = CFNotifyView.classicWith(title: "Error", body: "Urh! 404 Girlfriend not found.", theme: .Fail(.Dark))
        
        let classicView4 = CFNotifyView.classicWith(title: "Warning", body: "Once you go black, you never come back", theme: .Warning(.Light))
        let classicView4D = CFNotifyView.classicWith(title: "Warning", body: "Once you go black, you never come back", theme: .Warning(.Dark))
        
//        let customClassicView = CFNotifyView.classicWith(title: "Pembroke Welsh Corgi",
//                                                         titleFont: .italicSystemFont(ofSize: 16),
//                                                         titleColor: UIColor.black,
//                                                         body: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.",
//                                                         bodyFont: .systemFont(ofSize: 15),
//                                                         bodyColor: .brown,
//                                                         image: #imageLiteral(resourceName: "Dog2.jpg"),
//                                                         backgroundColor: .white)
//        customClassicView.layer.borderColor = UIColor.black.cgColor
//        customClassicView.layer.borderWidth = 1.0
//        customClassicView.imageView.layer.borderColor = UIColor.black.cgColor
//        customClassicView.imageView.layer.borderWidth = 1.0
        
        var classicViewConfig = CFNotify.Config()
        classicViewConfig.initPosition = .top(.random)
        classicViewConfig.appearPosition = .top
        classicViewConfig.hideTime = .never
        
//        CFNotify.present(config: classicViewConfig, view: customClassicView)
        
        CFNotify.present(config: classicViewConfig, view: classicView) {
            self.hideMessage()
        }
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
