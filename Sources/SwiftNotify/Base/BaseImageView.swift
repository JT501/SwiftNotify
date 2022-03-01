//
//  BaseImageView.swift
//  SwiftNotify
//
//  Created by Johnny Tsoi on 18/11/2016.
//  Copyright © 2022 Johnny Tsoi@JT501. All rights reserved.
//

import UIKit

open class BaseImageView: UIImageView {
    
    var onDidSetHidden: ((Bool) -> ())?
    var onWillSetHidden: ((Bool) -> ())?
    
    override open var isHidden: Bool {
        didSet {
            if let block = onDidSetHidden {
                block(self.isHidden)
            }
        }
        
        willSet (willBeHidden) {
            if let block = onWillSetHidden {
                block(willBeHidden)
            }
        }
    }
}
