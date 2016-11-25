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
        let customClassicView = CFNoticeView.classicWith(title: "Pembroke Welsh Corgi",
                                                         titleFont: .italicSystemFont(ofSize: 16),
                                                         titleColor: UIColor.black,
                                                         body: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.",
                                                         bodyFont: .systemFont(ofSize: 15),
                                                         bodyColor: .brown,
                                                         image: #imageLiteral(resourceName: "Dog2.jpg"),
                                                         backgroundColor: .white)
        customClassicView.layer.borderColor = UIColor.black.cgColor
        customClassicView.layer.borderWidth = 1.0
        customClassicView.imageView.layer.borderColor = UIColor.black.cgColor
        customClassicView.imageView.layer.borderWidth = 1.0
        
        let classicView = CFNoticeView.classicWith(title: "Infomation", body: "You can tap the message to dismiss it.", theme: .Info(.Light))
        let classicViewD = CFNoticeView.classicWith(title: "Infomation", body: "You can tap the message to dismiss it.", theme: .Info(.Dark))
        
        let classicView2 = CFNoticeView.classicWith(title: "Success", body: "Great. The message is shown successfully.", theme: .Success(.Light))
        let classicView2D = CFNoticeView.classicWith(title: "Success", body: "Great. The message is shown successfully.", theme: .Success(.Dark))
        
        let classicView3 = CFNoticeView.classicWith(title: "Error", body: "Urh! 404 Girlfriend not found.", theme: .Fail(.Light))
        let classicView3D = CFNoticeView.classicWith(title: "Error", body: "Urh! 404 Girlfriend not found.", theme: .Fail(.Dark))
        
        let classicView4 = CFNoticeView.classicWith(title: "Warning", body: "Once you go black, you never come back", theme: .Warning(.Light))
        let classicView4D = CFNoticeView.classicWith(title: "Warning", body: "Once you go black, you never come back", theme: .Warning(.Dark))
        
        var classicViewConfig = CFNotify.Config()
        classicViewConfig.initPosition = .top(.random)
        classicViewConfig.appearPosition = .top
        classicViewConfig.dismissTime = .never
        
        CFNotify.show(config: classicViewConfig, view: customClassicView)
        
        CFNotify.show(config: classicViewConfig, view: classicView)
        CFNotify.show(config: classicViewConfig, view: classicView2)
        CFNotify.show(config: classicViewConfig, view: classicView3)
        CFNotify.show(config: classicViewConfig, view: classicView4)
        
        CFNotify.show(config: classicViewConfig, view: classicViewD)
        CFNotify.show(config: classicViewConfig, view: classicView2D)
        CFNotify.show(config: classicViewConfig, view: classicView3D)
        CFNotify.show(config: classicViewConfig, view: classicView4D)
    }
    
    @IBAction func dismissMessage() {
        CFNotify.dismiss()
    }
    
    @IBAction func dismissAll() {
        CFNotify.dismissAll()
    }

}
