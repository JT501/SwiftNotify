# ``SwiftNotify``

A *Swifty* UI framework for **notifications** and **alerts**.

## Overview

**SwiftNotify** makes notifications interactive, playable and fun! 

![Demo](Demo1)

SwiftNotify uses *UIKit Dynamics* as animator to create smooth interactive animations and physics behaviours for the notices. 

SwiftNotify is intended to be lightweight, easy-to-use and highly customizable. 
Most of the time, you just need a single line of code to show a notice:

```swift
SN.show(title: "OMG", message: "SwiftNotify is Great !", level: .success)
```

As simple as that.

### Themes

SwiftNotify provides six beautiful ``Theme``s for notices.
In additional, every theme has four ``Level``: **success**, **fail**, **warning** and **info**.

They are:
- **``SwiftNotify/Theme/cyber``**
![Cyber](Cyber)
- **``SwiftNotify/Theme/cyberDark``**
![CyberDark](CyberDark)
- **``SwiftNotify/Theme/classic``**
![Classic](Classic)
- **``SwiftNotify/Theme/classicDark``**
![ClassicDark](ClassicDark)
- **``SwiftNotify/Theme/toast``**
![Toast](Toast)
- **``SwiftNotify/Theme/toastDark``**
![ToastDark](ToastDark)

Every theme has its own appearence configuration (``ThemeConfig``). And every level has its own appearence configuration (``LevelConfig``).

## Requirements
- Swift 5.5+
- iOS 13.0+

## Topics

### Getting Started

- <doc:Installation>
- <doc:Basic-Usage>

### Theming

- ``Theme``
- ``ThemeConfig``
- ``Level``
- ``LevelConfig``
