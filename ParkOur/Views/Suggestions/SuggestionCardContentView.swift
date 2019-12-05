//
//  SuggestionCardContentView.swift
//  ParkOur
//
//  Created by Yixin Bao on 12/2/19.
//  Copyright © 2019 Yixin Bao. All rights reserved.
//

import Foundation
import UIKit

class SuggestionCardContentView: CardContentView {
    
    var abstractStreetView: AbstractStreetView!
    var suggestionLabel: UILabel!
    var whereaboutsLabel: UILabel!
    
    convenience init(whereabouts: String, spots: [Bool]) {
        self.init()
        
        abstractStreetView = AbstractStreetView(spots: spots)
        addSubview(abstractStreetView)
        abstractStreetView.animate()
        let sum = spots.reduce(0) { (x, y) -> Int in
            if y {
                return x
            } else {
                return x+1
            }
        }
        
        suggestionLabel = UILabel(text: "\(sum-1) potential empty spots for your car", color: UIColor(hexString: "#464646"))
        suggestionLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        suggestionLabel.x = 0
        suggestionLabel.y = abstractStreetView.y + abstractStreetView.height + 10
        addSubview(suggestionLabel)
        
        whereaboutsLabel = UILabel(text: whereabouts, color: UIColor(hexString: "#919191"))
        whereaboutsLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        whereaboutsLabel.x = 0
        whereaboutsLabel.y = suggestionLabel.y + suggestionLabel.height
        addSubview(whereaboutsLabel)
        
        height = abstractStreetView.height + 10 + suggestionLabel.height + whereaboutsLabel.height
        
    }
    

}
