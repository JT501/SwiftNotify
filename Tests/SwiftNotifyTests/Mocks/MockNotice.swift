//
// Created by Johnny Choi on 16/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//
import UIKit

@testable import SwiftNotify

class MockNotice: NSObject, NoticeProtocol {
    // Method Counter
    var presentCounter: Int = 0
    var presentCompletion: (() -> Void)?
    var dismissCounter: Int = 0
    var dismissCompletion: (() -> Void)?

    var id: String
    var isDismissing: Bool
    var duration: Duration

    func present(in window: UIWindow?, completion: @escaping (Bool) -> Void) {
        presentCounter += 1
        completion(true)
        presentCompletion?()
    }

    func dismiss(completion: CompletionCallBack? = nil) {
        dismissCounter += 1
        completion?(true)
        dismissCompletion?()
    }

    init(
            id: String = UUID().uuidString,
            isHiding: Bool = false,
            duration: Duration = .short
    ) {
        self.id = id
        self.isDismissing = isHiding
        self.duration = duration
    }
}
