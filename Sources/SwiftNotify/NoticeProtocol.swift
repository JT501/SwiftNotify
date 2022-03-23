//
// Created by Johnny Choi on 23/3/2022.
// Copyright (c) 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

public typealias CompletionCallBack = (_ completed: Bool) -> Void

/// All Notice Object Conform to this protocol
public protocol NoticeProtocol: NSObject {

    /// A unique notice Id.
    var id: String { get }

    /// State of notice if it starts dismissing process or not.
    var isDismissing: Bool { get }

    /// The duration notice will stay on screen. It will be auto dismissed when the duration passed.
    var duration: DurationsEnum { get }

    /// Present the notice in the window
    ///
    /// - Parameters:
    ///   - window: The `UIWindow` which the notice will be presented in.
    ///   - completion: ``CompletionCallBack`` when the notice completed the present process.
    func present(in window: UIWindow?, completion: @escaping CompletionCallBack)

    /// Dismiss the notice if it is currently presented
    ///
    /// - Parameter completion: ``CompletionCallBack`` when the notice completed the dismiss process.
    func dismiss(completion: CompletionCallBack?)
}