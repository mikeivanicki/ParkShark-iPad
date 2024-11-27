//
//  AlertsDetailViewController.swift
//  iPad Screens
//
//  Created by Student on 11/5/24.
//



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
    
    private func refreshUI() {
        loadViewIfNeeded()
        /*
        print(selectedAlert!.effDate)
        print(selectedAlert!.endDate!)
        
        if let effDateAsDate: Date = dateFormatterGet.date(from: selectedAlert!.effDate) {
            print("eff date ========= \(effDateAsDate)")
            startDate.text = dateFormatterPrint.string(from: effDateAsDate)
        }
        if let endDateAsDate: Date = dateFormatterGet.date(from: selectedAlert!.endDate!) {
            print("end date ========= \(endDateAsDate)")
            endDate.text = dateFormatterPrint.string(from: endDateAsDate)
        }
         */
        
        startDate.text = selectedAlert?.effDate
        endDate.text = selectedAlert?.endDate
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



