//
//  LoginViewController.swift
//  iPad Screens
//
//  Created by Student on 11/16/24.
//

import UIKit


class LoginViewController: UIViewController {
    
    let myUserDataService = UserDataService.sharedInstance
    let myUserModel = UserModel.sharedUserModel
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        emailField.text = "officer1@monmouth.edu"
        passwordField.text = "officerpassword"
        super.viewDidLoad()
        
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tabBarVC = segue.destination as? UITabBarController {
            NotificationCenter.default.post(name: .tabBarControllerDidAppear, object: tabBarVC)
        }
    }
     */
    
    @IBAction func loginButton(_ sender: Any) {
        print ("Login Presssed")
        myUserDataService.loginAttempt(email: self.emailField.text!, password: self.passwordField.text!) {
            result, error in
            if result {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Login Failure", message: "\(error?.localizedDescription ?? "Login Error.")", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
extension Notification.Name {
    static let tabBarControllerDidAppear = Notification.Name("tabBarControllerDidAppear")
}
