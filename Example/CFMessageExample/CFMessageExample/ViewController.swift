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
    
    var titleView = ClassicView(title: "", body: "", image: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        CFMessage.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CFMessageDelegate
    func cfMessageDidAppear() {
        print("Messgae is shown")
    }
    
    func cfMessageStartDragging(atPoint: CGPoint) {
        print("Start dragging")
    }
    
    public func cfMessageIsDragging(atPoint: CGPoint) {
        print("Is dragging at \(atPoint)")
    }
    
    func cfMessageEndDragging(atPoint: CGPoint) {
        print("End dragging")
    }
    
    func cfMessageDidDisappear() {
        print("Message removed from view")
    }
    
    public func cfMessageIsTapped() {
        print("Message is tapped")
    }
    
    func cfMessageDidDismiss() {
        print("Message is Dismissed")
//        print("Messgae is showing? \(messager.isShowing())")
    }
    
    @IBAction func showSimpleView() {
        let simpleView = CFDefaultView.toastWith(text: "Pembroke Welsh Corgi", theme: .Info(.Light))
        let simpleViewD = CFDefaultView.toastWith(text: "Pembroke Welsh Corgi", theme: .Info(.Dark))
        
        let simpleView2 = CFDefaultView.toastWith(text: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.", theme: .Success(.Light))
        let simpleView2D = CFDefaultView.toastWith(text: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.", theme: .Success(.Dark))
        
        let simpleView3 = CFDefaultView.toastWith(text: "Pembroke Welsh Corgi", theme: .Fail(.Light))
        let simpleView3D = CFDefaultView.toastWith(text: "Pembroke Welsh Corgi", theme: .Fail(.Dark))
        
        let simpleView4 = CFDefaultView.toastWith(text: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.", theme: .Warning(.Light))
        let simpleView4D = CFDefaultView.toastWith(text: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.", theme: .Warning(.Dark))
        
        var simpleViewConfig = CFMessage.Config()
        simpleViewConfig.initPosition = .bottom(.random)
        simpleViewConfig.appearPosition = .center
        simpleViewConfig.thresholdDistance = 30
        simpleViewConfig.dismissTime = .never
        simpleViewConfig.angularResistance = 1
        
        CFMessage.show(config: simpleViewConfig, view: simpleView)
        CFMessage.show(config: simpleViewConfig, view: simpleView2)
        CFMessage.show(config: simpleViewConfig, view: simpleView3)
        CFMessage.show(config: simpleViewConfig, view: simpleView4)
        
        CFMessage.show(config: simpleViewConfig, view: simpleViewD)
        CFMessage.show(config: simpleViewConfig, view: simpleView2D)
        CFMessage.show(config: simpleViewConfig, view: simpleView3D)
        CFMessage.show(config: simpleViewConfig, view: simpleView4D)
    }
    
    @IBAction func showClassicView() {
        let customClassicView = CFDefaultView.classicWith(title: "Pembroke Welsh Corgi",
                                                          titleFont: .italicSystemFont(ofSize: 17),
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
        
        let classicView = CFDefaultView.classicWith(title: "Infomation", body: "You can tap the message to dismiss it.", theme: .Info(.Light))
        let classicViewD = CFDefaultView.classicWith(title: "Infomation", body: "You can tap the message to dismiss it.", theme: .Info(.Dark))
        
        let classicView2 = CFDefaultView.classicWith(title: "Success", body: "Great. The message is shown successfully.", theme: .Success(.Light))
        let classicView2D = CFDefaultView.classicWith(title: "Success", body: "Great. The message is shown successfully.", theme: .Success(.Dark))
        
        let classicView3 = CFDefaultView.classicWith(title: "Error", body: "Urh! 404 Girlfriend not found.", theme: .Fail(.Light))
        let classicView3D = CFDefaultView.classicWith(title: "Error", body: "Urh! 404 Girlfriend not found.", theme: .Fail(.Dark))
        
        let classicView4 = CFDefaultView.classicWith(title: "Warning", body: "Once you go black, you never come back", theme: .Warning(.Light))
        let classicView4D = CFDefaultView.classicWith(title: "Warning", body: "Once you go black, you never come back", theme: .Warning(.Dark))
        
        var classicViewConfig = CFMessage.Config()
        classicViewConfig.initPosition = .top(.random)
        classicViewConfig.appearPosition = .top
        classicViewConfig.dismissTime = .never
        
        CFMessage.show(config: classicViewConfig, view: customClassicView)
        
        CFMessage.show(config: classicViewConfig, view: classicView)
        CFMessage.show(config: classicViewConfig, view: classicView2)
        CFMessage.show(config: classicViewConfig, view: classicView3)
        CFMessage.show(config: classicViewConfig, view: classicView4)
        
        CFMessage.show(config: classicViewConfig, view: classicViewD)
        CFMessage.show(config: classicViewConfig, view: classicView2D)
        CFMessage.show(config: classicViewConfig, view: classicView3D)
        CFMessage.show(config: classicViewConfig, view: classicView4D)
    }
    
    
    @IBAction func showMessage() {
        
        titleView = ClassicView(title: "Pembroke Welsh Corgi", body: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.", image: #imageLiteral(resourceName: "Dog.jpg"))
        titleView.width = self.view.bounds.width*0.9
        
        var titleViewConfig = CFMessage.Config()
        titleViewConfig.initPosition = .top(.random)
        titleViewConfig.appearPosition = .top
        titleViewConfig.thresholdDistance = 30
        titleViewConfig.dismissTime = .never
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageView.image = #imageLiteral(resourceName: "Dog.jpg")
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        var imageViewConfig = CFMessage.Config()
        imageViewConfig.initPosition = .top(.random)
        imageViewConfig.thresholdDistance = 999
        imageViewConfig.dismissTime = .never
        imageViewConfig.appearPosition = .center
        
        CFMessage.show(config: titleViewConfig, view: titleView)
        CFMessage.show(config: imageViewConfig, view: imageView)
//        CFMessage.show(config: simpleViewConfig, view: SimpleView(text: "TapHandler"), tapHandler: {
//            let alertController = UIAlertController(title: "Tapped", message: "Message Tapped", preferredStyle: .alert)
//            let alertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            alertController.addAction(alertAction)
//            self.present(alertController, animated: true, completion: nil)
//        })
    }
    
    @IBAction func dismissMessage() {
        CFMessage.dismiss()
    }
    
    @IBAction func dismissAll() {
        CFMessage.dismissAll()
    }
    
    @IBAction func test() {
        UIView.animate(withDuration: 0.5, animations: {
            self.titleView.imageView.image = #imageLiteral(resourceName: "Dog2.jpg")
            self.titleView.imageViewWidth = 70
            self.titleView.imageViewHeight = 70
            self.titleView.imageViewCornerRadus = 35
            self.titleView.titleText = "Shiba Inu"
            self.titleView.bodyText = "The Shiba Inu is the smallest of the six original and distinct spitz breeds of dog from Japan. A small, agile dog that copes very well with mountainous terrain, the Shiba Inu was originally bred for hunting."
        }, completion: { completed in
//            self.titleView.width = 200
        })
    }

    public func createMessageView(withText text: String) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 70))
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = UIColor.black

        let viewLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 70))
        viewLabel.text = text
        viewLabel.textAlignment = .center
        viewLabel.textColor = UIColor.white
        viewLabel.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2)
        view.addSubview(viewLabel)
        
        return view
    }

}

