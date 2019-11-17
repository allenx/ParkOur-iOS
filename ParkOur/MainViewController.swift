//
//  MainViewController.swift
//  ParkOur
//
//  Created by Yixin Bao on 11/13/19.
//  Copyright © 2019 Yixin Bao. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UIViewController {
    
    private let assistKitManager = AssistKitManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MKMapView(frame: view.frame)
        view.addSubview(mapView)
        
        mapView.delegate = self

        
        // Do any additional setup after loading the view.
    }


}

extension MainViewController: AssistKitManagerDelegate {
    func didDiscoverAssistKit(assistKitManager: AssistKitManager) {
        
    }
    
    func didConnectToAssistKit(assistKitManager: AssistKitManager) {
        
    }
    
    func didDisconnectWithAssistKit(assistKitManager: AssistKitManager) {
        
    }
    
    
}

extension MainViewController: MKMapViewDelegate {
    
}
