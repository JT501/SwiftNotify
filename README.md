SwiftNotify
===============
[![GitHub license](https://img.shields.io/github/license/JT501/SwiftNotify.svg?style=flat-square)](https://github.com/JT501/SwiftNotify/blob/master/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/JT501/SwiftNotify.svg?style=flat-square)](https://github.com/JT501/SwiftNotify/issues)
[![Swift](https://img.shields.io/badge/Swift-5.5+-orange.svg?style=flat-square)](https://developer.apple.com/swift/)
![Static Badge](https://img.shields.io/badge/spm-compatible-orange?style=flat-square)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/cocoapods/v/SwiftNotify.svg?style=flat-square)](https://cocoapods.org/pods/SwiftNotify)
[![GitHub forks](https://img.shields.io/github/forks/JT501/SwiftNotify.svg?style=flat-square)](https://github.com/JT501/SwiftNotify/network)
[![GitHub stars](https://img.shields.io/github/stars/JT501/SwiftNotify.svg?style=flat-square)](https://github.com/JT501/SwiftNotify/stargazers)

A *Swifty* UI framework for **notifications** and **alerts**.

![Demo1](image/Demo1.gif)
![Demo2](image/Demo2.gif)
![Demo3](image/Demo3.gif)

SwiftNotify uses *UIKit Dynamics* as animator to create smooth interactive animations and physics behaviours for the notices. 

SwiftNotify is intended to be lightweight, easy-to-use and highly customizable. 
Most of the time, you just need a single line of code to show a notice:

```swift
SN.show(title: "OMG", message: "SwiftNotify is Great !", level: .success)
```

As simple as that.

## Requirements
- Swift 5.5+
- iOS 13.0+

Features
-----------------

- [x] Work with **ANY** `UIView` object !
- [x] Using UIKit Dynamics. Light and Smooth !
- [x] Highly Customizable
- [x] Included **three** ready to use views: `CyberView`, `ClassicView`, `ToastView`
- [x] Simple to implement

Change Log
------------------
Please read [CHANGELOG.md](CHANGELOG.md).

Installation
------------------

### Swift Package Manager (Recommended)
---------------------------------------------
1. Navigate to **File › Add Packages…** and enter “https://github.com/JT501/SwiftNotify” in the Search textfield.
2. Change **Dependency Rule** to **Up to Next Major Version** and enter "2.0.0".
3. Select your app target in **Add to Package**.
4. Click **Add Package**.


### Carthage
---------------------------------------------
Add the framework to your **Cartfile**.
``` swift
github "JT501/SwiftNotify" ~> 2.0.0
```

Build the framework and then add **SwiftNotify.xcframework** and **SwiftNotifyResources.bundle** into your project.
``` shell
carthage update --use-xcframeworks
```


### Cocoapods
---------------------------------------------
Add the framework in your **Podfile**
``` ruby
pod 'SwiftNotify', '~> 2.0.0'
```

Initialize the pod.
``` shell
pod install
```

Bugs and issues
-----------------
If you find any bugs or encounter some issues regard to this framework, please feel free to open a new issue
in [Issues](https://github.com/JT501/SwiftNotify/issues) page.

Contribute
------------------
You are welcome to contribute into this project, feel free to [Pull Request](https://github.com/JT501/SwiftNotify/pulls)
.

License
------------------
***SwiftNotify*** is released under an [MIT License][MIT]. See [LICENSE](LICENSE) for details.

[UIKit Dynamics]:https://developer.apple.com/documentation/uikit/animation_and_haptics/uikit_dynamics

[Cartfile]:https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile

[Podfile]:https://guides.cocoapods.org/syntax/podfile.html

[SPM]:https://github.com/apple/swift-package-manager

[MIT]:http://opensource.org/licenses/MIT
