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
    
    var messenger = CFMessage()
    var titleView = TitleView(title: "", body: "", image: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        messager.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CFMessageDelegate
    func cfMessageDidAppear() {
        print("Messgae is shown")
    }
    
    func cfMessageIsDragging(atPoint: CGPoint) {
        print("Dragging at Point \(atPoint)")
    }
    
    func cfMessageDidTap() {
        print("Message is Tapped")
    }
    
    func cfMessageDidDismiss() {
        print("Message is Dismissed")
//        print("Messgae is showing? \(messager.isShowing())")
    }
    
    @IBAction func showMessage() {
        titleView = TitleView(title: "Pembroke Welsh Corgi", body: "The Pembroke Welsh Corgi is a cattle herding dog breed which originated in Pembrokeshire, Wales. It is one of two breeds known as a Welsh Corgi.", image: #imageLiteral(resourceName: "Dog.jpg"))
        titleView.width = self.view.bounds.width*0.9
        
        var titleViewConfig = CFMessage.Config()
        titleViewConfig.initPosition = .top(.random)
        titleViewConfig.appearPosition = .top
        titleViewConfig.thresholdDistance = 30
        titleViewConfig.dismissTime = .never
        
        let simpleView = CFDefaultView.createSimpleView(text: "Testing Long Text: ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        simpleView.backgroundColor = UIColor.red
//        simpleView.width = 100
//        simpleView.height = 100
        simpleView.minHeight = 30
        simpleView.cornerRadius = simpleView.height / 2
        
        var simpleViewConfig = CFMessage.Config()
        simpleViewConfig.initPosition = .bottom(.random)
        simpleViewConfig.appearPosition = .bottom
        simpleViewConfig.thresholdDistance = 30
        simpleViewConfig.dismissTime = .never
        simpleViewConfig.angularResistance = 1
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageView.image = #imageLiteral(resourceName: "Dog.jpg")
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        var imageViewConfig = CFMessage.Config()
        imageViewConfig.initPosition = .top(.random)
        imageViewConfig.thresholdDistance = 999
        imageViewConfig.dismissTime = .never
        imageViewConfig.tapToDismiss = true
        imageViewConfig.appearPosition = .center
        
        messenger.show(config: titleViewConfig, view: titleView)
        messenger.show(config: simpleViewConfig, view: simpleView)
        messenger.show(config: imageViewConfig, view: imageView)
        messenger.show(config: simpleViewConfig, view: SimpleView(text: "TapHandler"), tapHandler: {
            let alertController = UIAlertController(title: "Tapped", message: "Message Tapped", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    @IBAction func dismissMessage() {
        messenger.dismiss()
    }
    
    @IBAction func dismissAll() {
        messenger.dismissAll()
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
            self.titleView.width = 200
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

