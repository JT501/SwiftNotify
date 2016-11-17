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
        let view = SimpleView(text: "Testing Long Text: ABCDEFGHIJKLMNOPQRSTUVWXYZ")
//        view.width = 100
//        view.height = 100
        view.minHeight = 20
        view.cornerRadius = view.height / 2
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageView.image = #imageLiteral(resourceName: "Dog.jpg")
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        var config = CFMessage.Config()
        config.initPosition = .top(.random)
        config.thresholdDistance = 30
        config.dismissTime = .never
        config.tapToDismiss = true
        config.appearPosition = .top
        config.angularResistance = 1
        messenger.show(config: config, view: view)
        messenger.show(config: config, view: imageView)
        messenger.show(config: config, view: SimpleView(text: "TapHandler"), tapHandler: {
            let alertController = UIAlertController(title: "Tapped", message: "Message Tapped", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    @IBAction func dismissMessage() {
        messenger.dismiss()
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

