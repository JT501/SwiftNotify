//
// Created by Johnny Choi on 2/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

open class NoticeViewBase: UIView, NoticeView {
    /// Width of notice
    open var width: CGFloat

    /// Height of notice
    open var height: CGFloat

    /// Corner radius of notice
    open var cornerRadius: CGFloat

    /// Padding of notice
    open var padding: CGFloat

    /// Padding between each elements in notice
    private let interPadding: CGFloat = 10

    /// Instance of title label
    open var titleLabel: UILabel?

    /// Notice Title text
    open var titleText: String?

    /// Title text color
    open var titleTextColor: UIColor

    /// Title text font and font size
    open var titleTextFont: UIFont

    /// Title text alignment
    open var titleTextAlignment: NSTextAlignment

    /// Title label background color
    open var titleBackgroundColor: UIColor

    /// Instance of body label
    open var bodyLabel: UILabel?

    /// Notice Body text
    open var bodyText: String?

    /// Body text color
    open var bodyTextColor: UIColor

    /// Body text font and font size
    open var bodyTextFont: UIFont

    /// Body text alignment
    open var bodyTextAlignment: NSTextAlignment

    /// Body text label background color
    open var bodyBackgroundColor: UIColor

    /// Instance of icon image view
    open var iconView: UIImageView?

    /// Icon Image
    open var iconImage: UIImage?

    /// Icon image view's width
    open var iconViewWidth: CGFloat

    /// Icon image view's height
    open var iconViewHeight: CGFloat

    /// Icon image view's content mode
    open var iconViewContentMode: UIView.ContentMode

    /// Icon image view's corner radius
    open var iconViewCornerRadius: CGFloat

    /// Icon Image view's tint color
    open var iconViewTintColor: UIColor?

    public required convenience init(
            titleText: String?,
            bodyText: String?,
            themeConfig: ThemeConfig,
            level: NoticeLevels
    ) {
        let levelConfig = themeConfig.levelConfigs[.success]!
        self.init(
                titleText: titleText,
                titleTextColor: levelConfig.titleTextColor ?? themeConfig.titleTextColor,
                titleTextFont: themeConfig.titleTextFont,
                titleTextAlignment: themeConfig.titleTextAlignment,
                titleBackgroundColor: levelConfig.titleBackgroundColor ?? themeConfig.titleBackgroundColor,
                bodyText: bodyText,
                bodyTextColor: levelConfig.bodyTextColor ?? themeConfig.bodyTextColor,
                bodyTextFont: themeConfig.bodyTextFont,
                bodyTextAlignment: themeConfig.bodyTextAlignment,
                bodyBackgroundColor: levelConfig.bodyBackgroundColor ?? themeConfig.bodyBackgroundColor,
                iconImage: levelConfig.iconImage,
                iconViewWidth: themeConfig.iconViewWidth,
                iconViewHeight: themeConfig.iconViewHeight,
                iconViewContentMode: themeConfig.iconViewContentMode,
                iconViewCornerRadius: themeConfig.iconViewCornerRadius,
                iconViewTintColor: levelConfig.iconImageTintColor ?? themeConfig.iconImageTintColor,
                width: UIScreen.main.bounds.size.width * 0.8,
                height: 0,
                backgroundColor: levelConfig.backgroundColor,
                cornerRadius: themeConfig.cornerRadius,
                padding: themeConfig.padding
        )
    }

    public init(
            titleText: String? = nil,
            titleTextColor: UIColor = .white,
            titleTextFont: UIFont = .boldSystemFont(ofSize: 16),
            titleTextAlignment: NSTextAlignment = .left,
            titleBackgroundColor: UIColor = .clear,
            bodyText: String? = nil,
            bodyTextColor: UIColor = .white,
            bodyTextFont: UIFont = .systemFont(ofSize: 13, weight: UIFont.Weight.regular),
            bodyTextAlignment: NSTextAlignment = .left,
            bodyBackgroundColor: UIColor = .clear,
            iconImage: UIImage? = nil,
            iconViewWidth: CGFloat = 50,
            iconViewHeight: CGFloat = 50,
            iconViewContentMode: UIView.ContentMode = .scaleAspectFill,
            iconViewCornerRadius: CGFloat = 25,
            iconViewTintColor: UIColor? = nil,
            width: CGFloat = UIScreen.main.bounds.size.width * 0.8,
            height: CGFloat = 0,
            backgroundColor: UIColor? = .black,
            cornerRadius: CGFloat = 10,
            padding: CGFloat = 10
    ) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.titleText = titleText
        self.titleTextColor = titleTextColor
        self.titleTextFont = titleTextFont
        self.titleTextAlignment = titleTextAlignment
        self.titleBackgroundColor = titleBackgroundColor
        self.bodyText = bodyText
        self.bodyTextColor = bodyTextColor
        self.bodyTextFont = bodyTextFont
        self.bodyTextAlignment = bodyTextAlignment
        self.bodyBackgroundColor = bodyBackgroundColor
        self.iconImage = iconImage
        self.iconViewWidth = iconViewWidth
        self.iconViewHeight = iconViewHeight
        self.iconViewContentMode = iconViewContentMode
        self.iconViewCornerRadius = iconViewCornerRadius
        self.iconViewTintColor = iconViewTintColor
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))

        self.backgroundColor = backgroundColor

        setupView()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func setupView() {
        if let iconImage = iconImage {
            // Setup Icon View
            iconView = UIImageView(image: iconImage)
            iconView?.sizeThatFits(CGSize(width: iconViewWidth, height: iconViewHeight))
            iconView?.contentMode = iconViewContentMode
            iconView?.layer.cornerRadius = iconViewCornerRadius
            iconView?.clipsToBounds = true
            iconView?.tintColor = iconViewTintColor
        }
        if let titleText = titleText {
            // Setup Title Label
            titleLabel = titleLabel ?? UILabel(frame: .zero)
            titleLabel?.numberOfLines = 0
            titleLabel?.lineBreakMode = .byWordWrapping
            titleLabel?.text = titleText
            titleLabel?.font = titleTextFont
            titleLabel?.textAlignment = titleTextAlignment
            titleLabel?.textColor = titleTextColor
            titleLabel?.backgroundColor = titleBackgroundColor
        }
        if let bodyText = bodyText {
            // Setup Body Label
            bodyLabel = bodyLabel ?? UILabel(frame: .zero)
            bodyLabel?.numberOfLines = 0
            bodyLabel?.lineBreakMode = .byWordWrapping
            bodyLabel?.text = bodyText
            bodyLabel?.font = bodyTextFont
            bodyLabel?.textAlignment = bodyTextAlignment
            bodyLabel?.textColor = bodyTextColor
            bodyLabel?.backgroundColor = bodyBackgroundColor
        }

        resizeToFit()

        addToSubViews()

        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }

    internal func addToSubViews() {
        if let iconView = iconView { addSubview(iconView) }
        if let titleLabel = titleLabel { addSubview(titleLabel) }
        if let bodyLabel = bodyLabel { addSubview(bodyLabel) }
    }

    // MARK: - Convenience functions
    internal func getCalculatedLabelSize(
            text: String?,
            font: UIFont,
            width: CGFloat? = nil
    ) -> CGSize {
        guard let text = text else { return .zero }

        let width = width ?? CGFloat.greatestFiniteMagnitude
        let label: UILabel = UILabel(frame: CGRect(0, 0, width, CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.bounds.size
    }

    /// Resize to fit content
    internal func resizeToFit() {
        let isImageViewHidden = iconView == nil
        let isTitleLabelHidden = titleLabel == nil
        let isBodyLabelHidden = bodyLabel == nil

        let iconViewWidth = isImageViewHidden ? .zero : (iconView?.bounds.width ?? .zero)
        let iconViewHeight = isImageViewHidden ? .zero : (iconView?.bounds.height ?? .zero)

        let titleLabelWidth = width - iconViewWidth - padding * 2 - (isImageViewHidden ? .zero : interPadding)
        let titleCalculatedSize = getCalculatedLabelSize(text: titleText, font: titleTextFont, width: titleLabelWidth)
        let titleLabelHeight = isTitleLabelHidden ? .zero : titleCalculatedSize.height

        let bodyLabelWidth = width - iconViewWidth - padding * 2 - (isImageViewHidden ? .zero : interPadding)
        let bodyLabelCalculatedSize = getCalculatedLabelSize(text: bodyText, font: bodyTextFont, width: bodyLabelWidth)
        let bodyLabelHeight = isBodyLabelHidden ? .zero : bodyLabelCalculatedSize.height

        let totalHeight = titleLabelHeight + bodyLabelHeight + padding * 2 + interPadding
        if totalHeight < (iconViewHeight + padding * 2) {
            bounds.height = iconViewWidth + padding * 2
        } else {
            bounds.height = totalHeight
        }

        let labelX: CGFloat
        if isImageViewHidden {
            labelX = padding
        } else {
            iconView?.center = CGPoint(x: (iconView?.bounds.midX ?? .zero) + padding, y: bounds.midY)
            labelX = (iconView?.frame.maxX ?? .zero) + interPadding
        }

        if isTitleLabelHidden {
            bodyLabel?.frame.size = CGSize(width: bodyLabelWidth, height: bodyLabelHeight)
            bodyLabel?.center = CGPoint(labelX + (bodyLabel?.bounds.midX ?? .zero), bounds.midY)
        } else if isBodyLabelHidden {
            titleLabel?.frame.size = CGSize(width: titleLabelWidth, height: titleLabelHeight)
            titleLabel?.center = CGPoint(labelX + (titleLabel?.bounds.midX ?? .zero), bounds.midY)
        } else {
            titleLabel?.frame = CGRect(
                    x: labelX,
                    y: padding,
                    width: titleLabelWidth,
                    height: titleLabelHeight)
            bodyLabel?.frame = CGRect(
                    x: labelX,
                    y: (titleLabel?.frame.maxY ?? .zero) + interPadding,
                    width: bodyLabelWidth,
                    height: bodyLabelHeight)
        }
    }
}
