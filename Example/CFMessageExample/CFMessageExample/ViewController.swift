//
//  ViewController.swift
//  CFMessageExample
//
//  Created by Johnny on 9/11/2016.
//  Copyright © 2016 Johnny@Co-fire. All rights reserved.
//

import UIKit
import CFNotify

class ViewController: UIViewController, CFNotifyDelegate {
    
    var titleView = ClassicView(title: "", body: "", image: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        CFNotify.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CFNotifyDelegate
    func cfNotifyDidAppear() {
        print("Messgae is shown")
    }
    
    func cfNotifyStartDragging(atPoint: CGPoint) {
        print("Start dragging")
    }
    
    public func cfNotifyIsDragging(atPoint: CGPoint) {
        print("Is dragging at \(atPoint)")
    }
    
    func cfNotifyEndDragging(atPoint: CGPoint) {
        print("End dragging")
    }
    
    func cfNotifyDidDisappear() {
        print("Message removed from view")
    }
    
    public func cfNotifyIsTapped() {
        print("Message is tapped")
    }
    
    func cfNotifyDidDismiss() {
        print("Message is Dismissed")
//        print("Messgae is showing? \(messager.isShowing())")
    }
    
    @IBAction func showCyberView() {
        let cyberView = CFNoticeView.cyberWith(title: "Pembroke Welsh Corgi",
                                                body: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.",
                                                theme: .Info(.Light))
        let cyberViewD = CFNoticeView.cyberWith(title: "Pembroke Welsh Corgi",
                                                body: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.",
                                                theme: .Info(.Dark))
        let cyberView2 = CFNoticeView.cyberWith(title: "Pembroke Welsh Corgi",
                                                body: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.",
                                                theme: .Success(.Light))
        let cyberView2D = CFNoticeView.cyberWith(title: "Pembroke Welsh Corgi",
                                                 body: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.",
                                                 theme: .Success(.Dark))
        let cyberView3 = CFNoticeView.cyberWith(title: "Pembroke Welsh Corgi",
                                                body: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.",
                                                theme: .Fail(.Light))
        let cyberView3D = CFNoticeView.cyberWith(title: "Pembroke Welsh Corgi",
                                                 body: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.",
                                                 theme: .Fail(.Dark))
        let cyberView4 = CFNoticeView.cyberWith(title: "Pembroke Welsh Corgi",
                                                body: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.",
                                                theme: .Warning(.Light))
        let cyberView4D = CFNoticeView.cyberWith(title: "Pembroke Welsh Corgi",
                                                 body: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.",
                                                 theme: .Warning(.Dark))
        
        var config = CFNotify.Config()
        config.dismissTime = .never
        
        CFNotify.show(config: config, view: cyberView)
        CFNotify.show(config: config, view: cyberViewD)
        CFNotify.show(config: config, view: cyberView2)
        CFNotify.show(config: config, view: cyberView2D)
        CFNotify.show(config: config, view: cyberView3)
        CFNotify.show(config: config, view: cyberView3D)
        CFNotify.show(config: config, view: cyberView4)
        CFNotify.show(config: config, view: cyberView4D)
    }
    
    @IBAction func showSimpleView() {
        
        let simpleView = CFNoticeView.toastWith(text: "Pembroke Welsh Corgi", theme: .Info(.Light))
        let simpleViewD = CFNoticeView.toastWith(text: "Pembroke Welsh Corgi", theme: .Info(.Dark))
        
        let simpleView2 = CFNoticeView.toastWith(text: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.", theme: .Success(.Light))
        let simpleView2D = CFNoticeView.toastWith(text: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.", theme: .Success(.Dark))
        
        let simpleView3 = CFNoticeView.toastWith(text: "Pembroke Welsh Corgi", theme: .Fail(.Light))
        let simpleView3D = CFNoticeView.toastWith(text: "Pembroke Welsh Corgi", theme: .Fail(.Dark))
        
        let simpleView4 = CFNoticeView.toastWith(text: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.", theme: .Warning(.Light))
        let simpleView4D = CFNoticeView.toastWith(text: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.", theme: .Warning(.Dark))
        
        var simpleViewConfig = CFNotify.Config()
        simpleViewConfig.initPosition = .bottom(.random)
        simpleViewConfig.appearPosition = .bottom
        simpleViewConfig.thresholdDistance = 30
        simpleViewConfig.dismissTime = .never
        simpleViewConfig.angularResistance = 1
        
        CFNotify.show(config: simpleViewConfig, view: simpleView)
        CFNotify.show(config: simpleViewConfig, view: simpleView2)
        CFNotify.show(config: simpleViewConfig, view: simpleView3)
        CFNotify.show(config: simpleViewConfig, view: simpleView4)
        
        CFNotify.show(config: simpleViewConfig, view: simpleViewD)
        CFNotify.show(config: simpleViewConfig, view: simpleView2D)
        CFNotify.show(config: simpleViewConfig, view: simpleView3D)
        CFNotify.show(config: simpleViewConfig, view: simpleView4D)
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

