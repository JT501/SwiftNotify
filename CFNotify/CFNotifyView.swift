//
//  CFDefaultView.swift
//  CFNotify
//
//  Created by Johnny Choi on 18/11/2016.
//  Copyright © 2016 Johnny Choi@Co-Fire. All rights reserved.
//

import UIKit

open class CFNotifyView: NSObject {
    
    /**
    Theme enum
    */
    public enum Theme {
        case success(Style)
        case fail(Style)
        case info(Style)
        case warning(Style)
    }
    
    /**
    Style enum
    */
    public enum Style {
        case light
        case dark
    }
}

extension CFNotifyView {
    
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

extension CFNotifyView {
    
    static func setToastThemeFor(view: ToastView, theme: Theme) {
        switch theme {
        case .success(let style):
            switch style {
            case .light:
                view.backgroundColor = UIColor(red: 65.0/256.0, green: 131.0/256.0, blue: 215.0/256.0, alpha: 1.0)
                view.textColor = UIColor.white
            case .dark:
                view.backgroundColor = UIColor(red: 31.0/256.0, green: 58.0/256.0, blue: 147.0/256.0, alpha: 1.0)
                view.textColor = UIColor.white
            }
        case .fail(let style):
            switch style {
            case .light:
                view.backgroundColor = UIColor(red: 231.0/256.0, green: 76.0/256.0, blue: 60.0/256.0, alpha: 1.0)
                view.textColor = UIColor.white
            case .dark:
                view.backgroundColor = UIColor(red: 185.0/256.0, green: 29.0/256.0, blue: 71.0/256.0, alpha: 1.0)
                view.textColor = UIColor.white
            }
        case .info(let style):
            switch style {
            case .light:
                view.backgroundColor = UIColor(red: 191.0/256.0, green: 191.0/256.0, blue: 191.0/256.0, alpha: 1.0)
                view.textColor = UIColor.white
            case .dark:
                view.backgroundColor = UIColor(red: 29.0/256.0, green: 29.0/256.0, blue: 29.0/256.0, alpha: 1.0)
                view.textColor = UIColor.white
            }
        case .warning(let style):
            switch style {
            case .light:
                view.backgroundColor = UIColor(red: 245.0/256.0, green: 171.0/256.0, blue: 53.0/256.0, alpha: 1.0)
                view.textColor = UIColor.white
            case .dark:
                view.backgroundColor = UIColor(red: 218.0/256.0, green: 83.0/256.0, blue: 44.0/256.0, alpha: 1.0)
                view.textColor = UIColor.white
            }
        }
    }
    
    static func setClassicThemeFor(view: ClassicView, theme: Theme) {
        let frameworkBundle = Bundle(for: CFNotifyView.self)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("CFResources.bundle")
        let resourceBundle = Bundle(url: bundleURL!)
        
        switch theme {
        case .success(let style):
            switch style {
            case .light:
                view.backgroundColor = UIColor(red: 65.0/256.0, green: 131.0/256.0, blue: 215.0/256.0, alpha: 1.0)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "icon_success", in: resourceBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
                view.imageView.tintColor = UIColor.white
            case .dark:
                view.backgroundColor = UIColor(red: 31.0/256.0, green: 58.0/256.0, blue: 147.0/256.0, alpha: 1.0)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "icon_success_dark", in: resourceBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
                view.imageView.tintColor = UIColor.white
            }
        case .fail(let style):
            switch style {
            case .light:
                view.backgroundColor = UIColor(red: 231.0/256.0, green: 76.0/256.0, blue: 60.0/256.0, alpha: 1.0)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "icon_fail", in: resourceBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
                view.imageView.tintColor = UIColor.white
            case .dark:
                view.backgroundColor = UIColor(red: 185.0/256.0, green: 29.0/256.0, blue: 71.0/256.0, alpha: 1.0)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "icon_fail_dark", in: resourceBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
                view.imageView.tintColor = UIColor.white
            }
        case .info(let style):
            switch style {
            case .light:
                view.backgroundColor = UIColor(red: 191.0/256.0, green: 191.0/256.0, blue: 191.0/256.0, alpha: 1.0)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "icon_info", in: resourceBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
                view.imageView.tintColor = UIColor.white
            case .dark:
                view.backgroundColor = UIColor(red: 29.0/256.0, green: 29.0/256.0, blue: 29.0/256.0, alpha: 1.0)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "icon_info_dark", in: resourceBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
                view.imageView.tintColor = UIColor.white
            }
        case .warning(let style):
            switch style {
            case .light:
                view.backgroundColor = UIColor(red: 245.0/256.0, green: 171.0/256.0, blue: 53.0/256.0, alpha: 1.0)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "icon_warning", in: resourceBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
                view.imageView.tintColor = UIColor.white
            case .dark:
                view.backgroundColor = UIColor(red: 218.0/256.0, green: 83.0/256.0, blue: 44.0/256.0, alpha: 1.0)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "icon_warning_dark", in: resourceBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
                view.imageView.tintColor = UIColor.white
            }
        }
    }
    
    static func setCyberThemeFor(view: CyberView, theme: Theme) {
        let frameworkBundle = Bundle(for: CFNotifyView.self)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("CFResources.bundle")
        let resourceBundle = Bundle(url: bundleURL!)
        
        switch theme {
        case .success(let style):
            switch style {
            case .light:
                view.backgroundColor = UIColor(red: 65.0/256.0, green: 131.0/256.0, blue: 215.0/256.0, alpha: 0.5)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "icon_success", in: resourceBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
            case .dark:
                view.backgroundColor = UIColor(red: 31.0/256.0, green: 58.0/256.0, blue: 147.0/256.0, alpha: 0.5)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "icon_success_dark", in: resourceBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
            }
        case .fail(let style):
            switch style {
            case .light:
                view.backgroundColor = UIColor(red: 231.0/256.0, green: 76.0/256.0, blue: 60.0/256.0, alpha: 0.5)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "icon_fail", in: resourceBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
            case .dark:
                view.backgroundColor = UIColor(red: 185.0/256.0, green: 29.0/256.0, blue: 71.0/256.0, alpha: 0.5)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "icon_fail_dark", in: resourceBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
            }
        case .info(let style):
            switch style {
            case .light:
                view.backgroundColor = UIColor(red: 191.0/256.0, green: 191.0/256.0, blue: 191.0/256.0, alpha: 0.5)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "icon_info", in: resourceBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
            case .dark:
                view.backgroundColor = UIColor(red: 29.0/256.0, green: 29.0/256.0, blue: 29.0/256.0, alpha: 0.5)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "icon_info_dark", in: resourceBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
            }
        case .warning(let style):
            switch style {
            case .light:
                view.backgroundColor = UIColor(red: 245.0/256.0, green: 171.0/256.0, blue: 53.0/256.0, alpha: 0.5)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "icon_warning", in: resourceBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
            case .dark:
                view.backgroundColor = UIColor(red: 218.0/256.0, green: 83.0/256.0, blue: 44.0/256.0, alpha: 0.5)
                view.titleTextColor = UIColor.white
                view.bodyTextColor = UIColor.white
                let image = UIImage(named: "icon_warning_dark", in: resourceBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                view.imageView.image = image
                view.imageView.tintColor = UIColor.white
            }
        }
    }
    
}
