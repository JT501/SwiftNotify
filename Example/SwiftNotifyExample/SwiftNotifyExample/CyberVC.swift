//
//  ViewController.swift
//  CFMessageExample
//
//  Created by Johnny on 9/11/2016.
//  Copyright © 2022 Johnny@Co-fire. All rights reserved.
//

import UIKit
import SwiftNotify

class CyberVC: UIViewController, SwiftNotifyDelegate {
    
    var titleView = ClassicView(title: "", body: "", image: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        SwiftNotify.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - SwiftNotifyDelegate
    func swiftNotifyDidAppear() {
        print("Messgae is shown")
    }
    
    func swiftNotifyStartDragging(atPoint: CGPoint) {
        print("Start dragging")
    }
    
    public func swiftNotifyIsDragging(atPoint: CGPoint) {
        print("Is dragging at \(atPoint)")
    }
    
    func swiftNotifyEndDragging(atPoint: CGPoint) {
        print("End dragging")
    }
    
    func swiftNotifyDidDisappear() {
        print("Message removed from view")
    }
    
    public func swiftNotifyIsTapped() {
        print("Message is tapped")
    }
    
    @IBAction func showCyberView() {
        let cyberView = SwiftNotifyView.cyberWith(title: "Info",
                                                body: "Try dragging this alert around !",
                                                theme: .info(.light))
        let cyberViewD = SwiftNotifyView.cyberWith(title: "Info",
                                                body: "You can tap this alert to hide it.",
                                                theme: .info(.dark))
        let cyberView2 = SwiftNotifyView.cyberWith(title: "Success",
                                                body: "You made alert more playable !",
                                                theme: .success(.light))
        let cyberView2D = SwiftNotifyView.cyberWith(title: "Success",
                                                 body: "You can try to tap 'hide' button to hide this alert.",
                                                 theme: .success(.dark))
        let cyberView3 = SwiftNotifyView.cyberWith(title: "Fail",
                                                body: "You can try to tap 'hide all' button to hide all alerts in queue.",
                                                theme: .fail(.light))
        let cyberView3D = SwiftNotifyView.cyberWith(title: "Fail",
                                                 body: "404 Girlfriend not found",
                                                 theme: .fail(.dark))
        let cyberView4 = SwiftNotifyView.cyberWith(title: "Warning",
                                                body: "You are currently in Friendzone",
                                                theme: .warning(.light))
        let cyberView4D = SwiftNotifyView.cyberWith(title: "Warning",
                                                 body: "This should be the last one in first queue",
                                                 theme: .warning(.dark))
        
        var config = SwiftNotify.Config()
        config.hideTime = .default
        
        SwiftNotify.present(config: config, view: cyberView)
        SwiftNotify.present(config: config, view: cyberViewD)
        SwiftNotify.present(config: config, view: cyberView2)
        SwiftNotify.present(config: config, view: cyberView2D)
        SwiftNotify.present(config: config, view: cyberView3)
        SwiftNotify.present(config: config, view: cyberView3D)
        SwiftNotify.present(config: config, view: cyberView4)
        SwiftNotify.present(config: config, view: cyberView4D)
    }
    
    @IBAction func hideMessage() {
        SwiftNotify.hide()
    }
    
    @IBAction func hideAll() {
        SwiftNotify.hideAll()
    }
}

