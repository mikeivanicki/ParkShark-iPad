//
//  AlertsDetailViewController.swift
//  iPad Screens
//
//  Created by Student on 11/5/24.
//

//test for new remote

import UIKit
import Foundation

class AlertsDetailViewController: UIViewController{
    
    let dateFormatterGet = ISO8601DateFormatter()
    let dateFormatterPrint = DateFormatter()

    var selectedAlert: Alert? {
        didSet {
            refreshUI()
        }
    }
    
    let alertsDS = AlertsDataService.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedAlert = alertsDS.alertResponse.alerts.first
        
        dateFormatterPrint.dateFormat = "MMM d, yyyy, h:mm a"
        dateFormatterPrint.locale = Locale.current
        
    }
    
    func formatDateString(_ input: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        

        guard let date = inputFormatter.date(from: input) else { return nil }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        outputFormatter.timeStyle = .short
        outputFormatter.locale = Locale.current
        
       
        return outputFormatter.string(from: date)
    }

    
    private func refreshUI() {
        loadViewIfNeeded()
        
        startDate.text = formatDateString(selectedAlert!.effDate)
        endDate.text = formatDateString(selectedAlert!.endDate!)
        postedBy.text = String(selectedAlert?.userID ?? 0)
        taskDescription.text = selectedAlert?.message
    }

    @IBOutlet weak var taskDescription: UITextView!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var postedBy: UILabel!
    
}

extension AlertsDetailViewController: AlertSelectionDelegate {
    func alertSelected(selectedAlert alert: Alert) {
        print ("Alert selected: \(alert)")
        self.selectedAlert = alert
    }
}



