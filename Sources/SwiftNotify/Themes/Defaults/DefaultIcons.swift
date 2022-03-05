//
// Created by Johnny Choi on 3/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import Foundation

public enum DefaultIcons {
    // Resource Bundle
    static private var resourceBundle: Bundle? {
        #if SWIFT_PACKAGE
        let bundle = Bundle.module
        return bundle
        #else
        let frameworkBundle = Bundle(for: SwiftNotify.self)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("SwiftNotifyResources.bundle")
        return Bundle(url: bundleURL!)
        #endif
    }

    // Light
    public static let Success = UIImage(
            named: "icon_success",
            in: resourceBundle,
            compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)

    public static let Fail = UIImage(
            named: "icon_fail",
            in: resourceBundle,
            compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)

    public static let Info = UIImage(
            named: "icon_info",
            in: resourceBundle,
            compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)

    public static let Warning = UIImage(
            named: "icon_warning",
            in: resourceBundle,
            compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)

    // Solid
    public static let SuccessSolid = UIImage(
            named: "icon_success_solid",
            in: resourceBundle,
            compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)

    public static let FailSolid = UIImage(
            named: "icon_fail_solid",
            in: resourceBundle,
            compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)

    public static let InfoSolid = UIImage(
            named: "icon_info_solid",
            in: resourceBundle,
            compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)

    public static let WarningSolid = UIImage(
            named: "icon_warning_solid",
            in: resourceBundle,
            compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)
}
