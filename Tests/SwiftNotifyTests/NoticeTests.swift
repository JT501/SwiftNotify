//
//  NoticeTests.swift
//  SwiftNotify
//
//  Created by Johnny Choi on 20/3/2022.
//  Copyright © 2022 Johnny Tsoi@JT501. All rights reserved.
//

import XCTest

@testable import SwiftNotify

class NoticeTests: XCTestCase, NoticeDelegate {

    func noticeDidAppear(notice: Notice) {
        noticeDidAppearIsCalled = true
    }

    func noticeStartDragging(atPoint: CGPoint, notice: Notice) {
    }

    func noticeIsDragging(atPoint: CGPoint, notice: Notice) {
    }

    func noticeEndDragging(atPoint: CGPoint, notice: Notice) {
    }

    func noticeDidDisappear(notice: Notice) {
        noticeDidDisappearIsCalled = true
    }

    func noticeIsTapped(notice: Notice) {
    }


    var sut: Notice!
    var view: UIView!
    var noticeDidAppearIsCalled: Bool!
    var noticeDidDisappearIsCalled: Bool!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        noticeDidAppearIsCalled = false
        view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        sut = Notice(
                view: view,
                duration: .short,
                fromPosition: .top(.center),
                toPosition: .top(),
                tapHandler: nil,
                config: SN.defaultPhysicsConfig,
                delegate: self
        )
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func testGetInitPointWhenFromTopCenter() {
        let window = UIWindow()
        let expect = CGPoint(x: window.bounds.midX, y: -view.bounds.height)

        // When
        let result = sut.getInitPoint(in: window, fromPosition: .top(.center))

        XCTAssertEqual(result, expect)
    }

    func testGetInitPointWhenFromTopLeft() {
        let window = UIWindow()
        let expect = CGPoint(x: -view.bounds.width, y: -view.bounds.height)

        // When
        let result = sut.getInitPoint(in: window, fromPosition: .top(.left))

        XCTAssertEqual(result, expect)
    }

    func testGetInitPointWhenFromTopRight() {
        let window = UIWindow()
        let expect = CGPoint(x: window.bounds.width, y: -view.bounds.height)

        // When
        let result = sut.getInitPoint(in: window, fromPosition: .top(.right))

        XCTAssertEqual(result, expect)
    }

    func testGetInitPointWhenFromTopRandom() {
        let window = UIWindow()
        let expectRange = CGFloat(-view.bounds.width)...CGFloat(window.bounds.width + view.bounds.width)

        // When
        let result = sut.getInitPoint(in: window, fromPosition: .top(.random))

        XCTAssertTrue(expectRange ~= result.x)
        XCTAssertEqual(result.y, -view.bounds.height)
    }

    func testGetInitPointWhenFromBottomCenter() {
        let window = UIWindow()
        let expect = CGPoint(x: window.bounds.midX, y: window.bounds.height)

        // When
        let result = sut.getInitPoint(in: window, fromPosition: .bottom(.center))

        XCTAssertEqual(result, expect)
    }

    func testGetInitPointWhenFromBottomLeft() {
        let window = UIWindow()
        let expect = CGPoint(x: -view.bounds.width, y: window.bounds.height)

        // When
        let result = sut.getInitPoint(in: window, fromPosition: .bottom(.left))

        XCTAssertEqual(result, expect)
    }

    func testGetInitPointWhenFromBottomRight() {
        let window = UIWindow()
        let expect = CGPoint(x: window.bounds.width, y: window.bounds.height)

        // When
        let result = sut.getInitPoint(in: window, fromPosition: .bottom(.right))

        XCTAssertEqual(result, expect)
    }

    func testGetInitPointWhenFromBottomRandom() {
        let window = UIWindow()
        let expectRange = CGFloat(-view.bounds.width)...CGFloat(window.bounds.width + view.bounds.width)

        // When
        let result = sut.getInitPoint(in: window, fromPosition: .bottom(.random))

        XCTAssertTrue(expectRange ~= result.x)
        XCTAssertEqual(result.y, window.bounds.height)
    }

    func testGetInitPointWhenFromLeft() {
        let window = UIWindow()
        let expect = CGPoint(x: -view.bounds.width, y: window.bounds.midY)

        // When
        let result = sut.getInitPoint(in: window, fromPosition: .left)

        XCTAssertEqual(result, expect)
    }

    func testGetInitPointWhenFromRight() {
        let window = UIWindow()
        let expect = CGPoint(x: window.bounds.width, y: window.bounds.midY)

        // When
        let result = sut.getInitPoint(in: window, fromPosition: .right)

        XCTAssertEqual(result, expect)
    }

    func testGetInitPointWhenFromCustom() {
        let window = UIWindow()
        let expect = CGPoint(x: 5, y: 5)

        // When
        let result = sut.getInitPoint(in: window, fromPosition: .custom(expect))

        XCTAssertEqual(result, expect)
    }

    func testGetSnapPointWhenToBottom() {
        let window = UIWindow()
        let expect = CGPoint(x: window.bounds.midX, y: window.bounds.maxY - 50 - sut.containerView.bounds.midY)

        // When
        let result = sut.getSnapPoint(in: window, toPosition: .bottom(offset: 50))

        XCTAssertEqual(result, expect)
    }

    func testGetSnapPointWhenToCenter() {
        let window = UIWindow()
        let expect = window.center

        // When
        let result = sut.getSnapPoint(in: window, toPosition: .center)

        XCTAssertEqual(result, expect)
    }

    func testGetSnapPointWhenToTop() {
        let window = UIWindow()
        let expect = CGPoint(x: window.bounds.midX, y: 70 + sut.containerView.bounds.midY)

        // When
        let result = sut.getSnapPoint(in: window, toPosition: .top(offset: 70))

        XCTAssertEqual(result, expect)
    }

    func testGetSnapPointWhenToCustom() {
        let window = UIWindow()
        let expect = CGPoint(x: 5, y: 5)

        // When
        let result = sut.getSnapPoint(in: window, toPosition: .custom(expect))

        XCTAssertEqual(result, expect)
    }

    func testAddSnapBehaviour() {
        let expectCompletion = expectation(description: "Snap Behaviour Complete")

        // When
        sut.addSnapBehaviour(for: view, toPoint: CGPoint(x: 50, y: 50)) { completed in
            if (completed) {
                expectCompletion.fulfill()
            }
        }

        wait(for: [expectCompletion], timeout: 0.5)

        XCTAssertEqual(sut.snapBehaviour.snapPoint, CGPoint(x: 50, y: 50))
        XCTAssertEqual(sut.snapBehaviour.damping, sut.config.snapDamping)
    }

    func testPresent() {
        let window = UIWindow()
        let recognizers = [sut.panRecognizer, sut.tapRecognizer, sut.longPressRecognizer]
        let expectSnap = expectation(description: "Snap Behaviour Complete")

        // When
        sut.present(in: window) { completed in
            if (completed) { expectSnap.fulfill() }
        }

        XCTAssertEqual(sut.animator.referenceView, window)
        XCTAssertTrue(sut.containerView.subviews.contains(view))
        XCTAssertTrue(Set(recognizers).isSubset(of: Set(sut.containerView.gestureRecognizers!)))
        XCTAssertTrue(window.subviews.contains(sut.containerView))
        XCTAssertTrue(noticeDidAppearIsCalled)

        wait(for: [expectSnap], timeout: 1)
    }

    func testDismiss() {
        let window = UIWindow()
        let expectGravity = expectation(description: "Gravity Behaviour Complete")
        let expectNotification = expectation(forNotification: NoticeNotification.didDisappear, object: nil)
        sut.animator = UIDynamicAnimator(referenceView: window)
        sut.containerView.bounds = view.bounds
        sut.containerView.addSubview(view)
        window.addSubview(sut.containerView)
        sut.animator.addBehavior(UISnapBehavior(item: view, snapTo: CGPoint(x: 0, y: window.bounds.maxY)))
        sut.containerView.addGestureRecognizer(sut.panRecognizer)

        // When
        sut.dismiss { completed in
            if (completed) {
                expectGravity.fulfill()
                expectNotification.fulfill()
            }
        }

        XCTAssertTrue(sut.isHiding)
        XCTAssertTrue(sut.animator.behaviors.contains(sut.gravityBehaviour))
        XCTAssertTrue(sut.containerView.gestureRecognizers!.isEmpty)

        wait(for: [expectGravity, expectNotification], timeout: 1.5)

        XCTAssertTrue(noticeDidDisappearIsCalled)
    }
}
