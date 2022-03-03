//
// Created by Johnny Choi on 3/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import Foundation

/// SwiftNotify **Cyber Light** theme
class CyberLight: CyberThemeBase {
    override var typeDictionary: [E: NoticeLevelProtocol] {
        [
            .success: Success(),
            .fail: Fail(),
            .info: Info(),
            .warning: Warning()
        ]
    }
    let iconImageTintColor: UIColor? = .white
}

private struct Success: NoticeLevelProtocol {
    let backgroundColor: UIColor = DefaultColors.Success
    let iconImage: UIImage? = DefaultIcons.Success
}

private struct Fail: NoticeLevelProtocol {
    let backgroundColor: UIColor = DefaultColors.Fail
    let iconImage: UIImage? = DefaultIcons.Fail
}

private struct Info: NoticeLevelProtocol {
    let backgroundColor: UIColor = DefaultColors.Info
    let iconImage: UIImage? = DefaultIcons.Info
}

private struct Warning: NoticeLevelProtocol {
    let backgroundColor: UIColor = DefaultColors.Warning
    let iconImage: UIImage? = DefaultIcons.Warning
}


