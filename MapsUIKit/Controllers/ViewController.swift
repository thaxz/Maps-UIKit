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
    private var places: [PlaceAnnotation] = []

    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        map.delegate = self
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
        txtfield.delegate = self
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
    
    func presentPlacesSheet(places: [PlaceAnnotation]){
        guard let locationManager = locationManager,
              let userLocation = locationManager.location else {return}
        
        let placesTableViewController = PlacesTableViewController(userLocation: userLocation, places: places)
        placesTableViewController.modalPresentationStyle = .pageSheet
        if let sheet = placesTableViewController.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            present(placesTableViewController, animated: true)
        }
    }
    
    private func checkLocationAuthorization(){
        guard let locationManager = locationManager,
              let location = locationManager.location else {return}
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            createRegion(center: location.coordinate)
        case .denied:
            print("Location denied")
        case .notDetermined, .restricted:
            print("Location restricted")
        default:
            print("error")
        }
        
    }
    
}

// MARK: Textfield delegate

extension ViewController: UITextFieldDelegate {
    
    // When the return key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // ensuring there's a text
        let text = textField.text ?? ""
        if !text.isEmpty {
            textField.resignFirstResponder()
            // search nearby places
            findNearbyPlaces(by: text)
        }
       return true
    }
    
}

// MARK: Map delegates

extension ViewController: MKMapViewDelegate {
    
    // when a annotation is selected
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        guard let selectionAnnotation = annotation as? PlaceAnnotation else {return}
        // the first one that the id matches
        let placeAnnotation = self.places.first(where: {$0.id == selectionAnnotation.id})
        placeAnnotation?.isSelected = true
        presentPlacesSheet(places: self.places)
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func findNearbyPlaces(by query: String){
        // Cleaning any other annotation
        mapView.removeAnnotations(mapView.annotations)
        // Making a request
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let response = response, error == nil else {return}
            // transforming all the responses in PlaceAnnotation
            self?.places = response.mapItems.map(PlaceAnnotation.init)
            self?.places.forEach { places in
                self?.mapView.addAnnotation(places)
            }
            if let places = self?.places {
                self?.presentPlacesSheet(places: places)
            }
        }
    }
    
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

