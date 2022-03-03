//
// Created by Johnny Choi on 3/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import Foundation

/// SwiftNotify **Cyber** theme base class
///
/// Add an extra property `blurEffectStyle` to theme
open class CyberThemeBase: ThemeProtocol {
    public typealias E = DefaultNoticeLevels
    public typealias V = CyberView

    public var titleTextColor: UIColor { .white }
    public var bodyTextColor: UIColor { .white }

    public var typeDictionary: [DefaultNoticeLevels: NoticeLevelProtocol] { [:] }

    /// Blur Style
    public var blurEffectStyle: UIBlurEffect.Style { .light }
}