//
//  ViewController.swift
//  CFMessageExample
//
//  Created by Johnny on 9/11/2016.
//  Copyright © 2016 Johnny@Co-fire. All rights reserved.
//

import UIKit
import CFDraggableMessage

class ViewController: UIViewController, CFMessageDelegate {
    
    var messager = CFDraggableMessage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        messager.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CFMessageDelegate
    func cfMessageDidAppear() {
        print("Messgae is showing? \(messager.isShowing())")
    }
    
    func cfMessageIsDragging(atPoint: CGPoint) {
        print("Dragging at Point \(atPoint)")
    }
    
    func cfMessageDidTap() {
        print("Message is Tapped")
    }
    
    func cfMessageDidDismiss() {
        print("Message is Dismissed")
        print("Messgae is showing? \(messager.isShowing())")
    }
    
    @IBAction func showMessage() {
        messager.showMessage(withText: "hi")
    }
    
    @IBAction func dismissMessage() {
        messager.dismissMessage()
    }


}

