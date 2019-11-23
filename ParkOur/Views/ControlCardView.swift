//
//  ControlCardView.swift
//  ParkOur
//
//  Created by Yixin Bao on 11/14/19.
//  Copyright © 2019 Yixin Bao. All rights reserved.
//

import Foundation
import UIKit



class ControlCardView: UIView {
    
    open var contentView: UIView!
    private let sidePadding: CGFloat = 20
    private let topBottomPadding: CGFloat = 14
    
    convenience init(title: String) {
        self.init()
        backgroundColor = .white
        layer.cornerRadius = 12
        width = UIScreen.main.bounds.width - 50
        x = 25
        y = 40
        height = 50
        
        let titleLabel = UILabel(text: title)
        titleLabel.font = .systemFont(ofSize: 18, weight: .heavy)
        titleLabel.sizeToFit()
        titleLabel.textColor = .black
        titleLabel.x = 20
        titleLabel.y = 14
        addSubview(titleLabel)
        
        contentView = UIView(frame: CGRect(x: 0, y: 50, width: width, height: 0))
        addSubview(contentView)
    }
    
    func setHeightAccordingToContent() {
        self.height += contentView.height + topBottomPadding
    }
}
