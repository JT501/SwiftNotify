//
// Created by Johnny Choi on 3/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import Foundation

enum DefaultIcons {
    // Resource Bundle
    static private var resourceBundle: Bundle? {
        #if SWIFT_PACKAGE
        let bundle = Bundle.module
        return bundle
        #else
        let frameworkBundle = Bundle(for: SwiftNotifyView.self)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("SwiftNotifyResources.bundle")
        return Bundle(url: bundleURL!)
        #endif
    }

    // Light
    static let Success = UIImage(
            named: "icon_success",
            in: resourceBundle,
            compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)

    static let Fail = UIImage(
            named: "icon_fail",
            in: resourceBundle,
            compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)

    static let Info = UIImage(
            named: "icon_info",
            in: resourceBundle,
            compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)

    static let Warning = UIImage(
            named: "icon_warning",
            in: resourceBundle,
            compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)

    // Dark
    static let SuccessDark = UIImage(
            named: "icon_success_dark",
            in: resourceBundle,
            compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)

    static let FailDark = UIImage(
            named: "icon_fail_dark",
            in: resourceBundle,
            compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)

    static let InfoDark = UIImage(
            named: "icon_info_dark",
            in: resourceBundle,
            compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)

    static let WarningDark = UIImage(
            named: "icon_warning_dark",
            in: resourceBundle,
            compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)
}
