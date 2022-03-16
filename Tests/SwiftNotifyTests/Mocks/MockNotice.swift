//
// Created by Johnny Choi on 16/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

@testable import SwiftNotify

class MockNotice: NoticeProtocol {

    // Method Counter
    var presentCounter: Int = 0
    var dismissCounter: Int = 0

    var id: String
    var isHiding: Bool
    var duration: DurationsEnum

    func present(completion: @escaping (Bool) -> Void) {
        presentCounter += 1
    }

    func dismiss() {
        dismissCounter += 1
    }

    init(
            id: String = UUID().uuidString,
            isHiding: Bool = false,
            duration: DurationsEnum = .short
    ) {
        self.id = id
        self.isHiding = isHiding
        self.duration = duration
    }
}
