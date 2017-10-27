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
        let cyberView = CFNotifyView.cyberWith(title: "Pembroke Welsh Corgi",
                                                body: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.",
                                                theme: .Info(.Light))
        let cyberViewD = CFNotifyView.cyberWith(title: "Pembroke Welsh Corgi",
                                                body: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.",
                                                theme: .Info(.Dark))
        let cyberView2 = CFNotifyView.cyberWith(title: "Pembroke Welsh Corgi",
                                                body: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.",
                                                theme: .Success(.Light))
        let cyberView2D = CFNotifyView.cyberWith(title: "Pembroke Welsh Corgi",
                                                 body: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.",
                                                 theme: .Success(.Dark))
        let cyberView3 = CFNotifyView.cyberWith(title: "Pembroke Welsh Corgi",
                                                body: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.",
                                                theme: .Fail(.Light))
        let cyberView3D = CFNotifyView.cyberWith(title: "Pembroke Welsh Corgi",
                                                 body: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.",
                                                 theme: .Fail(.Dark))
        let cyberView4 = CFNotifyView.cyberWith(title: "Pembroke Welsh Corgi",
                                                body: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.",
                                                theme: .Warning(.Light))
        let cyberView4D = CFNotifyView.cyberWith(title: "Pembroke Welsh Corgi",
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
    
    @IBAction func dismissMessage() {
        CFNotify.dismiss()
    }
    
    @IBAction func dismissAll() {
        CFNotify.dismissAll()
    }
}

