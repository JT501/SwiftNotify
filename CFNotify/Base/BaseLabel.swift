//
//  BaseLabel.swift
//  CFNotify
//
//  Created by Johnny Choi on 18/11/2016.
//  Copyright © 2016 Johnny Choi@Co-Fire. All rights reserved.
//

import UIKit

open class BaseLabel: UILabel {
    
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
