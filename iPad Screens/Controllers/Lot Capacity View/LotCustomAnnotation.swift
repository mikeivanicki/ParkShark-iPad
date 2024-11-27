//
//  LotCustomAnnotation.swift
//  iPad Testing
//
//  Created by Michael Ivanicki on 10/16/24.
//

import Foundation
import MapKit

class LotCustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, name: String?, occupancy: String?) {
        self.coordinate = coordinate
        self.title = name
        self.subtitle = occupancy
    }
}


