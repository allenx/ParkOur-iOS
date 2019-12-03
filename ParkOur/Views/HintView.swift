//
//  HintView.swift
//  ParkOur
//
//  Created by Yixin Bao on 12/2/19.
//  Copyright © 2019 Yixin Bao. All rights reserved.
//

import Foundation
import UIKit

class HintView: UIView {
    init(content: String) {
        super.init(frame: CGRect.zero)
        
        width = UIScreen.main.bounds.width - 50
        height = 94
        x = 25
        y = 90
        layer.cornerRadius = 12
        layer.backgroundColor = UIColor(hexString: "#86CCFF").cgColor
        backgroundColor = UIColor(hexString: "#86CCFF")
        
        let contentLabel = UILabel(text: content, color: .white)
        contentLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .center
        
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }
        
        let cancelButton = UIButton(backgroundImageName: "cancelButton", desiredSize: CGSize(width: 18, height: 18))!
        cancelButton.addTarget(self, action: #selector(hintViewDismiss), for: .touchUpInside)
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(6)
            make.right.equalTo(self).offset(-6)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func hintViewDismiss() {
        print("hintViewDismiss()")
    }
}
