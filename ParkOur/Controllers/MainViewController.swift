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

struct AvailablePath {
    let beginning: CLLocationCoordinate2D
    let end: CLLocationCoordinate2D
}

class MainViewController: UIViewController {
    
    private var assistKitManager: AssistKitManager!
    var dot: UIView!
    var label: UILabel!
    var pairView: PairView!
    
    var mapView: MKMapView!
    
    var searchBar: UISearchBar!
    
    var suggestionCard: ControlCardView!
    var appCard: ControlCardView!
    var assistKitCard: ControlCardView!
    
    var locationManager: CLLocationManager!
    
    let regionRadius: CLLocationDistance = 100
    
    var didStartToGetBeginningOfSpots = false
    var currentBeginning: CLLocationCoordinate2D!
    var currentEnd: CLLocationCoordinate2D!
    var availablePaths: [AvailablePath] = []
    
    
    private var pullUpView: PullUpView!
    
    private var currentLocation: CLLocation!
    private var mostRecentPlacemark: CLPlacemark!
    private var lastGeocodeTime: Date!
    
    let geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaults.standard.removeObject(forKey: Meta.pairedAssistKitKey)
        assistKitManager = AssistKitManager()
        assistKitManager.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        hideKeyboardWhenTappedAround()
        
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
        
        assembleSearchBar()
        
        let hintView = HintView(content: "Pair with ParkOur AssistKit to help detect free empty spots on the street while driving")
        pullUpView.addSubview(hintView)
        
        suggestionCard = assembleSuggestionCard()
        
        appCard = assembleAppInfoCard()
        appCard.y += suggestionCard.height + 12
        
        assistKitCard = assembleAssistKitCard()
        assistKitCard.y += suggestionCard.height + 12 + appCard.height + 12
        
        pullUpView.addSubview(suggestionCard)
        pullUpView.addSubview(appCard)
        
        
        pullUpView.addSubview(assistKitCard)
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(discoverButtonDidTap), name: .initPairingProcess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(connectButtonDidTap), name: .connectToFoundAssistKit, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(findParkedCar), name: .findParkedCar, object: nil)
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
    
    func assembleSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: 25, y: 25, width: view.width - 50, height: 44))
        searchBar.searchBarStyle = .minimal
//        searchBar.searchTextField.backgroundColor = UIColor(hexString: "#E6E6E6")
        
        searchBar.layer.cornerRadius = 22
        searchBar.clipsToBounds = true
        searchBar.backgroundColor = UIColor(hexString: "#E6E6E6")
        searchBar.searchTextField.borderStyle = .none
        
        searchBar.delegate = self
        searchBar.placeholder = "Search for a place or address"
        
        pullUpView.addSubview(searchBar)
    }
    
    func assembleAssistKitCard() -> ControlCardView {
        let assistKitCard = ControlCardView(title: "ParkOur AssistKit")
        let assistKitCardContentView = AssistKitCardContentView(didPair: AssistKitManager.isPaired())

        assistKitCard.addContentView(cardContentView: assistKitCardContentView)
        
        return assistKitCard
    }
    
    func assembleSuggestionCard() -> ControlCardView {
        let card = ControlCardView(title: "Parking Suggestions")
        let fooSpots = [false, true, false, false, true, true, false]
        
        
        
//        let whereabouts = mostRecentPlacemark.name
        let whereabouts = "777 Middlefield Rd."
        
        let contentView = SuggestionCardContentView(whereabouts: whereabouts ?? "Nil", spots: fooSpots)
        card.addContentView(cardContentView: contentView)
        
        return card
    }
    
    func assembleAppInfoCard() -> ControlCardView {
        let card = ControlCardView(title: "ParkOur App")
        
        let whereabouts = "3.7km away. Near Moffett Blvd."
        let myCarName = "Honda Civic"
        
        let contentView = AppInfoCardContentView(parkedCarWhereabouts: whereabouts, carName: myCarName)
        card.addContentView(cardContentView: contentView)
        
        return card
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
        if dict!["available"] as! Int == 0 || dict!["available"] as! Int == 1 {
            print("should drop pin")
            dropPinAtCurrentPlace(code: dict!["available"] as! Int)
        }
    }
    
    
    func didDisconnectWithAssistKit(assistKitManager: AssistKitManager) {
        
    }
    
    
    
}

extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let newLocation = userLocation.location else { return }
        
        let currentTime = Date()
        let lastLocation = self.currentLocation
        self.currentLocation = newLocation
        
        // Only get new placemark information if you don't have a previous location,
        // if the user has moved a meaningful distance from the previous location, such as 1000 meters,
        // and if it's been 60 seconds since the last geocode request.
        if let lastLocation = lastLocation,
            newLocation.distance(from: lastLocation) <= 1000,
            let lastTime = lastGeocodeTime,
            currentTime.timeIntervalSince(lastTime) < 60 {
            return
        }
        
        // Convert the user's location to a user-friendly place name by reverse geocoding the location.
        lastGeocodeTime = currentTime
        geocoder.reverseGeocodeLocation(newLocation) { (placemarks, error) in
            guard error == nil else {
                return
            }
            
            // Most geocoding requests contain only one result.
            if let firstPlacemark = placemarks?.first {
                self.mostRecentPlacemark = firstPlacemark
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let lineRenderer = MKPolylineRenderer(overlay: overlay)
            lineRenderer.strokeColor = UIColor(hexString: "#73D671")
            lineRenderer.lineWidth = 4
            
            return lineRenderer
        }
        
        return MKOverlayRenderer()
    }
    
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("holy")
        print(status.rawValue)
        switch status {
        case .authorizedAlways:
            print("1")
            manager.startUpdatingLocation()
            manager.startUpdatingHeading()
        //            locateToUserLocation()
        case .authorizedWhenInUse:
            print("2")
            manager.startUpdatingLocation()
            manager.startUpdatingHeading()
        //            locateToUserLocation()
        case .denied:
            print("omg")
        default:
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locateToLocation(location: location)
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
            make.right.equalTo(self.view).offset(-8)
        }
    }
    
    @objc func locateToUserLocation() {
        let userLoc = mapView.userLocation
        if userLoc.coordinate.latitude == 0 && userLoc.coordinate.longitude == 0 {
            checkAuthorizationStatus()
        } else {
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
    
    func dropPinAtCurrentPlace(code: Int) {
        
        guard let loc = locationManager.location else {
            return
        }

        print("got new loc")
        switch code {
        case 0:
            currentBeginning = loc.coordinate
            didStartToGetBeginningOfSpots = true
        case 1:
            if !didStartToGetBeginningOfSpots {
                return
            }
            currentEnd = loc.coordinate
            let path = AvailablePath(beginning: currentBeginning, end: currentEnd)
            availablePaths.append(path)
            drawLine(path: path)
            
        default:
            return
        }
    }
    
    func drawLine(path: AvailablePath) {
        let locations = [path.beginning, path.end]
        let line = MKPolyline(coordinates: locations, count: 2)
        mapView.addOverlay(line)
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
    
    @objc func findParkedCar() {
        
    }
}


extension MainViewController: UISearchBarDelegate {
    func mapKitSearchRequest(text: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { (response, _) in
            guard let response = response else {
                return
            }
            print(response.mapItems)
            self.pullUpView.moveDown()
            self.mapView.setRegion(response.boundingRegion, animated: true)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        pullUpView.moveUp()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let str = searchBar.text else {
            return
        }
        mapKitSearchRequest(text: str)
        searchBar.searchTextField.resignFirstResponder()
    }
}
