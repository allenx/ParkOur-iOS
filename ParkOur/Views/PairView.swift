//
//  PairView.swift
//  ParkOur
//
//  Created by Yixin Bao on 11/22/19.
//  Copyright © 2019 Yixin Bao. All rights reserved.
//

import Foundation
import UIKit

class PairView: UIView {
    
    private var scanningLabel: UILabel!
    private var foundLabel: UILabel!
    private var cancelButton: UIButton!
    private var findingIndicator: AssistKitFindingIndicator!
    private var connectButton: UIButton!
    
    
    init() {
        super.init(frame: CGRect.zero)
        self.x = 0
        self.y = 126
        self.layer.cornerRadius = 40
        self.width = UIScreen.main.bounds.width
        self.height = 900
        self.backgroundColor = UIColor(hexString: "#f3f3f3")
        
        let pullUpHandle = UIView(color: UIColor(hexString: "#c4c4c4"))
        pullUpHandle.frame = CGRect(x: (self.width-40)/2, y: 10, width: 40, height: 4)
        pullUpHandle.layer.cornerRadius = 2
        self.addSubview(pullUpHandle)
        
        
        
        self.isUserInteractionEnabled = true
        
        findingIndicator = AssistKitFindingIndicator()
        findingIndicator.y = (UIScreen.main.bounds.height-findingIndicator.height)/2 - 126
        self.addSubview(findingIndicator)
        
        findingIndicator.startRevolving()
        
        scanningLabel = UILabel(text: "Scanning for AssistKit", color: UIColor(hexString: "#464646"))
        scanningLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        
        self.addSubview(scanningLabel)
        scanningLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(findingIndicator.snp.bottom).offset(-20)
        }
        
        foundLabel = UILabel(text: "ParkOur AssistKit Found", color: UIColor(hexString: "#464646"))
        foundLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        foundLabel.alpha = 0
        foundLabel.height = 30
        foundLabel.sizeToFit()
        foundLabel.x = (UIScreen.main.bounds.width-foundLabel.width)/2
        foundLabel.y = findingIndicator.y + findingIndicator.height + 25
        
        self.addSubview(foundLabel)

        connectButton = UIButton(frame: CGRect(x: (width-205)/2, y: foundLabel.y+foundLabel.height+90, width: 205, height: 60))
        connectButton.layer.cornerRadius = 30
        connectButton.backgroundColor = UIColor(hexString: "#C31C4A")
        connectButton.setTitle("CONNECT", for: .normal)
        connectButton.titleLabel?.textColor = .white
        connectButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        connectButton.alpha = 0
        self.addSubview(connectButton)
        
        cancelButton = UIButton(backgroundImageName: "cancelButton", desiredSize: CGSize(width: 32, height: 32))

        self.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-20)
            make.top.equalTo(self).offset(20)
        }
        cancelButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        
        Timer.scheduledTimer(withTimeInterval: 3.5, repeats: false) { (_) in
            self.didDiscoverAssistKit()
        }
    }
    
    func didDiscoverAssistKit() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 20, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.scanningLabel.alpha = 0
            self.findingIndicator.stopRevolving()
            self.findingIndicator.startThrobbing()
        }) { (_) in
            self.scanningLabel.removeFromSuperview()
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 20, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.findingIndicator.y = 20
                self.foundLabel.alpha = 1
                self.foundLabel.y = 20+self.findingIndicator.height
                self.connectButton.alpha = 1
                self.connectButton.y = self.foundLabel.y+self.foundLabel.height+50
                
            }) { (_) in
                
            }
            
        }
        
        
    }
    
    @objc func dismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 20, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.y = UIScreen.main.bounds.height
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
