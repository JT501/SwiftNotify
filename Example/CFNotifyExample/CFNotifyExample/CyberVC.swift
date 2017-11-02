//
//  ViewController.swift
//  CFMessageExample
//
//  Created by Johnny on 9/11/2016.
//  Copyright © 2016 Johnny@Co-fire. All rights reserved.
//

import UIKit
import CFNotify

class CyberVC: UIViewController, CFNotifyDelegate {
    
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
    
    @IBAction func showCyberView() {
        let cyberView = CFNotifyView.cyberWith(title: "Info",
                                                body: "Try dragging this alert around !",
                                                theme: .info(.light))
        let cyberViewD = CFNotifyView.cyberWith(title: "Info",
                                                body: "You can tap this alert to hide it.",
                                                theme: .info(.dark))
        let cyberView2 = CFNotifyView.cyberWith(title: "Success",
                                                body: "You made alert more playable !",
                                                theme: .success(.light))
        let cyberView2D = CFNotifyView.cyberWith(title: "Success",
                                                 body: "You can try to tap 'hide' button to hide this alert.",
                                                 theme: .success(.dark))
        let cyberView3 = CFNotifyView.cyberWith(title: "Fail",
                                                body: "You can try to tap 'hide all' button to hide all alerts in queue.",
                                                theme: .fail(.light))
        let cyberView3D = CFNotifyView.cyberWith(title: "Fail",
                                                 body: "404 Girlfriend not found",
                                                 theme: .fail(.dark))
        let cyberView4 = CFNotifyView.cyberWith(title: "Warning",
                                                body: "You are currently in Friendzone",
                                                theme: .warning(.light))
        let cyberView4D = CFNotifyView.cyberWith(title: "Warning",
                                                 body: "This should be the last one in first queue",
                                                 theme: .warning(.dark))
        
        var config = CFNotify.Config()
        config.hideTime = .never
        
        CFNotify.present(config: config, view: cyberView)
        CFNotify.present(config: config, view: cyberViewD)
        CFNotify.present(config: config, view: cyberView2)
        CFNotify.present(config: config, view: cyberView2D)
        CFNotify.present(config: config, view: cyberView3)
        CFNotify.present(config: config, view: cyberView3D)
        CFNotify.present(config: config, view: cyberView4)
        CFNotify.present(config: config, view: cyberView4D)
    }
    
    @IBAction func hideMessage() {
        CFNotify.hide()
    }
    
    @IBAction func hideAll() {
        CFNotify.hideAll()
    }
}

