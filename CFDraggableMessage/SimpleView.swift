//
//  CFMessageView.swift
//  CFDraggableMessage
//
//  Created by Johnny Choi on 10/11/2016.
//  Copyright © 2016 Johnny Choi@Co-Fire. All rights reserved.
//
import UIKit

open class SimpleView: UIView {
    
    /**
    Get & set the width of message view
    */
    open var width: CGFloat {
        get {
            return self.bounds.width
        }
        set {
            self.bounds.width = newValue
            titleLabel.bounds.width = newValue * 0.9
            resizeToFitText()
        }
    }
    
    /**
    Get & set the height of message view
    - PS. 
     It will override the height calculated by text length
    */
    open var height: CGFloat {
        get {
            return self.bounds.height
        }
        set {
            self.bounds.height = newValue
            titleLabel.center = CGPoint(self.width/2, newValue/2)
        }
    }
    
    /**
    Set the min. height of message view
    */
    open var minHeight: CGFloat = 30 {
        didSet {
            resizeToFitText()
        }
    }
    
    /**
    Set the corner radius of message view
    */
    open var cornerRadius: CGFloat = 10 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
    
    /**
    Get the instance of title label to take full control of it
    */
    open var titleLabel: UILabel!
    
    /**
    Set the title text & the height of message view will be calculated
    */
    open var titleText: String {
        didSet {
            titleLabel.text = titleText
            resizeToFitText()
        }
    }
    
    /**
    Set title text font and font size & the height of message view will be calculated
    */
    open var titleTextFont: UIFont = .systemFont(ofSize: 14) {
        didSet {
            titleLabel.font = titleTextFont
            resizeToFitText()
        }
    }
    
    /** 
    Set title text alignment
     */
    open var textAlignment: NSTextAlignment = .center {
        didSet {
            titleLabel.textAlignment = textAlignment
        }
    }
    
    /**
    Set title text color
    */
    open var textColor: UIColor = .white {
        didSet {
            titleLabel.textColor = textColor
        }
    }
    
    /**
    Set title label background color
    */
    open var titleBackgroundColor: UIColor = .clear {
        didSet {
            titleLabel.backgroundColor = titleBackgroundColor
        }
    }
    
    // MARK: - Initialization
    public init(text: String) {
        titleText = text
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width * 0.8, height: 0))
        self.backgroundColor = .black
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width*0.9, height: 0))
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.text = titleText
        titleLabel.font = titleTextFont
        titleLabel.textAlignment = textAlignment
        titleLabel.textColor = textColor
        titleLabel.backgroundColor = titleBackgroundColor
        resizeToFitText()
        self.addSubview(titleLabel)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
    Set the width of message view & the height of message view will be calculated
     */
    func setWidth(width: CGFloat) {
        self.bounds.width = width
        resizeToFitText()
    }
    
    /**
    Set the height of message view
    PS. It will override the calculated height by text length
     */
    func setHeight(height: CGFloat) {
        self.bounds.height = height
        titleLabel.center = self.center
    }
    
    // MARK: - Convenience functions
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(0, 0, width, CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    func resizeToFitText() {
        titleLabel.bounds.height = heightForView(text: titleText, font: titleTextFont, width: self.bounds.width*0.9)
        self.bounds.height = ((titleLabel.bounds.height / 0.8) < minHeight) ? minHeight : (titleLabel.bounds.height / 0.7)
        titleLabel.center = self.bounds.center
    }
}
