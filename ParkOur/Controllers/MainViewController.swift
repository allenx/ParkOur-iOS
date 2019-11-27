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
    var pairView: PairView!
    
    var suggestionCard: ControlCardView!
    var appCard: ControlCardView!
    var assistKitCard: ControlCardView!
    
    private var pullUpView: PullUpView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.removeObject(forKey: Meta.pairedAssistKitKey)
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
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(50)
            make.width.equalTo(300)
            make.height.equalTo(300)
        }
        
        
        dot = UIView(frame: CGRect(x: 20, y: 20, width: 20, height: 20))
        dot.layer.cornerRadius = 10
        dot.backgroundColor = .gray
        label = UILabel(frame: CGRect(x: 20, y: 50, width: 280, height: 200))
        label.numberOfLines = 0
        label.text = "initialized"
        label.textColor = .black
        assistkitIndicator.addSubview(dot)
        
        assistkitIndicator.addSubview(label)
        
        pullUpView = PullUpView()
        print(pullUpView.frame)
        view.addSubview(pullUpView)
        
        
        suggestionCard = ControlCardView(title: "Parking Suggestions")
        suggestionCard.setHeightAccordingToContent()

        appCard = ControlCardView(title: "ParkOur App")
        appCard.setHeightAccordingToContent()
        
        appCard.y += suggestionCard.height + 12
        
        assistKitCard = assembleAssistKitCard()
        assistKitCard.y += suggestionCard.height + 12 + appCard.height + 12
        
        pullUpView.addSubview(suggestionCard)
        pullUpView.addSubview(appCard)
        
        
        pullUpView.addSubview(assistKitCard)
        
        NotificationCenter.default.addObserver(self, selector: #selector(discoverButtonDidTap), name: .initPairingProcess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(connectButtonDidTap), name: .connectToFoundAssistKit, object: nil)
        // Do any additional setup after loading the view.
    }

    
    
    func assembleAssistKitCard() -> ControlCardView {
        let assistKitCard = ControlCardView(title: "ParkOur AssistKit")
        let assistKitCardContentView = AssistKitCardContentView(didPair: AssistKitManager.isPaired())
        assistKitCard.contentView.addSubview(assistKitCardContentView)
        assistKitCard.contentView.height = assistKitCardContentView.height
        assistKitCard.setHeightAccordingToContent()
        
        
        return assistKitCard
    }

}

extension MainViewController: AssistKitManagerDelegate {
    
    func assistKitManagerDidPowerOn(assistKitManager: AssistKitManager) {
        label.text = "Powered On"
        
    }
    
    
    func didDiscoverAssistKit(assistKitManager: AssistKitManager) {
        dot.backgroundColor = .yellow
        label.text = "Discovered AssistKit"
        pairView.didDiscoverAssistKit()
    }
    
    func didConnectToAssistKit(assistKitManager: AssistKitManager) {
        dot.backgroundColor = .green
        label.text = "Connected to AssistKit"
        NotificationCenter.default.post(name: .assistKitPairStateDidChange, object: nil)
        self.assistKitCard.contentView.height = self.assistKitCard.contentView.subviews[0].height
        
        self.assistKitCard.setHeightAccordingToContent()
        self.pairView.dismiss()
    }
    
    func didGetStringFromAssistKit(assistKitManager: AssistKitManager, string: String?) {
        label.text = string
    }
    
    
    func didDisconnectWithAssistKit(assistKitManager: AssistKitManager) {
        
    }
    
    
    
}

extension MainViewController: MKMapViewDelegate {
    
}

extension MainViewController {
    
    
    @objc func discoverButtonDidTap() {
        pairView = PairView()
        self.assistKitManager.discoverAssistKit()
        self.view.addSubview(pairView)
        pairView.y = self.view.height
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 20, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.pairView.y = 126
        }, completion: nil)
    }
    
    @objc func connectButtonDidTap() {
        self.assistKitManager.connectToAssistKit()
    }
}
