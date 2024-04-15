import SwiftNotify
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        SN.defaultTheme = .cyberDark
        SN.defaultFromPosition = .top(.random)
        SN.defaultToPosition = .top()
        SN.defaultNoticeDuration = .short

        return true
    }

    // ...
}