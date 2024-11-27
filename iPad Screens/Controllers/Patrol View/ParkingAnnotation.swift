//
//  ParkingAnnotation.swift
//  ParkShark
//
//  Created by Andrew J. McGovern on 3/28/24.
//

import Foundation
import MapKit

class ParkingAnnotation: NSObject, MKAnnotation {
    
    dynamic var coordinate: CLLocationCoordinate2D
    dynamic var title: String?
    dynamic var subtitle: String?
    var status: Int  //occupied, empty, illegal, ticketed
    var spot_id: Int
    //var is_handicap: Int
    var row_id: String
    var lot_id: Int
    
//    var license_plate: String?
//    var color: String?
//    var detectedID: Int
    
    
    
    init(coordinate: CLLocationCoordinate2D, title: String? = nil, subtitle: String? = nil, status: Int, lot_id: Int, row_id: String, spot_id: Int
//         license_plate: String?, color: String?, detectedID: Int
    ) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.status = status
        self.spot_id = spot_id
        //self.is_handicap = is_handicap
        self.row_id = row_id
        self.lot_id = lot_id
        
//        self.license_plate = license_plate
//                self.color = color
//        self.detectedID = detectedID
    }
    
    
}
