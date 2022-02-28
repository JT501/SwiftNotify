//
// Created by Johnny Choi on 1/3/2022.
// Copyright (c) 2022 Johnny Choi@Co-Fire. All rights reserved.
//

import Foundation

enum NoticeNotification {
    static let didDisappear = Notification.Name("com.jt501.SwiftNotify.NoticeDidDisappear")
    static let startDragging = Notification.Name("com.jt501.SwiftNotify.NoticeStartDragging")
    static let endDraggingNotDismiss = Notification.Name("com.jt501.SwiftNotify.NoticeEndDraggingNotDismiss")
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