//
//  AssistKitCardContentView.swift
//  ParkOur
//
//  Created by Yixin Bao on 11/22/19.
//  Copyright © 2019 Yixin Bao. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


class AssistKitCardContentView: CardContentView {
    
    private let connectButtonMeta = (width: CGFloat(245), height: CGFloat(50), cornerRadius: CGFloat(25), backgroundColor: UIColor(hexString: "#c31c4a"))

    private let connectionToggleMeta = ToggleMeta(width: 86, height: 94, cornerRadius: 12, backgroundColorOn: UIColor(hexString: "#c31c4a"), backgroundColorOff: UIColor(hexString: "#858585"), titleString: "AssistKit", statusOnString: "Connected", statusOffString: "Disconnected")
    private let cloudToggleMeta = ToggleMeta(width: 86, height: 94, cornerRadius: 12, backgroundColorOn: UIColor(hexString: "#46D981"), backgroundColorOff: UIColor(hexString: "#858585"), titleString: "To Cloud", statusOnString: "On", statusOffString: "Off")

    
    convenience init(didPair: Bool) {
        self.init()
        
        if !didPair {
            assembleConnectPrompt()
        } else {
            assembleAssistKitControls()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(assistKitPairStateDidChange), name: .assistKitPairStateDidChange, object: nil)
    }
    
    func assembleConnectPrompt() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        let connectButton = UIButton(frame: CGRect(x: (width-connectButtonMeta.width)/2, y: 0, width: connectButtonMeta.width, height: connectButtonMeta.height))
        connectButton.layer.cornerRadius = connectButtonMeta.cornerRadius
        connectButton.backgroundColor = connectButtonMeta.backgroundColor
        connectButton.setTitle("Connect to an AssistKit", for: .normal)
        connectButton.titleLabel?.textColor = .white
        connectButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        
        connectButton.addTarget(self, action: #selector(connectButtonDidTap), for: .touchUpInside)
        
        self.addSubview(connectButton)
        height = connectButtonMeta.height
    }
    
    @objc func connectButtonDidTap() {
        NotificationCenter.default.post(name: .initPairingProcess, object: nil)
    }
    
    func assembleAssistKitControls() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        let connectionToggle = assembleConnectionToggle()
        let cloudToggle = assembleCloudToggle()
        
        connectionToggle.x = 0
        connectionToggle.y = 0
        
        cloudToggle.x = 100
        cloudToggle.y = 0
        
        self.addSubview(connectionToggle)
        self.addSubview(cloudToggle)
        
        self.height = connectionToggle.height
    }
    
    func assembleConnectionToggle() -> Toggle {
        let connectionToggle = Toggle(meta: connectionToggleMeta)
        
        let raspberryPiIcon = UIImageView.init(imageName: "RaspberryPiWhite", desiredSize: CGSize(width: 26, height: 32.71))!
        connectionToggle.addSubview(raspberryPiIcon)
        raspberryPiIcon.snp.makeConstraints { make in
            make.centerX.equalTo(connectionToggle)
            make.top.equalTo(connectionToggle.snp.top).offset(12)
        }
        
        let statusLabel = UILabel(text: connectionToggle.statusOnString, color: .white)
        statusLabel.font = .systemFont(ofSize: 12, weight: .bold)
        connectionToggle.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.centerX.equalTo(connectionToggle)
            make.bottom.equalTo(connectionToggle.snp.bottom).offset(-10)
        }
        
        let titleLabel = UILabel(text: connectionToggle.titleString, color: .white)
        titleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        connectionToggle.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(connectionToggle)
            make.bottom.equalTo(statusLabel.snp.top).offset(-5)
        }
        
        return connectionToggle
    }
    
    
    func assembleCloudToggle() -> Toggle {
        let cloudToggle = Toggle(meta: cloudToggleMeta)
        
        let cloudIcon = UIImageView.init(imageName: "ToCloud", desiredSize: CGSize(width: 34, height: 34))!
        cloudToggle.addSubview(cloudIcon)
        cloudIcon.snp.makeConstraints { make in
            make.centerX.equalTo(cloudToggle)
            make.top.equalTo(cloudToggle.snp.top).offset(12)
        }
        
        let statusLabel = UILabel(text: cloudToggle.statusOnString, color: .white)
        statusLabel.font = .systemFont(ofSize: 12, weight: .bold)
        cloudToggle.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.centerX.equalTo(cloudToggle)
            make.bottom.equalTo(cloudToggle.snp.bottom).offset(-10)
        }
        
        let titleLabel = UILabel(text: cloudToggle.titleString, color: .white)
        titleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        cloudToggle.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(cloudToggle)
            make.bottom.equalTo(statusLabel.snp.top).offset(-5)
        }

        return cloudToggle
    }
    
    @objc func assistKitPairStateDidChange() {
        if AssistKitManager.isPaired() {
            assembleAssistKitControls()
        } else {
            assembleConnectPrompt()
        }
    }
    
}

