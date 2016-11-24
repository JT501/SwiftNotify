//
//  CFMessageView.swift
//  CFNotify
//
//  Created by Johnny Choi on 10/11/2016.
//  Copyright © 2016 Johnny Choi@Co-Fire. All rights reserved.
//
import UIKit

open class ToastView: UIView {
    
    /**
    Get & set the width of message view
    */
    open var width: CGFloat {
        get {
            return self.bounds.width
        }
        set {
            self.bounds.width = newValue
            textLabel.bounds.width = newValue * 0.9
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
            textLabel.center = CGPoint(self.width/2, newValue/2)
        }
    }
    
    /**
    Set the max. width of message view
    */
    open var maxWidth: CGFloat = UIScreen.main.bounds.size.width * 0.8 {
        didSet {
            resizeToFitText()
        }
    }
    
    /**
    Set the min. height of message view
    */
    open var minHeight: CGFloat = 50 {
        didSet {
            resizeToFitText()
        }
    }
    
    /**
     Set the padding between each elements
     */
    open var paddingOffset: CGFloat = 10
    
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
    open var textLabel: UILabel!
    
    /**
    Set the title text & the height of message view will be calculated
    */
    open var text: String {
        didSet {
            textLabel.text = text
            resizeToFitText()
        }
    }
    
    /**
    Set title text font and font size & the height of message view will be calculated
    */
    open var textFont: UIFont = .boldSystemFont(ofSize: 17) {
        didSet {
            textLabel.font = textFont
            resizeToFitText()
        }
    }
    
    /** 
    Set title text alignment
     */
    open var textAlignment: NSTextAlignment = .center {
        didSet {
            textLabel.textAlignment = textAlignment
        }
    }
    
    /**
    Set title text color
    */
    open var textColor: UIColor = .white {
        didSet {
            textLabel.textColor = textColor
        }
    }
    
    /**
    Set title label background color
    */
    open var titleBackgroundColor: UIColor = .clear {
        didSet {
            textLabel.backgroundColor = titleBackgroundColor
        }
    }
    
    // MARK: - Initialization
    public init(text: String) {
        self.text = text
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width * 0.8, height: 0))
        self.backgroundColor = .black
        textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width*0.9, height: 0))
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.text = text
        textLabel.font = textFont
        textLabel.textAlignment = textAlignment
        textLabel.textColor = textColor
        textLabel.backgroundColor = titleBackgroundColor
        resizeToFitText()
        self.addSubview(textLabel)
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
        textLabel.center = self.center
    }
    
    // MARK: - Convenience functions
    func sizeForView(text:String, font:UIFont, width:CGFloat? = nil) -> CGRect{
        let _width: CGFloat
        if width != nil {
            _width = width!
        } else {
            _width = CGFloat.greatestFiniteMagnitude
        }
        let label:UILabel = UILabel(frame: CGRect(0, 0, _width, CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.bounds
    }
    
    func resizeToFitText() {
        var labelBounds = sizeForView(text: text, font: textFont)
        var viewWidth = labelBounds.width + paddingOffset * 2
        var viewHeight = labelBounds.height + paddingOffset * 2
        
        if viewWidth > maxWidth {
            labelBounds = sizeForView(text: text, font: textFont, width: maxWidth - paddingOffset * 2)
            viewWidth = labelBounds.width + paddingOffset * 2
            viewHeight = labelBounds.height + paddingOffset * 2
        }
        
        textLabel.bounds = labelBounds
        self.bounds.width = viewWidth
        self.bounds.height = viewHeight
        textLabel.center = self.bounds.center
    }
}
