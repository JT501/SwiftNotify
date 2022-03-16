//
// Created by Johnny Tsoi on 28/2/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import Foundation

public class NoticeManager {

    let queue: DispatchQueue

    private var unsafePendingNotices: [NoticeProtocol] = [] {
        didSet {
            print("Pending Notices: \(unsafePendingNotices)")
        }
    }

    private var unsafeCurrentNotices: [NoticeProtocol] = [] {
        didSet {
            print("Current Notices: \(unsafeCurrentNotices)")
        }
    }

    private var autoDismissTasks: [String: DispatchWorkItem] = [:] {
        didSet {
            print("Auto Dismiss Tasks: \(autoDismissTasks)")
        }
    }

    var pendingNotices: [NoticeProtocol] {
        var noticesCopy: [NoticeProtocol] = []
        queue.sync { [weak self] in
            noticesCopy = self?.unsafePendingNotices ?? []
        }
        return noticesCopy
    }

    var currentNotices: [NoticeProtocol] {
        var noticesCopy: [NoticeProtocol] = []
        queue.sync { [weak self] in
            noticesCopy = self?.unsafeCurrentNotices ?? []
        }
        return noticesCopy
    }

    init(queue: DispatchQueue) {
        self.queue = queue

        NotificationCenter.default.addObserver(
                self,
                selector: #selector(receiveNoticeDidDisappear(notification:)),
                name: NoticeNotification.didDisappear,
                object: nil
        )
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(receiveNoticeStartPanning(notification:)),
                name: NoticeNotification.startPanning,
                object: nil
        )
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(receiveNoticeEndPanningNotDismiss(notification:)),
                name: NoticeNotification.endPanningNotDismiss,
                object: nil
        )
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(receiveNoticeStartPressing(notification:)),
                name: NoticeNotification.startPressing,
                object: nil
        )
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(receiveNoticeEndPressing(notification:)),
                name: NoticeNotification.endPressing,
                object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NoticeNotification.didDisappear, object: nil)
        NotificationCenter.default.removeObserver(self, name: NoticeNotification.startPanning, object: nil)
        NotificationCenter.default.removeObserver(self, name: NoticeNotification.endPanningNotDismiss, object: nil)
        NotificationCenter.default.removeObserver(self, name: NoticeNotification.startPressing, object: nil)
        NotificationCenter.default.removeObserver(self, name: NoticeNotification.endPressing, object: nil)
    }

    func addPendingNotice(_ notice: NoticeProtocol) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            self.unsafePendingNotices.append(notice)
            if self.unsafeCurrentNotices.isEmpty {
                self.unsafeCurrentNotices.append(notice)
                self.showNext()
            }
        }
    }

    func removePendingNotice(_ notice: NoticeProtocol) {
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

    func showNotice(completion: (() -> Void)? = nil) {
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
            if !self.unsafeCurrentNotices.contains(where: { $0.id == currentNotice.id }) {
                self.unsafeCurrentNotices.append(currentNotice)
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            completion?()
            guard let self = self else { return }

            currentNotice.present { [weak self] completed in
                if completed {
                    self?.autoDismissNotice(id: currentNotice.id)
                }
            }
        }
    }

    private func showNext() {
        guard !unsafePendingNotices.isEmpty else { return }

        let delay: DispatchTimeInterval = SN.intervalBetweenNotices

        queue.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.showNotice()
        }
    }

    func dismissNotice(byId id: String) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            guard let notice = self.unsafeCurrentNotices.first(where: { $0.id == id }) else { return }
            DispatchQueue.main.async {
                guard !notice.isHiding else { return }
                notice.dismiss()
            }
            self.autoDismissTasks.removeValue(forKey: notice.id)
        }
    }

    func autoDismissNotice(id: String) {
        guard let notice = currentNotices.first(where: { $0.id == id }) else { return }
        // If task for notice already exists, return
        guard autoDismissTasks[notice.id] == nil else { return }

        let duration: DispatchTimeInterval

        switch notice.duration {
        case .forever:
            return
        case .short:
            duration = DispatchTimeInterval.seconds(2)
        case .long:
            duration = DispatchTimeInterval.seconds(4)
        case .custom(let time):
            duration = time
        }

        let task = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            guard self.unsafeCurrentNotices.contains(where: { $0.id == id }) else { return }
            guard !notice.isHiding else { return }

            self.autoDismissTasks.removeValue(forKey: notice.id)

            DispatchQueue.main.async { notice.dismiss() }
        }

        autoDismissTasks[notice.id] = task

        queue.asyncAfter(deadline: .now() + duration, execute: task)
    }

    func cancelAutoDismiss(noticeId: String) {
        if let task = autoDismissTasks[noticeId] {
            print("hi")
            task.cancel()
            autoDismissTasks.removeValue(forKey: noticeId)
        }
    }

    func dismissCurrentNotices() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard !self.unsafeCurrentNotices.isEmpty else { return }
            guard self.unsafeCurrentNotices.allSatisfy({ !$0.isHiding }) else { return }

            self.unsafeCurrentNotices.forEach { [weak self] in
                $0.dismiss()
                self?.autoDismissTasks.removeValue(forKey: $0.id)
            }
        }
    }

    @objc private func receiveNoticeDidDisappear(notification: Notification) {
        guard let noticeInfo = NoticeInfo(notification: notification) else { return }

        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            self.unsafeCurrentNotices.removeAll { $0.id == noticeInfo.id }

            self.showNext()
        }
    }

    @objc private func receiveNoticeStartPanning(notification: Notification) {
        guard let noticeInfo = NoticeInfo(notification: notification) else { return }

        cancelAutoDismiss(noticeId: noticeInfo.id)
    }

    @objc private func receiveNoticeEndPanningNotDismiss(notification: Notification) {
        guard let noticeInfo = NoticeInfo(notification: notification) else { return }

        autoDismissNotice(id: noticeInfo.id)
    }

    // Cancel Auto Dismiss when pressing the notice
    @objc private func receiveNoticeStartPressing(notification: Notification) {
        guard let noticeInfo = NoticeInfo(notification: notification) else { return }

        cancelAutoDismiss(noticeId: noticeInfo.id)
    }

    // Start Auto Dismiss when end pressing the notice
    @objc private func receiveNoticeEndPressing(notification: Notification) {
        guard let noticeInfo = NoticeInfo(notification: notification) else { return }

        autoDismissNotice(id: noticeInfo.id)
    }
}
