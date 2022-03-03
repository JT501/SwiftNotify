//
//  TitleView.swift
//  SwiftNotify
//
//  Created by Johnny Tsoi on 22/11/2016.
//  Copyright © 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

open class CyberView: NoticeView {
    /// Blur Effect
    var blurEffect: UIBlurEffect

    private var blurEffectView: UIVisualEffectView
    private var vibrancyEffect: UIVibrancyEffect
    private var vibrancyEffectView: UIVisualEffectView

    // MARK: - Initialization
    public init(title: String? = nil, body: String? = nil, image: UIImage? = nil, blurStyle: UIBlurEffect.Style) {
        blurEffect = UIBlurEffect(style: blurStyle)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)

        let image = image?.withRenderingMode(.alwaysTemplate)

        super.init(titleText: title, bodyText: body, iconImage: image)
    }

    public required init<T: ThemeProtocol>(titleText: String?, bodyText: String?, theme: T, level: T.E, width: CGFloat = UIScreen.main.bounds.size.width * 0.8, height: CGFloat = 0) {
        guard let theme = theme as? CyberThemeBase,
              let type = level as? CyberThemeBase.E else {
            fatalError("Theme is not CyberThemeBase")
        }
        blurEffect = UIBlurEffect(style: theme.blurEffectStyle)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)

        super.init(titleText: titleText, bodyText: bodyText, theme: theme, level: type)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addToSubViews() {
        vibrancyEffectView.frame = bounds
        if let iconView = iconView {
            vibrancyEffectView.contentView.addSubview(iconView)
        }
        if let titleLabel = titleLabel {
            vibrancyEffectView.contentView.addSubview(titleLabel)
        }
        if let bodyLabel = bodyLabel {
            vibrancyEffectView.contentView.addSubview(bodyLabel)
        }
        blurEffectView.contentView.addSubview(vibrancyEffectView)

        blurEffectView.frame = bounds
        addSubview(blurEffectView)
    }
}

