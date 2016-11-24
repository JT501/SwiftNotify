//
//  CFDefaultView.swift
//  CFNotify
//
//  Created by Johnny Choi on 18/11/2016.
//  Copyright © 2016 Johnny Choi@Co-Fire. All rights reserved.
//

import UIKit

open class CFNoticeView: NSObject {
    
    /**
    Theme enum
    */
    public enum Theme {
        case Success(Style)
        case Fail(Style)
        case Info(Style)
        case Warning(Style)
    }
    
    /**
    Style enum
    */
    public enum Style {
        case Light
        case Dark
    }
}

extension CFNoticeView {
    
    public static func toastWith(text: String, theme: Theme) -> ToastView {
        
        let view = ToastView(text: text)
        setToastThemeFor(view: view, theme: theme)
        
        return view
    }
    
    public static func toastWith(text: String, textFont: UIFont, textColor: UIColor, backgroundColor: UIColor) -> ToastView {
        
        let view = ToastView(text: text)
        view.textFont = textFont
        view.textColor = textColor
        view.backgroundColor = backgroundColor
        
        return view
    }
    
    /**
    Convenience API to create classic view
    */
    public static func classicWith(title: String, body: String, theme: Theme) -> ClassicView {
        
        let view = ClassicView(title: title, body: body)
        setClassicThemeFor(view: view, theme: theme)
        
        return view
    }
    
    /**
    Convenience API to create classic view with more customization options
    */
    public static func classicWith(title: String? = nil, titleFont: UIFont, titleColor: UIColor, body: String? = nil, bodyFont: UIFont, bodyColor: UIColor, image: UIImage? = nil, backgroundColor: UIColor) -> ClassicView {
        
        let view = ClassicView(title: title, body: body, image: image)
        view.titleTextFont = titleFont
        view.titleTextColor = titleColor
        view.bodyTextFont = bodyFont
        view.bodyTextColor = bodyColor
        view.imageView.isHidden = (image == nil)
        view.backgroundColor = backgroundColor
        
        return view
    }
    
    public static func cyberWith(title: String, body: String, theme: Theme) -> CyberView {
        
        let view = CyberView(title: title, body: body, blurStyle: .extraLight)
        setCyberThemeFor(view: view, theme: theme)
        
        return view
    }
    
    public static func cyberWith(title: String? = nil, titleFont: UIFont, titleColor: UIColor, body: String? = nil, bodyFont: UIFont, bodyColor: UIColor, image: UIImage? = nil, backgroundColor: UIColor, blurStyle: UIBlurEffectStyle) -> CyberView {
        
        let view = CyberView(title: title, body: body, image: image, blurStyle: blurStyle)
        view.titleTextFont = titleFont
        view.titleTextColor = titleColor
        view.bodyTextFont = bodyFont
        view.bodyTextColor = bodyColor
        view.imageView.isHidden = (image == nil)
        view.backgroundColor = backgroundColor
        
        return view
    }
}

extension CFNoticeView {
    
    static func setToastThemeFor(view: ToastView, theme: Theme) {
        switch theme {
        case .Success(let style):
            switch style {
            case .Light:
                view.backgroundColor = UIColor(red: 65.0/256.0, green: 131.0/256.0, blue: 215.0/256.0, alpha: 1.0)
                view.textColor = UIColor.white
            case .Dark:
                view.backgroundColor = UIColor(red: 31.0/256.0, green: 58.0/256.0, blue: 147.0/256.0, alpha: 1.0)
                view.textColor = UIColor.white
            }
        case .Fail(let style):
            switch style {
            case .Light:
                view.backgroundColor = UIColor(red: 231.0/256.0, green: 76.0/256.0, blue: 60.0/256.0, alpha: 1.0)
                view.textColor = UIColor.white
            case .Dark:
                view.backgroundColor = UIColor(red: 185.0/256.0, green: 29.0/256.0, blue: 71.0/256.0, alpha: 1.0)
                view.textColor = UIColor.white
            }
        case .Info(let style):
            switch style {
            case .Light:
                view.backgroundColor = UIColor(red: 191.0/256.0, green: 191.0/256.0, blue: 191.0/256.0, alpha: 1.0)
                view.textColor = UIColor.white
            case .Dark:
                view.backgroundColor = UIColor(red: 29.0/256.0, green: 29.0/256.0, blue: 29.0/256.0, alpha: 1.0)
                view.textColor = UIColor.white
            }
        case .Warning(let style):
            switch style {
            case .Light:
                view.backgroundColor = UIColor(red: 245.0/256.0, green: 171.0/256.0, blue: 53.0/256.0, alpha: 1.0)
                view.textColor = UIColor.white
            case .Dark:
                view.backgroundColor = UIColor(red: 218.0/256.0, green: 83.0/256.0, blue: 44.0/256.0, alpha: 1.0)
                view.textColor = UIColor.white
            }
        }
    }
    
    static func setClassicThemeFor(view: ClassicView, theme: Theme) {
        switch theme {
        case .Success(let style):
            switch style {
            case .Light:
                view.backgroundColor = UIColor(red: 65.0/256.0, green: 131.0/256.0, blue: 215.0/256.0, alpha: 1.0)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "CFResources.bundle/icon_success")?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
                view.imageView.tintColor = UIColor.white
            case .Dark:
                view.backgroundColor = UIColor(red: 31.0/256.0, green: 58.0/256.0, blue: 147.0/256.0, alpha: 1.0)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "CFResources.bundle/icon_success_dark")?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
                view.imageView.tintColor = UIColor.white
            }
        case .Fail(let style):
            switch style {
            case .Light:
                view.backgroundColor = UIColor(red: 231.0/256.0, green: 76.0/256.0, blue: 60.0/256.0, alpha: 1.0)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "CFResources.bundle/icon_fail")?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
                view.imageView.tintColor = UIColor.white
            case .Dark:
                view.backgroundColor = UIColor(red: 185.0/256.0, green: 29.0/256.0, blue: 71.0/256.0, alpha: 1.0)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "CFResources.bundle/icon_fail_dark")?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
                view.imageView.tintColor = UIColor.white
            }
        case .Info(let style):
            switch style {
            case .Light:
                view.backgroundColor = UIColor(red: 191.0/256.0, green: 191.0/256.0, blue: 191.0/256.0, alpha: 1.0)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "CFResources.bundle/icon_info")?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
                view.imageView.tintColor = UIColor.white
            case .Dark:
                view.backgroundColor = UIColor(red: 29.0/256.0, green: 29.0/256.0, blue: 29.0/256.0, alpha: 1.0)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "CFResources.bundle/icon_info_dark")?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
                view.imageView.tintColor = UIColor.white
            }
        case .Warning(let style):
            switch style {
            case .Light:
                view.backgroundColor = UIColor(red: 245.0/256.0, green: 171.0/256.0, blue: 53.0/256.0, alpha: 1.0)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "CFResources.bundle/icon_warning")?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
                view.imageView.tintColor = UIColor.white
            case .Dark:
                view.backgroundColor = UIColor(red: 218.0/256.0, green: 83.0/256.0, blue: 44.0/256.0, alpha: 1.0)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "CFResources.bundle/icon_warning_dark")?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
                view.imageView.tintColor = UIColor.white
            }
        }
    }
    
    static func setCyberThemeFor(view: CyberView, theme: Theme) {
        switch theme {
        case .Success(let style):
            switch style {
            case .Light:
                view.backgroundColor = UIColor(red: 65.0/256.0, green: 131.0/256.0, blue: 215.0/256.0, alpha: 0.5)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "CFResources.bundle/icon_success")?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
            case .Dark:
                view.backgroundColor = UIColor(red: 31.0/256.0, green: 58.0/256.0, blue: 147.0/256.0, alpha: 0.5)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "CFResources.bundle/icon_success_dark")?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
            }
        case .Fail(let style):
            switch style {
            case .Light:
                view.backgroundColor = UIColor(red: 231.0/256.0, green: 76.0/256.0, blue: 60.0/256.0, alpha: 0.5)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "CFResources.bundle/icon_fail")?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
            case .Dark:
                view.backgroundColor = UIColor(red: 185.0/256.0, green: 29.0/256.0, blue: 71.0/256.0, alpha: 0.5)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "CFResources.bundle/icon_fail_dark")?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
            }
        case .Info(let style):
            switch style {
            case .Light:
                view.backgroundColor = UIColor(red: 191.0/256.0, green: 191.0/256.0, blue: 191.0/256.0, alpha: 0.5)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "CFResources.bundle/icon_info")?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
            case .Dark:
                view.backgroundColor = UIColor(red: 29.0/256.0, green: 29.0/256.0, blue: 29.0/256.0, alpha: 0.5)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "CFResources.bundle/icon_info_dark")?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
            }
        case .Warning(let style):
            switch style {
            case .Light:
                view.backgroundColor = UIColor(red: 245.0/256.0, green: 171.0/256.0, blue: 53.0/256.0, alpha: 0.5)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "CFResources.bundle/icon_warning")?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
            case .Dark:
                view.backgroundColor = UIColor(red: 218.0/256.0, green: 83.0/256.0, blue: 44.0/256.0, alpha: 0.5)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "CFResources.bundle/icon_warning_dark")?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
                view.imageView.tintColor = UIColor.white
            }
        }
    }
    
}
