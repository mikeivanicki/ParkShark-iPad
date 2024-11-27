//
//  TabBarController.swift
//  iPad Screens
//
//  Created by Michael Ivanicki on 11/22/24.
//

import UIKit

class TabBarController: UITabBarController, UISplitViewControllerDelegate {

    let alertsDS = AlertsDataService.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let splitViewController:UISplitViewController? = self.viewControllers![3] as? UISplitViewController

        let navigationController = splitViewController!.viewControllers[splitViewController!.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController!.displayModeButtonItem
        splitViewController!.delegate = self
        
        let detailViewController = (splitViewController?.viewControllers.last as? UINavigationController)?.topViewController as? AlertsDetailViewController
        let leftNavController = splitViewController?.viewControllers.first as? UINavigationController
        let masterViewController = leftNavController?.viewControllers.first as? AlertsTableViewController
        masterViewController?.detailDelegate = detailViewController
        
        fetchAlerts()
        //let firstAlert = alertsDS.alertResponse.alerts.first!
        //detailViewController?.selectedAlert = firstAlert
        
        //detailDelegate?.alertSelected(selectedAlert: firstAlert)
        
        //detailViewController?.selectedAlert = alertsDS.alertResponse.alerts.first
        
    }
    
    func fetchAlerts() {
    alertsDS.fetchAlerts() {
        result in
        if result {
            DispatchQueue.main.async {
                print("loading alert info")
                
            }
        }
    }
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
