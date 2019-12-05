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
    
    private let spotWidth: CGFloat = 25
    private let spotHeight: CGFloat = 4
    private let spaceBetweenSpots: CGFloat = 5
    
    var spots: [Bool] = []
    var spotViews: [UIView] = []
    
    
    init(spots: [Bool]) {
        super.init(frame: CGRect.zero)
        x = 0
        y = 0
        width = UIScreen.main.bounds.width - 90
        height = spotHeight + 4
        
        self.spots = spots
        self.spots = [false, true, false, false, true, true, false]
        
        var idx: CGFloat = 0
        spots.forEach { (available) in
            let spotView = UIView()
            spotView.width = spotWidth
            spotView.height = spotHeight
            spotView.x = idx * (spotWidth + spaceBetweenSpots)
            spotView.y = 4
            spotView.layer.cornerRadius = 2
            idx += 1
            if available {
                spotView.layer.backgroundColor = availbleColor.cgColor
            } else {
                spotView.layer.backgroundColor = occupiedColor.cgColor
            }
            spotViews.append(spotView)
            addSubview(spotView)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(animateAgain))
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
    }
    
    func refresh(refreshedSpots: [Bool]) {
        spots = refreshedSpots
        
        
    }
    
    func animate() {
        let bounce = CASpringAnimation(keyPath: "transform.translation.y")
        bounce.damping = 20
        bounce.initialVelocity = 3
        bounce.fromValue = 0
        bounce.toValue = -4
        bounce.duration = 0.85
        bounce.repeatCount = HUGE
        spotViews[1].layer.add(bounce, forKey: "bouncing")
    }
    
    @objc func animateAgain() {
        let bounce = CASpringAnimation(keyPath: "transform.translation.y")
        bounce.damping = 20
        bounce.initialVelocity = 3
        bounce.fromValue = 0
        bounce.toValue = -4
        bounce.duration = 0.85
        bounce.repeatCount = HUGE
        
        spotViews[1].layer.removeAnimation(forKey: "bouncing")
        spotViews[2].layer.add(bounce, forKey: "bouncing")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
