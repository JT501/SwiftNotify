//
// Created by Johnny Choi on 28/2/2022.
// Copyright (c) 2022 Johnny Choi@Co-Fire. All rights reserved.
//

import Foundation

class NoticeManager {
    private init() {
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(receiveNoticeDidDisappear(notification:)),
                name: NoticeNotification.didDisappear,
                object: nil
        )
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(receiveNoticeStartDragging(notification:)),
                name: NoticeNotification.startDragging,
                object: nil
        )
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(receiveNoticeEndDraggingNotDismiss(notification:)),
                name: NoticeNotification.endDraggingNotDismiss,
                object: nil
        )
    }

    static let shared = NoticeManager()

    let queue = DispatchQueue(
            label: "com.jt501.SwiftNotify.NoticeQueue",
            attributes: .concurrent
    )

    var intervalBetweenNotices: DispatchTimeInterval = .milliseconds(500)

    private var unsafePendingNotices: [Notice] = [] {
        didSet {
            print("Pending Notices: \(unsafePendingNotices)")
        }
    }

    private var unsafeCurrentNotices: [Notice] = [] {
        didSet {
            print("Current Notices: \(unsafeCurrentNotices)")
        }
    }

    private var autoDismissTasks: [String: DispatchWorkItem] = [:] {
        didSet {
            print("Auto Dismiss Tasks: \(autoDismissTasks)")
        }
    }

    var pendingNotices: [Notice] {
        var noticesCopy: [Notice] = []
        queue.sync { [weak self] in
            noticesCopy = self?.unsafePendingNotices ?? []
        }
        return noticesCopy
    }

    var currentNotices: [Notice] {
        var noticesCopy: [Notice] = []
        queue.sync { [weak self] in
            noticesCopy = self?.unsafeCurrentNotices ?? []
        }
        return noticesCopy
    }

    func addPendingNotice(_ notice: Notice) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            self.unsafePendingNotices.append(notice)
            if self.unsafeCurrentNotices.isEmpty {
                self.unsafeCurrentNotices.append(notice)
                self.showNext()
            }
        }
    }

    func removePendingNotice(_ notice: Notice) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            self.unsafePendingNotices.removeAll {
                $0.id == notice.id
            }
        }
    }

    func removeAllPendingNotices() {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            self.unsafePendingNotices.removeAll()
        }
    }

    func showNotice() {
        guard !pendingNotices.isEmpty else { return }
        let currentNotice = pendingNotices.first!
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else {
                dispatchGroup.leave()
                return
            }
            self.unsafePendingNotices.removeAll { $0.id == currentNotice.id }
            if !self.unsafeCurrentNotices.contains(currentNotice) {
                self.unsafeCurrentNotices.append(currentNotice)
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            currentNotice.present { [weak self] completed in
                if completed {
                    self?.autoDismissNotice(id: currentNotice.id)
                }
            }
        }
    }

    func showNext() {
        guard !unsafePendingNotices.isEmpty else { return }
        queue.asyncAfter(deadline: .now() + intervalBetweenNotices) { [weak self] in
            self?.showNotice()
        }
    }

    func dismissNotice(_ notice: Notice) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            guard self.unsafeCurrentNotices.contains(notice) else { return }
            self.unsafeCurrentNotices.removeAll { $0.id == notice.id }
            DispatchQueue.main.async {
                notice.hide()
            }
            self.showNext()
        }
    }

    func autoDismissNotice(id: String) {
        guard let notice = currentNotices.first(where: { $0.id == id }) else { return }
        if let dismissTime = notice.hideTime {
            let task = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                guard self.unsafeCurrentNotices.contains(notice) else { return }

                self.autoDismissTasks.removeValue(forKey: notice.id)

                DispatchQueue.main.async { notice.hide() }
            }
            autoDismissTasks[notice.id] = task

            queue.asyncAfter(deadline: .now() + dismissTime, execute: task)
        }
    }

    func cancelAutoDismiss(noticeId: String) {
        if let task = autoDismissTasks[noticeId] {
            task.cancel()
            autoDismissTasks.removeValue(forKey: noticeId)
        }
    }

    func dismissCurrentNotices() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard !self.unsafeCurrentNotices.isEmpty else { return }
            guard self.unsafeCurrentNotices.allSatisfy({ !$0.isHiding }) else { return }

            self.unsafeCurrentNotices.forEach { $0.hide() }
            self.unsafeCurrentNotices.removeAll()
        }
    }

    @objc func receiveNoticeDidDisappear(notification: Notification) {
        guard let noticeInfo = NoticeInfo(notification: notification) else { return }

        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            self.unsafeCurrentNotices.removeAll { $0.id == noticeInfo.id }

            self.showNext()
        }
    }

    @objc func receiveNoticeStartDragging(notification: Notification) {
        guard let noticeInfo = NoticeInfo(notification: notification) else { return }

        cancelAutoDismiss(noticeId: noticeInfo.id)
    }

    @objc func receiveNoticeEndDraggingNotDismiss(notification: Notification) {
        guard let noticeInfo = NoticeInfo(notification: notification) else { return }

        autoDismissNotice(id: noticeInfo.id)
    }
}
