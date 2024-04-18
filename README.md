SwiftNotify
===============
[![GitHub license](https://img.shields.io/github/license/JT501/SwiftNotify.svg?style=flat-square)](https://github.com/JT501/SwiftNotify/blob/master/LICENSE)
[![Swift](https://img.shields.io/badge/Swift-5.5+-orange.svg?style=flat-square)](https://developer.apple.com/swift/)
![Static Badge](https://img.shields.io/badge/spm-compatible-orange?style=flat-square)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/jt501/SwiftNotify/static.yml?branch=master&style=flat-square&label=Doc%20Deploy&color=blue)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/cocoapods/v/SwiftNotify.svg?style=flat-square)](https://cocoapods.org/pods/SwiftNotify)
[![GitHub forks](https://img.shields.io/github/forks/JT501/SwiftNotify.svg?style=flat-square)](https://github.com/JT501/SwiftNotify/network)
[![GitHub stars](https://img.shields.io/github/stars/JT501/SwiftNotify.svg?style=flat-square)](https://github.com/JT501/SwiftNotify/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/JT501/SwiftNotify.svg?style=flat-square)](https://github.com/JT501/SwiftNotify/issues)

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

## Documentation
Feel free to check out the [documentation page](https://jt501.github.io/SwiftNotify) for installation guide and usages.

## Requirements
- Swift 5.9+
- iOS 13.0+

Change Log
------------------
Please read [CHANGELOG.md](CHANGELOG.md).

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
