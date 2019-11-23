//
//  AssistKitFindingIndicator.swift
//  ParkOur
//
//  Created by Yixin Bao on 11/23/19.
//  Copyright © 2019 Yixin Bao. All rights reserved.
//

import Foundation
import UIKit

class AssistKitFindingIndicator: UIView {
    var animatedDash: UIView!
    var iconView: UIImageView!
    var border: CAShapeLayer!
    
    init() {
        super.init(frame: CGRect.zero)
        self.width = UIScreen.main.bounds.width
        self.height = UIScreen.main.bounds.width
        self.backgroundColor = .clear
        iconView = UIImageView(imageName: "RaspberryPiColored", desiredSize: CGSize(width: 100, height: 125.81))!
        self.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
        
        animatedDash = UIView(frame: CGRect(x: (width-250)/2, y: (width-250)/2, width: 250, height: 250))
        animatedDash.layer.cornerRadius = 125
        animatedDash.backgroundColor = .clear
        animatedDash.layer.masksToBounds = true
        self.addSubview(animatedDash)
        
        
        border = CAShapeLayer()
        border.strokeColor = UIColor(hexString: "#C31C4A").cgColor
        border.lineDashPattern = [6, 30]
        border.frame = animatedDash.bounds
        border.fillColor = nil
        border.lineWidth = 52
        border.path = UIBezierPath(roundedRect: animatedDash.bounds, cornerRadius: animatedDash.bounds.width / 2).cgPath
        animatedDash.layer.addSublayer(border)
    }
    
    func startRevolving() {
        let rotation = CASpringAnimation(keyPath: "transform.rotation.z")
        rotation.damping = 30
        rotation.initialVelocity = 3
        rotation.toValue = Double.pi / 4
        rotation.duration = rotation.settlingDuration
        rotation.repeatCount = HUGE
        animatedDash.layer.add(rotation, forKey: "revolving")
    }
    
    func stopRevolving() {
        animatedDash.layer.removeAnimation(forKey: "revolving")
    }
    
    func startThrobbing() {
        let pulseAnimation = CASpringAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 0.6
        pulseAnimation.damping = 20
        pulseAnimation.initialVelocity = 0
        
        pulseAnimation.fromValue = 1
        pulseAnimation.toValue = 1.15
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = HUGE
        animatedDash.layer.add(pulseAnimation, forKey: "throbbing")
        
        let pulseAnimation1 = CASpringAnimation(keyPath: "transform.scale")
        pulseAnimation1.duration = 0.6
        pulseAnimation1.damping = 20
        pulseAnimation1.initialVelocity = 0
        
        pulseAnimation1.fromValue = 1
        pulseAnimation1.toValue = 1.085
        pulseAnimation1.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation1.autoreverses = true
        pulseAnimation1.repeatCount = HUGE
        iconView.layer.add(pulseAnimation1, forKey: "throbbing")
    }
    
    func stopThrobbing() {
        animatedDash.layer.removeAnimation(forKey: "throbbing")
        iconView.layer.removeAnimation(forKey: "throbbing")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        return
    }
}
