//
//  PlacesTableViewController.swift
//  MapsUIKit
//
//  Created by thaxz on 26/08/23.
//

import UIKit
import Foundation
import MapKit

class PlacesTableViewController: UITableViewController {
    
    var userLocation: CLLocation
    var places: [PlaceAnnotation]
    
    init(userLocation: CLLocation, places: [PlaceAnnotation]){
        self.userLocation = userLocation
        self.places = places
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
