//
//  MainViewController.swift
//  ParkOur
//
//  Created by Yixin Bao on 11/13/19.
//  Copyright © 2019 Yixin Bao. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

class MainViewController: UIViewController {
    
    private var assistKitManager: AssistKitManager!
    var dot: UIView!
    var label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assistKitManager = AssistKitManager()
        assistKitManager.delegate = self
        
        view.backgroundColor = .white
        let mapView = MKMapView(frame: view.frame)
        view.addSubview(mapView)
        
        mapView.delegate = self

        let assistkitIndicator = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        assistkitIndicator.backgroundColor = .white
        
        assistkitIndicator.layer.cornerRadius = 12
        view.addSubview(assistkitIndicator)
        assistkitIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(100)
        }
        
        
        dot = UIView(frame: CGRect(x: 20, y: 20, width: 20, height: 20))
        dot.layer.cornerRadius = 10
        dot.backgroundColor = .gray
        label = UILabel(frame: CGRect(x: 20, y: 50, width: 280, height: 40))
        label.text = "initialized"
        label.textColor = .black
        assistkitIndicator.addSubview(dot)
        
        assistkitIndicator.addSubview(label)
        
        let pullUpView = PullUpView()
        print(pullUpView.frame)
        view.addSubview(pullUpView)
        
        
        let suggestionCard = ControlCardView(title: "Parking Suggestions")
        suggestionCard.setHeightAccordingToContent()

        let appCard = ControlCardView(title: "ParkOur App")
        appCard.setHeightAccordingToContent()
        
        appCard.y += suggestionCard.height + 12
        
        let assistKitCard = ControlCardView(title: "ParkOur AssistKit")
        assistKitCard.setHeightAccordingToContent()
        assistKitCard.y += suggestionCard.height + 12 + appCard.height + 12
        
        pullUpView.addSubview(suggestionCard)
        pullUpView.addSubview(appCard)
        pullUpView.addSubview(assistKitCard)
        
        
        // Do any additional setup after loading the view.
    }


}

extension MainViewController: AssistKitManagerDelegate {
    func assistKitManagerDidPowerOn(assistKitManager: AssistKitManager) {
        label.text = "Powered On"
    }
    
    
    func didDiscoverAssistKit(assistKitManager: AssistKitManager) {
        dot.backgroundColor = .yellow
        label.text = "Discovered AssistKit"
    }
    
    func didConnectToAssistKit(assistKitManager: AssistKitManager) {
        dot.backgroundColor = .green
        label.text = "Connected to AssistKit"
    }
    
    func didDisconnectWithAssistKit(assistKitManager: AssistKitManager) {
        
    }
    
    
}

extension MainViewController: MKMapViewDelegate {
    
}
