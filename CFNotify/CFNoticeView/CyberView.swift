//
//  TitleView.swift
//  CFNotify
//
//  Created by Johnny Choi on 22/11/2016.
//  Copyright © 2016 Johnny Choi@Co-Fire. All rights reserved.
//
import UIKit

open class CyberView: UIView {
    
    /**
     Get the width of message view
     */
    open var width: CGFloat {
        get {
            return self.bounds.width
        }
        set {
            self.bounds.width = newValue
            resizeToFit()
        }
    }
    
    /**
     Get the height of message view
     */
    open var height: CGFloat {
        get {
            return self.bounds.height
        }
        set {
            self.bounds.height = newValue
        }
    }
    
    /**
     Set the min. height of message view
     */
    open var minHeight: CGFloat = 70 {
        didSet {
            resizeToFit()
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
     Set the padding between each elements
     */
    open var paddingOffset: CGFloat = 10
    
    /**
     Get the instance of title label to take full control of it
     */
    open var titleLabel: BaseLabel!
    
    /**
     Set the title text & the height of message view will be calculated
     */
    open var titleText: String {
        didSet {
            titleLabel.text = titleText
            resizeToFit()
        }
    }
    
    /**
     Set title text font and font size & the height of message view will be calculated
     */
    open var titleTextFont: UIFont = .boldSystemFont(ofSize: 16) {
        didSet {
            titleLabel.font = titleTextFont
            resizeToFit()
        }
    }
    
    /**
     Set title text alignment
     */
    open var titleTextAlignment: NSTextAlignment = .left {
        didSet {
            titleLabel.textAlignment = titleTextAlignment
        }
    }
    
    /**
     Set title text color
     */
    open var titleTextColor: UIColor = .white {
        didSet {
            titleLabel.textColor = titleTextColor
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
    
    /**
     Get the instance of body label to take full control of it
     */
    open var bodyLabel: BaseLabel!
    
    /**
     Set the body text & the height of message view will be calculated
     */
    open var bodyText: String {
        didSet {
            bodyLabel.text = bodyText
            resizeToFit()
        }
    }
    
    /**
     Set title text font and font size & the height of message view will be calculated
     */
    open var bodyTextFont: UIFont = .systemFont(ofSize: 13, weight: UIFont.Weight.regular) {
        didSet {
            bodyLabel.font = bodyTextFont
            resizeToFit()
        }
    }
    
    /**
     Set title text alignment
     */
    open var bodyTextAlignment: NSTextAlignment = .left {
        didSet {
            bodyLabel.textAlignment = bodyTextAlignment
        }
    }
    
    /**
     Set title text color
     */
    open var bodyTextColor: UIColor = .white {
        didSet {
            bodyLabel.textColor = bodyTextColor
        }
    }
    
    /**
     Set title label background color
     */
    open var bodyBackgroundColor: UIColor = .clear {
        didSet {
            bodyLabel.backgroundColor = bodyBackgroundColor
        }
    }
    
    /**
     Get the instance of image view to take full control of it
     */
    open var imageView: BaseImageView!
    
    /**
     Set image view's width
     */
    open var imageViewWidth: CGFloat = 50 {
        didSet {
            imageView.bounds.width = imageViewWidth
            resizeToFit()
        }
    }
    
    /**
     Set image view's height
     */
    open var imageViewHeight: CGFloat = 50 {
        didSet {
            imageView.bounds.height = imageViewHeight
            resizeToFit()
        }
    }
    
    /**
     Set image view's content mode
     */
    open var imageViewContentMode: UIViewContentMode = .scaleAspectFill {
        didSet {
            imageView.contentMode = imageViewContentMode
        }
    }
    
    /**
     Set image view's corner radius
     */
    open var imageViewCornerRadus: CGFloat = 25 {
        didSet {
            imageView.layer.cornerRadius = imageViewCornerRadus
            imageView.clipsToBounds = true
        }
    }
    
    var blurEffect: UIBlurEffect
    var blurEffectView: UIVisualEffectView
    var vibrancyEffect: UIVibrancyEffect
    var vibrancyEffectView: UIVisualEffectView
    
    // MARK: - Initialization
    public init(title: String? = nil, body: String? = nil, image: UIImage? = nil, blurStyle: UIBlurEffectStyle) {
        blurEffect = UIBlurEffect(style: blurStyle)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        titleText = title ?? ""
        bodyText = body ?? ""
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width * 0.8, height: 0))
        self.backgroundColor = .black
        imageView = BaseImageView(frame: CGRect(paddingOffset, paddingOffset, imageViewWidth, imageViewHeight))
        titleLabel = BaseLabel(frame: CGRect(0, 0, 0, 0))
        bodyLabel = BaseLabel(frame: CGRect(imageView.frame.maxX + 10, 0 + titleLabel.bounds.height, self.width - imageView.bounds.width - 10, 0))
        //Image view init config
        let image = image?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.contentMode = imageViewContentMode
        imageView.layer.cornerRadius = imageViewCornerRadus
        imageView.clipsToBounds = true
        
        //Title label init config
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.text = titleText
        titleLabel.font = titleTextFont
        titleLabel.textAlignment = titleTextAlignment
        titleLabel.textColor = titleTextColor
        titleLabel.backgroundColor = titleBackgroundColor
        
        //Body label init config
        bodyLabel.numberOfLines = 0
        bodyLabel.lineBreakMode = .byWordWrapping
        bodyLabel.text = bodyText
        bodyLabel.font = bodyTextFont
        bodyLabel.textAlignment = bodyTextAlignment
        bodyLabel.textColor = bodyTextColor
        bodyLabel.backgroundColor = bodyBackgroundColor
        resizeToFit()
        
        imageView.isHidden = (imageView == nil)
        titleLabel.isHidden = (titleText == "")
        bodyLabel.isHidden = (bodyText == "")
        
        blurEffectView.frame = self.bounds
        self.addSubview(blurEffectView)
        
        vibrancyEffectView.frame = self.bounds
        vibrancyEffectView.contentView.addSubview(imageView)
        vibrancyEffectView.contentView.addSubview(titleLabel)
        vibrancyEffectView.contentView.addSubview(bodyLabel)
        blurEffectView.contentView.addSubview(vibrancyEffectView)
        
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        
        imageView.onDidSetHidden = { (isHidden) in
            self.resizeToFit()
        }
        
        titleLabel.onDidSetHidden = { (isHidden) in
            self.resizeToFit()
        }
        
        bodyLabel.onDidSetHidden = { (isHidden) in
            self.resizeToFit()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Set the width of message view & the height of message view will be calculated
     */
    func setWidth(width: CGFloat) {
        self.bounds.width = width
        resizeToFit()
    }
    
    /**
     Set the height of message view
     PS. It will override the calculated height by text length
     */
    func setHeight(height: CGFloat) {
        self.bounds.height = height
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
    
    func resizeToFit() {
        let imageViewWidth = imageView.isHidden ? 0 : imageView.bounds.width
        
        let titleLabelWidth = self.width - imageViewWidth - paddingOffset * (imageView.isHidden ? 2:3)
        let titleLabelHeight = titleLabel.isHidden ? 0 : heightForView(text: titleText, font: titleTextFont, width: titleLabelWidth)
        
        let bodyLabelWidth = self.width - imageViewWidth - paddingOffset * (imageView.isHidden ? 2:3)
        let bodyLabelHeight = bodyLabel.isHidden ? 0 : heightForView(text: bodyText, font: bodyTextFont, width: bodyLabelWidth)
        
        let totalHeight = titleLabelHeight + bodyLabelHeight + paddingOffset*3
        if totalHeight < (imageViewWidth + paddingOffset*2) {
            self.bounds.height = imageViewWidth + paddingOffset*2
        } else {
            self.bounds.height = totalHeight
        }
        
        let labelX: CGFloat
        if imageView.isHidden {
            labelX = paddingOffset
        } else {
            labelX = imageView.frame.maxX + paddingOffset
            imageView.center = CGPoint(x: imageView.bounds.midX + paddingOffset, y: self.bounds.midY)
        }
        
        if titleLabel.isHidden {
            bodyLabel.frame = CGRect(0, 0, bodyLabelWidth, bodyLabelHeight)
            bodyLabel.center = CGPoint(labelX + bodyLabel.bounds.midX, self.bounds.midY)
        } else if bodyLabel.isHidden {
            titleLabel.frame = CGRect(0, 0, titleLabelWidth, titleLabelHeight)
            titleLabel.center = CGPoint(labelX + titleLabel.bounds.midX, self.bounds.midY)
        } else {
            titleLabel.frame = CGRect(labelX, paddingOffset, titleLabelWidth, titleLabelHeight)
            bodyLabel.frame = CGRect(labelX, titleLabel.frame.maxY + paddingOffset, bodyLabelWidth, bodyLabelHeight)
        }
    }
}

