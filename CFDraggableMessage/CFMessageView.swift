//
//  CFMessageView.swift
//  CFDraggableMessage
//
//  Created by Johnny Choi on 10/11/2016.
//  Copyright © 2016 Johnny Choi@Co-Fire. All rights reserved.
//
import UIKit

open class CFMessageView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    open var width: CGFloat = UIScreen.main.bounds.size.width * 0.8
    open var height: CGFloat = 50
    open var bodyLabel: UILabel!
    open var textAlignment: NSTextAlignment = .center
    
    
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        bodyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width*0.8, height: height*0.8))
        bodyLabel.center = self.center
        bodyLabel.textAlignment = textAlignment
        bodyLabel.textColor = UIColor.white
        self.addSubview(bodyLabel)
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
        self.backgroundColor = UIColor.black
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setBodyText(text: String) {
        bodyLabel?.text = text
    }

}
