# Basic Usage

The least configuration to use SwiftNotify.

## Overview

SwiftNotify provides **default configurations**. You do not need to config a lot if you are satisfied with the **defaults**.

Simply just call:
```swift
SN.show(title: "OMG", message: "SwiftNotify is Great !", level: .success)
```
A *Cyber* theme (default) notice will be shown.

If you want to show a *Classic Dark* notice, you can pass ``Theme/classicDark`` to **theme** parameter.
``` swift
SN.show(
    title: "OMG", 
    message: "SwiftNotify is Great !",
    theme: .classicDark,
    level: .success)
```

For more configurations for showing a notice, please read the api reference of ``SwiftNotify/SwiftNotify/show(title:message:theme:themeConfig:level:duration:fromPosition:toPosition:tapHandler:width:height:)``.

## Global configurations
You just have to setup the configurations in one place (normally in *AppDelegate.swift*), all notices will share the same configurations.

For example:

```swift
// App Delegate - didFinishLaunchingWithOptions 
...

SN.defaultTheme = .classic
SN.defaultFromPosition = .top(.random)
SN.defaultToPosition = .top()
SN.defaultNoticeDuration = .short

...

```

- ``SwiftNotify/defaultTheme`` is the default theme.
- ``SwiftNotify/defaultFromPosition``
- ``SwiftNotify/defaultToPosition``
- ``SwiftNotify/defaultNoticeDuration``

## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
