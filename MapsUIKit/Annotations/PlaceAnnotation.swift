//
//  PlaceAnnotation.swift
//  MapsUIKit
//
//  Created by thaxz on 26/08/23.
//

import Foundation
import MapKit

class PlaceAnnotation: MKPointAnnotation {
    
    let mapItem: MKMapItem
    let id = UUID()
    var isSelected: Bool = false
    
    init(mapItem: MKMapItem){
        self.mapItem = mapItem
        super.init()
        self.coordinate = mapItem.placemark.coordinate
    }
    
    var name: String {
        mapItem.name ?? ""
    }
    var phone: String {
        mapItem.phoneNumber ?? ""
    }
    var location: CLLocation {
        mapItem.placemark.location ?? CLLocation.default
    }
    
}
