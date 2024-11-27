//
//  RedSpot.swift
//  iPad Screens
//
//  Created by Student on 11/20/24.
//

import UIKit

class RedSpotViewController: UIViewController {
    
    var lot: Int?
    var row: String?
    var spot: Int?
 
    @IBOutlet weak var lotNumber: UILabel!
    @IBOutlet weak var rowNumber: UILabel!
    @IBOutlet weak var spotNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Red Spot"
        
        if let spot = spot {
            spotNumber.text = "\(spot)"
        }
        if let lot = lot {
            lotNumber.text = "\(lot)"
        }
        if let row = row {
            rowNumber.text = row
        }
    }
    
}
