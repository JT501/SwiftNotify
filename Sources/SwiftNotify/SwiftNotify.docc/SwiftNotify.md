# ``SwiftNotify``

A *Swifty* UI framework for **notifications** and **alerts**.

## Overview

![Logo](logo-r-256.png)

**SwiftNotify** makes notifications interactive, playful and fun! 

@Row {
    @Column {
        ![Demo](Demo1) 
    }
    @Column {
        ![Demo](Demo2)
    }
    @Column {
        ![Demo](Demo3)
    }
}

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

### Themes

SwiftNotify provides **three** pre-made notice ``Theme``s. Each theme has a **light** and a **dark** mode.
In additional, every theme has four ``Level``: **success**, **fail**, **warning** and **info**.

They are:

@Row {
    @Column {
        - **Cyber**

        @TabNavigator {
            @Tab("Light") {
                ![Cyber](Cyber)
            }
            @Tab("Dark") {
                ![CyberDark](CyberDark)
            }
        }
    }
    @Column {
        - **Classic**

        @TabNavigator {
            @Tab("Light") {
                ![Classic](Classic)
            }
            @Tab("Dark") {
                ![ClassicDark](ClassicDark)
            }
        }
    }
    @Column {
        - **Toast**

        @TabNavigator {
            @Tab("Light") {
                ![Toast](Toast)
            }
            @Tab("Dark") {
                ![ToastDark](ToastDark)
            }
        }
    }
}


Every theme has its own appearence configuration (``ThemeConfig``). And every level has its own appearence configuration (``LevelConfig``).

## Topics

### Getting Started

- <doc:Installation>
- <doc:Basic-Usage>

### Theming

- ``Theme``
- ``ThemeConfig``
- ``Level``
- ``LevelConfig``
