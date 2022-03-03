//
// Created by Johnny Choi on 3/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import Foundation

/// SwiftNotify **Cyber** theme base class
///
/// Add an extra property `blurEffectStyle` to theme
public class CyberThemeBase: ThemeProtocol {
    public typealias E = DefaultNoticeType
    public typealias V = CyberView

    public var titleTextColor: UIColor { .white }
    public var bodyTextColor: UIColor { .white }

    public var typeDictionary: [DefaultNoticeType: NoticeTypeProtocol] { [:] }

    /// Blur Style
    public var blurEffectStyle: UIBlurEffect.Style { .light }
}