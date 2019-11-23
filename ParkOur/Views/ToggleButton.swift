//
//  ToggleButton.swift
//  ParkOur
//
//  Created by Yixin Bao on 11/23/19.
//  Copyright © 2019 Yixin Bao. All rights reserved.
//

import Foundation
import UIKit

struct ToggleMeta {
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    let backgroundColorOn: UIColor
    let backgroundColorOff: UIColor
    let titleString: String
    let statusOnString: String
    let statusOffString: String
}

enum ToggleState {
    case on
    case off
}

class Toggle: UIButton {
    
    var toggleState: ToggleState!
    var titleString: String!
    var statusOnString: String!
    var statusOffString: String!
    
    var backgroundColorOn: UIColor!
    var backgroundColorOff: UIColor!
    
    convenience init(meta: ToggleMeta) {
        self.init()
        width = meta.width
        height = meta.height
        layer.cornerRadius = meta.cornerRadius
        backgroundColor = meta.backgroundColorOn
        
        titleString = meta.titleString
        statusOnString = meta.statusOnString
        statusOffString = meta.statusOffString
        
        backgroundColorOn = meta.backgroundColorOn
        backgroundColorOff = meta.backgroundColorOff
        
    }
    
    
}
