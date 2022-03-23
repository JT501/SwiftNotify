//
// Created by Johnny Tsoi on 1/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import Foundation


/// SwiftNotify notification enums
enum NoticeNotification {
    static let didDisappear = Notification.Name("com.jt501.SwiftNotify.NoticeDidDisappear")
    static let startPanning = Notification.Name("com.jt501.SwiftNotify.NoticeStartPanning")
    static let endPanningNotDismiss = Notification.Name("com.jt501.SwiftNotify.NoticeEndPanningNotDismiss")
    static let startPressing = Notification.Name("com.jt501.SwiftNotify.NoticeStartPressing")
    static let endPressing = Notification.Name("com.jt501.SwiftNotify.NoticeEndPressing")
}

struct NoticeInfo {
    var id: String
}

extension NoticeInfo {
    static let userInfoKey: AnyHashable = "NoticeInfo"

    init?(notification: Notification) {
        if let noticeInfo = notification.userInfo?[NoticeInfo.userInfoKey] as? NoticeInfo {
            self = noticeInfo
        } else {
            return nil
        }
    }
}
