//
//  ToastVC.swift
//  CFNotifyExample
//
//  Created by Johnny Choi on 25/11/2016.
//  Copyright © 2016 Johnny@Co-fire. All rights reserved.
//

import UIKit
import CFNotify

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
        
        let toastView = CFNotifyView.toastWith(text: "Pembroke Welsh Corgi", theme: .Info(.Light))
        let toastViewD = CFNotifyView.toastWith(text: "Pembroke Welsh Corgi", theme: .Info(.Dark))
        
        let toastView2 = CFNotifyView.toastWith(text: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.", theme: .Success(.Light))
        let toastView2D = CFNotifyView.toastWith(text: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.", theme: .Success(.Dark))
        
        let toastView3 = CFNotifyView.toastWith(text: "Pembroke Welsh Corgi", theme: .Fail(.Light))
        let toastView3D = CFNotifyView.toastWith(text: "Pembroke Welsh Corgi", theme: .Fail(.Dark))
        
        let toastView4 = CFNotifyView.toastWith(text: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.", theme: .Warning(.Light))
        let toastView4D = CFNotifyView.toastWith(text: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.", theme: .Warning(.Dark))
        
        var toastViewConfig = CFNotify.Config()
        toastViewConfig.initPosition = .bottom(.random)
        toastViewConfig.appearPosition = .bottom
        toastViewConfig.thresholdDistance = 30
        toastViewConfig.dismissTime = .never
        toastViewConfig.angularResistance = 1
        
        CFNotify.show(config: toastViewConfig, view: toastView)
        CFNotify.show(config: toastViewConfig, view: toastView2)
        CFNotify.show(config: toastViewConfig, view: toastView3)
        CFNotify.show(config: toastViewConfig, view: toastView4)
        
        CFNotify.show(config: toastViewConfig, view: toastViewD)
        CFNotify.show(config: toastViewConfig, view: toastView2D)
        CFNotify.show(config: toastViewConfig, view: toastView3D)
        CFNotify.show(config: toastViewConfig, view: toastView4D)
    }
    
    @IBAction func dismissMessage() {
        CFNotify.dismiss()
    }
    
    @IBAction func dismissAll() {
        CFNotify.dismissAll()
    }

}
