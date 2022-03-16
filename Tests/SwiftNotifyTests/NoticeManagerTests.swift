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
        sut.addPendingNotice(notice)

        sut.removePendingNotice(notice)

        XCTAssertEqual(sut.pendingNotices.count, 0)
        XCTAssertTrue(!sut.pendingNotices.contains(where: { $0.id == notice.id }))
    }

    func testRemoveAllPendingNotices() {
        let notice = MockNotice()
        let notice2 = MockNotice()

        sut.addPendingNotice(notice)
        sut.addPendingNotice(notice2)

        sut.removeAllPendingNotices()

        XCTAssertEqual(sut.pendingNotices.count, 0)
        XCTAssertTrue(!sut.pendingNotices.contains(where: { $0.id == notice.id || $0.id == notice2.id }))
    }

    func testShowNotice() {
        let notice = MockNotice()
        let expectation = expectation(description: "Present Notice")
        sut.addPendingNotice(notice)

        sut.showNotice(completion: {
            expectation.fulfill()
        })

        XCTAssertEqual(sut.pendingNotices.count, 0)
        XCTAssertEqual(sut.currentNotices.count, 1)
        XCTAssertTrue(sut.currentNotices.contains(where: { $0.id == notice.id }))

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(notice.presentCounter, 1)
    }

    func testShowNext() {
        let notice = MockNotice()

    }
}
