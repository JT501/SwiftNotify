//
//  NoticeManagerTests.swift
//  SwiftNotify
//
//  Created by Johnny Choi on 15/3/2022.
//  Copyright © 2022 Johnny Tsoi@JT501. All rights reserved.
//

import XCTest

@testable import SwiftNotify

class NoticeManagerTests: XCTestCase {

    var sut: NoticeManager!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = NoticeManager(queue: DispatchQueue(label: "com.jt501.SwiftNotify.test"))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func testAddPendingNotice() {
        let notice = MockNotice()

        sut.addPendingNotice(notice)

        XCTAssertEqual(sut.pendingNotices.count, 1)
        XCTAssertTrue(sut.pendingNotices.contains(where: { $0.id == notice.id }))
        XCTAssertEqual(sut.currentNotices.count, 1)
        XCTAssertTrue(sut.currentNotices.contains(where: { $0.id == notice.id }))
    }

    func testRemovePendingNotice() {
        let notice = MockNotice()
        sut.unsafeCurrentNotices = [notice]

        sut.removePendingNotice(notice)

        XCTAssertEqual(sut.pendingNotices.count, 0)
        XCTAssertTrue(!sut.pendingNotices.contains(where: { $0.id == notice.id }))
    }

    func testRemoveAllPendingNotices() {
        let notice = MockNotice()
        let notice2 = MockNotice()

        sut.unsafePendingNotices = [notice, notice2]

        sut.removeAllPendingNotices()

        XCTAssertEqual(sut.pendingNotices.count, 0)
        XCTAssertTrue(!sut.pendingNotices.contains(where: { $0.id == notice.id || $0.id == notice2.id }))
    }

    func testShowNotice() {
        let notice = MockNotice()
        let addedToCurrent = expectation(description: "Add to current notices complete")
        let noticePresent = expectation(description: "Notice present complete")
        sut.unsafePendingNotices = [notice]

        notice.presentCompletion = {
            noticePresent.fulfill()
        }
        sut.showNotice(completion: { addedToCurrent.fulfill() })

        XCTAssertEqual(sut.pendingNotices.count, 0)
        XCTAssertEqual(sut.currentNotices.count, 1)
        XCTAssertTrue(sut.currentNotices.contains(where: { $0.id == notice.id }))

        wait(for: [addedToCurrent, noticePresent], timeout: 1)

        XCTAssertEqual(notice.presentCounter, 1)

        XCTAssertEqual(sut.autoDismissTasks.count, 1)
        XCTAssertTrue(sut.autoDismissTasks.contains { $0.key == notice.id })
    }

    func testDismissNotice() {
        let notice = MockNotice()
        let expectDismiss = expectation(description: "Notice Dismiss")

        notice.dismissCompletion = { expectDismiss.fulfill() }
        sut.unsafeCurrentNotices = [notice]

        sut.dismissNotice(byId: notice.id)

        wait(for: [expectDismiss], timeout: 1)

        XCTAssertEqual(notice.dismissCounter, 1)
        XCTAssertEqual(sut.autoDismissTasks.count, 0)
    }

    func testDismissNoticeWhenIsHiding() {
        let notice = MockNotice(isHiding: true)
        let expectDismiss = expectation(description: "Notice Dismiss")
        expectDismiss.isInverted = true

        notice.dismissCompletion = { expectDismiss.fulfill() }
        sut.unsafeCurrentNotices = [notice]

        wait(for: [expectDismiss], timeout: 0.1)

        XCTAssertEqual(sut.autoDismissTasks.count, 0)
    }

    func testAutoDismissNoticeWhenDurationIsForever() {
        let notice = MockNotice(duration: .forever)

        sut.autoDismissNotice(id: notice.id)

        XCTAssertEqual(sut.autoDismissTasks.count, 0)
    }

    func testAutoDismissNoticeWhenDurationIsShort() {
        let notice = MockNotice(duration: .short)
        let duration: TimeInterval = 2
        let expectDismiss = expectation(description: "Notice Dismiss")
        notice.dismissCompletion = { expectDismiss.fulfill() }
        sut.unsafeCurrentNotices = [notice]

        sut.autoDismissNotice(id: notice.id)

        XCTAssertEqual(sut.autoDismissTasks.count, 1)

        wait(for: [expectDismiss], timeout: duration + 0.1)

        XCTAssertEqual(sut.autoDismissTasks.count, 0)
        XCTAssertEqual(notice.dismissCounter, 1)
    }

    func testAutoDismissNoticeWhenDurationIsLong() {
        let notice = MockNotice(duration: .long)
        let duration: TimeInterval = 4
        let expectDismiss = expectation(description: "Notice Dismiss")
        notice.dismissCompletion = { expectDismiss.fulfill() }
        sut.unsafeCurrentNotices = [notice]

        sut.autoDismissNotice(id: notice.id)

        XCTAssertEqual(sut.autoDismissTasks.count, 1)

        wait(for: [expectDismiss], timeout: duration + 0.1)

        XCTAssertEqual(sut.autoDismissTasks.count, 0)
        XCTAssertEqual(notice.dismissCounter, 1)
    }

    func testAutoDismissNoticeWhenDurationIsCustom() {
        let notice = MockNotice(duration: .custom(duration: DispatchTimeInterval.seconds(1)))
        let duration: TimeInterval = 1
        let expectDismiss = expectation(description: "Notice Dismiss")
        notice.dismissCompletion = { expectDismiss.fulfill() }
        sut.unsafeCurrentNotices = [notice]

        sut.autoDismissNotice(id: notice.id)

        XCTAssertEqual(sut.autoDismissTasks.count, 1)

        wait(for: [expectDismiss], timeout: duration + 0.1)

        XCTAssertEqual(sut.autoDismissTasks.count, 0)
        XCTAssertEqual(notice.dismissCounter, 1)
    }

    func testAutoDismissNoticeWhenNoticeNotExistsInCurrentQueue() {
        let notice = MockNotice(duration: .custom(duration: .milliseconds(500)))
        let duration: TimeInterval = 0.5
        let expectDismiss = expectation(description: "Notice Dismiss")
        expectDismiss.isInverted = true

        notice.dismissCompletion = { expectDismiss.fulfill() }

        sut.autoDismissNotice(id: notice.id)

        wait(for: [expectDismiss], timeout: duration + 0.1)
    }

    func testAutoDismissNoticeWhenAutoDismissTaskAlreadyExists() {
        let notice = MockNotice(duration: .custom(duration: .milliseconds(500)))
        let duration: TimeInterval = 0.5
        let task = DispatchWorkItem {}
        let expectDismiss = expectation(description: "Notice Dismiss")
        expectDismiss.isInverted = true

        notice.dismissCompletion = { expectDismiss.fulfill() }
        sut.unsafeCurrentNotices = [notice]
        sut.autoDismissTasks[notice.id] = task

        sut.autoDismissNotice(id: notice.id)

        wait(for: [expectDismiss], timeout: duration + 0.1)
    }

    func testCancelAutoDismiss() {
        let notice = MockNotice()
        let task = DispatchWorkItem {}
        sut.autoDismissTasks[notice.id] = task

        sut.cancelAutoDismiss(noticeId: notice.id)

        XCTAssertTrue(task.isCancelled)
        XCTAssertEqual(sut.autoDismissTasks.count, 0)
    }

    func testDismissCurrentNotices() {
        let notice = MockNotice()
        let notice2 = MockNotice()
        let task = DispatchWorkItem {}
        let task2 = DispatchWorkItem {}
        let expectDismiss = expectation(description: "Notice Dismiss")
        let expectDismiss2 = expectation(description: "Notice2 Dismiss")

        notice.dismissCompletion = { expectDismiss.fulfill() }
        notice2.dismissCompletion = { expectDismiss2.fulfill() }
        sut.unsafeCurrentNotices = [notice, notice2]
        sut.autoDismissTasks = [notice.id: task, notice2.id: task2]

        sut.dismissCurrentNotices()

        wait(for: [expectDismiss, expectDismiss2], timeout: 0.1)

        XCTAssertEqual(notice.dismissCounter, 1)
        XCTAssertEqual(notice2.dismissCounter, 1)
        XCTAssertEqual(sut.autoDismissTasks.count, 0)
    }

    func testDismissCurrentNoticesWhenCurrentNoticesIsEmpty() {
        let notice = MockNotice()
        let notice2 = MockNotice()
        let expectDismiss = expectation(description: "Notice Dismiss")
        expectDismiss.isInverted = true
        let expectDismiss2 = expectation(description: "Notice2 Dismiss")
        expectDismiss2.isInverted = true

        notice.dismissCompletion = { expectDismiss.fulfill() }
        notice2.dismissCompletion = { expectDismiss2.fulfill() }
        sut.unsafeCurrentNotices = []

        sut.dismissCurrentNotices()

        wait(for: [expectDismiss, expectDismiss2], timeout: 0.1)
    }

    func testDismissCurrentNoticesWhenNoticesIsHiding() {
        let notice = MockNotice(isHiding: true)
        let notice2 = MockNotice()
        let task2 = DispatchWorkItem {}
        let expectDismiss = expectation(description: "Notice Dismiss")
        expectDismiss.isInverted = true
        let expectDismiss2 = expectation(description: "Notice2 Dismiss")

        notice.dismissCompletion = { expectDismiss.fulfill() }
        notice2.dismissCompletion = { expectDismiss2.fulfill() }
        sut.unsafeCurrentNotices = [notice, notice2]
        sut.autoDismissTasks = [notice2.id: task2]

        sut.dismissCurrentNotices()

        wait(for: [expectDismiss, expectDismiss2], timeout: 0.1)

        XCTAssertEqual(notice.dismissCounter, 0)
        XCTAssertEqual(notice2.dismissCounter, 1)
        XCTAssertEqual(sut.autoDismissTasks.count, 0)
    }

    func testReceiveNoticeDidDisappearNotification() {
        let notice = MockNotice()
        let userInfo = [NoticeInfo.userInfoKey: NoticeInfo(id: notice.id)]
        let notification = Notification(
                name: NoticeNotification.didDisappear,
                userInfo: userInfo)
        sut.unsafeCurrentNotices = [notice]

        NotificationCenter.default.post(notification)

        XCTAssertEqual(sut.currentNotices.count, 0)
    }

    func testReceiveNoticeEndPanningNotDismissNotification() {
        let notice = MockNotice()
        let userInfo = [NoticeInfo.userInfoKey: NoticeInfo(id: notice.id)]
        let notification = Notification(
                name: NoticeNotification.endPanningNotDismiss,
                userInfo: userInfo)
        sut.unsafeCurrentNotices = [notice]

        NotificationCenter.default.post(notification)

        // Assert Auto Dismiss Notice method is called
        XCTAssertTrue(sut.autoDismissTasks[notice.id] != nil)
    }

    func testReceiveNoticeStartPressingNotification() {
        let notice = MockNotice()
        let task = DispatchWorkItem {}
        let userInfo = [NoticeInfo.userInfoKey: NoticeInfo(id: notice.id)]
        let notification = Notification(
                name: NoticeNotification.startPressing,
                userInfo: userInfo)
        sut.unsafeCurrentNotices = [notice]
        sut.autoDismissTasks[notice.id] = task

        NotificationCenter.default.post(notification)

        // Assert Cancel Auto Dismiss method is called
        XCTAssertTrue(task.isCancelled)
        XCTAssertTrue(sut.autoDismissTasks.isEmpty)
    }

    func testReceiveNoticeEndPressingNotification() {
        let notice = MockNotice()
        let userInfo = [NoticeInfo.userInfoKey: NoticeInfo(id: notice.id)]
        let notification = Notification(
                name: NoticeNotification.endPressing,
                userInfo: userInfo)
        sut.unsafeCurrentNotices = [notice]

        NotificationCenter.default.post(notification)

        // Assert Auto Dismiss Notice method is called
        XCTAssertTrue(sut.autoDismissTasks[notice.id] != nil)
    }
}
