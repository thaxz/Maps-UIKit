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
        // registering cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PlaceCell")
        self.places.swapAt(indexAtSelectedRow ?? 0, 0)
    }
    
    private var indexAtSelectedRow: Int? {
        // the first one that is true
        self.places.firstIndex(where: {$0.isSelected == true})
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    
    private func calculateDistance(from: CLLocation, to: CLLocation) -> CLLocationDistance {
        from.distance(from: to)
    }
    
    private func formatDistance(_ distance: CLLocationDistance) -> String{
        let meters = Measurement(value: distance, unit: UnitLength.meters)
        return meters.formatted()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
        let place = places[indexPath.row]
        // cell configuration
        var content = cell.defaultContentConfiguration()
        content.text = place.name
        content.secondaryText = formatDistance(calculateDistance(from: userLocation, to: place.location))
        cell.contentConfiguration = content
        cell.backgroundColor = place.isSelected ? UIColor.lightGray.withAlphaComponent(0.5) : .clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // getting the selected place
        let place = places[indexPath.row]
        let placeDetailViewController = PlaceDetailViewController(place: place)
        present(placeDetailViewController, animated: true)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
