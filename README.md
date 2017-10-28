CFNotify
===============
[![Travis branch](https://img.shields.io/travis/hallelujahbaby/CFNotify/master.svg?style=flat-square)](https://travis-ci.org/hallelujahbaby/CFNotify)
[![GitHub issues](https://img.shields.io/github/issues/hallelujahbaby/CFNotify.svg?style=flat-square)](https://github.com/hallelujahbaby/CFNotify/issues)
[![Swift](https://img.shields.io/badge/Swift-4.0+-orange.svg?style=flat-square)](https://developer.apple.com/swift/)
[![GitHub forks](https://img.shields.io/github/forks/hallelujahbaby/CFNotify.svg?style=flat-square)](https://github.com/hallelujahbaby/CFNotify/network)
[![GitHub stars](https://img.shields.io/github/stars/hallelujahbaby/CFNotify.svg?style=flat-square)](https://github.com/hallelujahbaby/CFNotify/stargazers)
[![GitHub license](https://img.shields.io/github/license/hallelujahbaby/CFNotify.svg?style=flat-square)](https://github.com/hallelujahbaby/CFNotify/blob/master/LICENSE)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage)

**CFNotify** is written in Swift. Using [`UIKit Dynamics`][UIKit Dynamics] as animator. It can make **ANY** `UIView` object _**draggable**_ and _**throwable**_. This library mainly use for _in-app notification_ and _alerts_. Let's notices and alert your users in more playable and fun way !

![Demo1](image/Demo1.gif)
![Demo2](image/Demo2.gif)
![Demo3](image/Demo3.gif)

Features
-----------------
- [x] Work with **ANY** `UIView` object !
- [x] Using UIKit Dynamics. Light and Smooth !
- [x] Highly Customizable
- [x] Included **three** ready to use views: `CyberView`, `ClassicView`, `ToastView`
- [x] Simple to implement

Requirements
-----------------
* Swift 4.0+
* Xcode 9
* iOS 9.0+

Installation
------------------
* #### [Carthage](https://github.com/Carthage/Carthage) (_Recommended_)
  Add the following lines into  [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile)  

  ````bash
  #CFNotify
  github "hallelujahbaby/CFNotify"
  ````

  Run `carthage update` and then add **CFNotify.framework** and **CFResources.bundle** into your project

* #### [Cocoapods](https://cocoapods.org/)
  Add the following lines into Podfile

  ````ruby
  pod "CFNotify"
  ````

To-Do List
------------------
- [ ] Improve the example app
- [ ] Add alert view with buttons
- [ ] Full documentation

License
------------------
***CFNotify*** is released under an [MIT License][mitLink]. See [LICENSE](LICENSE) for details.

[UIKit Dynamics]:https://developer.apple.com/documentation/uikit/animation_and_haptics/uikit_dynamics
[mitLink]:http://opensource.org/licenses/MIT
