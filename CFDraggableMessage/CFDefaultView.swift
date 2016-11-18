//
//  CFDefaultView.swift
//  CFDraggableMessage
//
//  Created by Johnny Choi on 18/11/2016.
//  Copyright © 2016 Johnny Choi@Co-Fire. All rights reserved.
//

import UIKit

open class CFDefaultView: NSObject {
    
    public static func createSimpleView(text: String) -> SimpleView {
        return SimpleView.init(text: text)
    }
    
}
