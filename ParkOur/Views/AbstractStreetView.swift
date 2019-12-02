//
//  AbstractStreetView.swift
//  ParkOur
//
//  Created by Yixin Bao on 12/2/19.
//  Copyright © 2019 Yixin Bao. All rights reserved.
//

import Foundation
import UIKit

class AbstractStreetView: UIView {
    
    private let occupiedColor = UIColor(hexString: "#EA910B")
    private let availbleColor = UIColor(hexString: "#73D671")
    
    var spots: [Int] = []
    
    init() {
        super.init(frame: CGRect.zero)
        x = 0
        y = 0
        width = UIScreen.main.bounds.width - 90
        
    }
    
    func refresh(refreshedSpots: [Int]) {
        spots = refreshedSpots
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
