//
//  AppInfoCardContentView.swift
//  ParkOur
//
//  Created by Yixin Bao on 12/2/19.
//  Copyright © 2019 Yixin Bao. All rights reserved.
//

import Foundation
import UIKit

class AppInfoCardContentView: CardContentView {
    
    convenience init(parkedCarWhereabouts: String, carName: String) {
        self.init()
        
        let parkedCarContainerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 40))
        parkedCarContainerView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(parkedCarContainerViewTapped))
        parkedCarContainerView.addGestureRecognizer(tap)
        addSubview(parkedCarContainerView)
        
        let parkedCarIconView = UIImageView(imageName: "parkedCarIcon", desiredSize: CGSize(width: 40, height: 40))!
        parkedCarIconView.x = 0
        parkedCarIconView.y = 0
        parkedCarIconView.width = 40
        parkedCarIconView.height = 40
        parkedCarContainerView.addSubview(parkedCarIconView)
        
        let parkedCarTitleLabel = UILabel(text: "My Parked Car", color: .black)
        parkedCarTitleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        parkedCarTitleLabel.x = parkedCarIconView.x + parkedCarIconView.width + 6
        parkedCarTitleLabel.y = 0
        parkedCarContainerView.addSubview(parkedCarTitleLabel)
        
        let whereaboutsLabel = UILabel(text: parkedCarWhereabouts, color: UIColor(hexString: "#818181"))
        whereaboutsLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        whereaboutsLabel.x = parkedCarTitleLabel.x
        whereaboutsLabel.y = parkedCarTitleLabel.y + parkedCarTitleLabel.height
        parkedCarContainerView.addSubview(whereaboutsLabel)
        
        

        
        let myCarContainerView = UIView(frame: CGRect.zero)
        myCarContainerView.x = 0
        myCarContainerView.y = parkedCarContainerView.y+parkedCarContainerView.height+15
        myCarContainerView.width = width
        myCarContainerView.isUserInteractionEnabled = true
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(setCarModel))
        myCarContainerView.addGestureRecognizer(tap1)
        addSubview(myCarContainerView)
        
        
        let lineTop = UIView(color: UIColor(hexString: "#BFBFBF"))
        lineTop.width = width
        lineTop.height = 1
        lineTop.x = 0
        lineTop.y = 0
        myCarContainerView.addSubview(lineTop)
        
        let myCarLabel = UILabel(text: "My Car", color: .black)
        myCarLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        myCarContainerView.addSubview(myCarLabel)
        myCarLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(myCarContainerView)
            make.left.equalTo(myCarContainerView)
        }
        
        let carNameLabel = UILabel(text: carName, color: UIColor(hexString: "#747474"))
        carNameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        myCarContainerView.addSubview(carNameLabel)
        carNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(myCarContainerView)
            make.right.equalTo(myCarContainerView)
        }
        
        myCarContainerView.height = myCarLabel.height + 20
        
        let lineBottom = UIView(color: UIColor(hexString: "#BFBFBF"))
        lineBottom.width = width
        lineBottom.height = 1
        lineBottom.x = 0
        lineBottom.y = myCarContainerView.height - 1
        myCarContainerView.addSubview(lineBottom)
        
        height = parkedCarContainerView.height + 15 + myCarContainerView.height
    }
    
    
    @objc func parkedCarContainerViewTapped() {
        print("parkedCarContainerViewTapped()")
        NotificationCenter.default.post(name: .findParkedCar, object: nil)
    }
    
    @objc func setCarModel() {
        print("setCarModel()")
    }
}
