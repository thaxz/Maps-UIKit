//
//  ViewController.swift
//  MapsUIKit
//
//  Created by thaxz on 24/08/23.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    var locationManager: CLLocationManager?

    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    lazy var searchTextField: UITextField = {
       let txtfield = UITextField()
        txtfield.layer.cornerRadius = 10
        txtfield.clipsToBounds = true
        txtfield.backgroundColor = .white
        txtfield.placeholder = "Search"
        txtfield.textColor = .black
        // padding
        txtfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        txtfield.leftViewMode = .always
        txtfield.translatesAutoresizingMaskIntoConstraints = false
        return txtfield
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocation()
        setupUI()
        setupConstraints()
    }


    func setupUI(){
        searchTextField.returnKeyType = .go
        view.addSubview(mapView)
        view.addSubview(searchTextField)
    }
    
    func setupConstraints(){
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        searchTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchTextField.widthAnchor.constraint(equalToConstant: view.bounds.size.width/1.2).isActive = true
        searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        
    }
    
    func setupLocation(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
    }
    
    private func checkLocationAuthorization(){
        guard let locationManager = locationManager,
              let location = locationManager.location else {return}
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            createRegion(center: location.coordinate)
        case .denied:
            print("")
        case .notDetermined, .restricted:
            print("")
        default:
            print("")
        }
        
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func createRegion(center: CLLocationCoordinate2D){
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 750, longitudinalMeters: 750)
        mapView.setRegion(region, animated: true)
    }
    
    // when the location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    // when there's an error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    // if the authorization has changed
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    
}

