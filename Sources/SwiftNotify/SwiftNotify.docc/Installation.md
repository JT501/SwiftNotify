# Installation

Integrate SwiftNotify into your Xcode project.

## Overview

SwiftNotify support **Swift Package Manager**, **Carthage** and **Cocoapods**.

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

## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
