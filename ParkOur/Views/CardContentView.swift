//
//  CardContentView.swift
//  ParkOur
//
//  Created by Yixin Bao on 11/22/19.
//  Copyright © 2019 Yixin Bao. All rights reserved.
//

import Foundation
import UIKit

class CardContentView: UIView {
    
    private let sidePadding: CGFloat = 20
    
    init() {
        super.init(frame: CGRect.zero)
        x = 20
        y = 0
        width = UIScreen.main.bounds.width - 90
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
