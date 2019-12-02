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
import SFSafeSymbols

class MainViewController: UIViewController {
    
    private var assistKitManager: AssistKitManager!
    var dot: UIView!
    var label: UILabel!
    var pairView: PairView!
    
    var mapView: MKMapView!
    
    var suggestionCard: ControlCardView!
    var appCard: ControlCardView!
    var assistKitCard: ControlCardView!
    
    var locationManager: CLLocationManager!
    
    let regionRadius: CLLocationDistance = 100
    
    private var pullUpView: PullUpView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.removeObject(forKey: Meta.pairedAssistKitKey)
        assistKitManager = AssistKitManager()
        assistKitManager.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        view.backgroundColor = .white
        mapView = MKMapView(frame: view.frame)
        mapView.showsUserLocation = true
        view.addSubview(mapView)
        
        mapView.delegate = self
        
        checkAuthorizationStatus()
        
        assembleIndicatorView(debug: false)
        
        
        assembleMapControls()
        
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
    
    func assembleIndicatorView(debug: Bool) {
        let assistkitIndicator = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        if !debug {
            assistkitIndicator.alpha = 0
        }
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
        let dict = try! string!.data(using: .utf8)?.toDictionary()
        if dict!["available"] as! Int == 0 {
            print("should drop pin")
            dropPinAtCurrentPlace()
        }
    }
    
    
    func didDisconnectWithAssistKit(assistKitManager: AssistKitManager) {
        
    }
    
    
    
}

extension MainViewController: MKMapViewDelegate {
    //    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    //        print(userLocation.location!.coordinate)
    //        locateToLocation(location: userLocation.location!)
    //    }
    
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("holy")
        print(status.rawValue)
        switch status {
        case .authorizedAlways:
            print("1")
        //            locateToUserLocation()
        case .authorizedWhenInUse:
            print("2")
        //            locateToUserLocation()
        case .denied:
            print("omg")
        default:
            return
        }
    }
}

extension MainViewController {
    func assembleMapControls() {
        let locationImage = UIImage(systemSymbol: .location)
        let locationFillImage = UIImage(systemSymbol: .locationFill)
        
        let locateButton = UIButton()
        locateButton.addTarget(self, action: #selector(locateToUserLocation), for: .touchUpInside)
        locateButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        locateButton.imageEdgeInsets = .init(top: -4, left: -4, bottom: -4, right: -4)
        locateButton.backgroundColor = .white
        locateButton.layer.cornerRadius = 8
        locateButton.layer.shadowColor = UIColor.gray.cgColor
        locateButton.layer.shadowOpacity = 0.5
        locateButton.layer.shadowOffset = .zero
        locateButton.setImage(locationImage, for: .normal)
        locateButton.setImage(locationFillImage, for: .highlighted)
        self.view.addSubview(locateButton)
        locateButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(100)
            make.right.equalTo(self.view).offset(-24)
        }
    }
    
    @objc func locateToUserLocation() {
        let userLoc = mapView.userLocation
        if userLoc.coordinate.latitude == 0 && userLoc.coordinate.longitude == 0 {
            print("what?")
            checkAuthorizationStatus()
        } else {
            print("holy1")
            let cl = CLLocation(latitude: userLoc.coordinate.latitude, longitude: userLoc.coordinate.longitude)
            locateToLocation(location: cl)
        }
        
    }
    
    @objc func locateToLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius*2, longitudinalMeters: regionRadius*2)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func checkAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() != .authorizedAlways || CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func dropPinAtCurrentPlace() {
        let loc = mapView.userLocation
        let annotation = MKPointAnnotation()
        annotation.coordinate = loc.coordinate
        annotation.title = "new loc"
        print("holy shit")
        mapView.addAnnotation(annotation)
    }
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
