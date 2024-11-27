//
//  GreenSpot.swift
//  iPad Screens
//
//  Created by Student on 11/20/24.
//

import UIKit

class GreenSpotViewController: UIViewController {
    
    var lot: Int?
    var row: String?
    var spot: Int?
    
    @IBOutlet weak var lotNumber: UILabel!
    @IBOutlet weak var rowNumber: UILabel!
    @IBOutlet weak var spotNumber: UILabel!
    @IBOutlet weak var detectedID: UILabel!
    @IBOutlet weak var licensePlate: UILabel!
    @IBOutlet weak var color: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Green Spot"
        
        if let spot = spot {
            spotNumber.text = "\(spot)"
        }
        if let lot = lot {
            lotNumber.text = "\(lot)"
        }
        if let row = row {
            rowNumber.text = row
        }
        
        //        if let licensePlate = licensePlate {
        //                    licensePlate.text = "License Plate: \(licensePlate)"
        //                }
        //
        //                if let detectedID = detectedID {
        //                    detectedID.text = "Tag ID: \(detectedID)"
        //                }
        //
        //                if let color = color {
        //                    color.text = "Color: \(color)"
        //                }
        //            }
    }
    
    
}
