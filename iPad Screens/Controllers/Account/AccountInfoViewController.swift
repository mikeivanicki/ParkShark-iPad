//
//  AccountInfoViewController.swift
//  iPad Screens
//
//  Created by Gianna Rao on 10/9/24. 
// 

import UIKit

class AccountInfoViewController: UIViewController {


    let myUserDataService = UserDataService.sharedInstance
    let myUserModel = UserModel.sharedUserModel
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var tagID: UILabel!
    @IBOutlet weak var vehicleColor: UILabel!
    @IBOutlet weak var vehicleMake: UILabel!
    @IBOutlet weak var licensePlate: UILabel!
    @IBOutlet weak var vehicleModel: UILabel!
    @IBOutlet weak var vehicleYear: UILabel!
            
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAccount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchAccount()
    }
    
    func fetchAccount() {
        myUserDataService.fetchUserData(userID: myUserModel.user!.user_id) {
            result, error in
            if result {
                DispatchQueue.main.async {
                    self.loadUserInfo()
                    print("loading user info")
                }
            }
        }
    }
    
    func loadUserInfo() {
        self.name.text = "\(myUserModel.user!.first_name) \(myUserModel.user!.last_name)"
        self.email.text = myUserModel.user!.email
        self.tagID.text = "\(myUserModel.user!.tag_id!)"
        self.vehicleColor.text = myUserModel.user!.vehicle_color
        self.vehicleMake.text = myUserModel.user!.vehicle_make
        self.licensePlate.text = myUserModel.user!.license_plate
        self.vehicleModel.text = myUserModel.user!.vehicle_model
        self.vehicleYear.text = "\(myUserModel.user!.vehicle_year)"
    }

}
