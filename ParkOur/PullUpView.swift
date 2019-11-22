//
//  PullUpView.swift
//  ParkOur
//
//  Created by Yixin Bao on 11/21/19.
//  Copyright © 2019 Yixin Bao. All rights reserved.
//

import Foundation
import UIKit


class PullUpView: UIView {
    
    var panBeginLocation: CGPoint!
    
    init() {
        super.init(frame: CGRect.zero)
        self.x = 0
        self.y = 126
        self.layer.cornerRadius = 40
        self.width = UIScreen.main.bounds.width
        self.height = 756
        self.backgroundColor = UIColor(hexString: "#f3f3f3")
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 18
        self.layer.shadowOffset = CGSize(width: 0, height: -4)
        self.layer.shadowOpacity = 0.3
        
        let pullUpHandle = UIView(color: UIColor(hexString: "#c4c4c4"))
        pullUpHandle.frame = CGRect(x: (self.width-40)/2, y: 10, width: 40, height: 4)
        pullUpHandle.layer.cornerRadius = 2
        self.addSubview(pullUpHandle)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(panGesture:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePan(panGesture: UIPanGestureRecognizer) {
        if panGesture.state == .began {
            panBeginLocation = panGesture.location(in: self)
        }
        
        let newLoc = panGesture.location(in: self)
        let deltaY = newLoc.y - panBeginLocation.y
        
        self.y += deltaY
        
        
    }
    
    @objc func swipeUp(swipeGesture: UISwipeGestureRecognizer) {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
