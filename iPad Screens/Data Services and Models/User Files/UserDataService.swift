//
//  UserDataService.swift
//  ParkShark
//
//  Created by Andrew J. McGovern on 3/2/24.
//

import Foundation

class UserDataService {
    
    let API_URL = "https://api.parkshark.mobi:443/users"
    let encoder = JSONEncoder()
    let userModel = UserModel.sharedUserModel
   
    static let sharedInstance = UserDataService()
    private init () {}
    
    func loginAttempt(email: String, password: String, _ completionHandler: @escaping (_ status: Bool, Error?) -> ()) {
        
        let loginRequest = LoginRequest(email: email, password: password)
        print(loginRequest)
        
        let requestURL: URL = URL(string: "\(API_URL)/validateLogin")!
        var urlRequest: URLRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("*/*", forHTTPHeaderField: "Accept")
        do {
            encoder.outputFormatting = .prettyPrinted
            urlRequest.httpBody = try encoder.encode(loginRequest)
            print(String(data: urlRequest.httpBody!, encoding: .utf8)!)
            
        } catch let error {
            print(error.localizedDescription)
            completionHandler(false, error)
        }
        
        let session = URLSession.shared
        let start = Date()
        
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (httpData, response, error) -> Void in
            
            guard error == nil else {
                completionHandler(false, error)
                return
            }
            guard let httpData = httpData else {
                completionHandler(false, NSError(domain: "dataNilError", code: -100001))
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("HTTP response 200, file downloaded successfully.")
                let userResponse = LoginResponse(data: httpData)
                self.userModel.user = userResponse?.user
                let diff = Date().timeIntervalSince(start)
                print("Elapsed time: \(diff) seconds")
                print(self.userModel.user as Any)
                completionHandler(true, nil)
            } else {
                print("HTTP errror: \(statusCode)")
                print(httpResponse)
                completionHandler(false, error)
            }
        })
        task.resume()
    }
    
    
    func fetchUserData(userID: Int, _ completionHandler: @escaping (_ status: Bool, Error?) -> ()) {
        
        let requestURL: URL = URL(string: "\(API_URL)/getUser/\(userID)")!
        var urlRequest: URLRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = "GET"
        
        let session = URLSession.shared
        let start = Date()
        
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (httpData, response, error) -> Void in
            
            guard error == nil else {
                completionHandler(false, error)
                return
            }
            guard let httpData = httpData else {
                completionHandler(false, NSError(domain: "dataNilError", code: -100001))
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("HTTP response 200, file downloaded successfully.")
                self.userModel.user = User(data: httpData)
                let diff = Date().timeIntervalSince(start)
                print("Elapsed time: \(diff) seconds")
                print(self.userModel.user as Any)
                completionHandler(true, nil)
            } else {
                print("HTTP errror: \(statusCode)")
                print(error?.localizedDescription as Any)
                completionHandler(false, error)
            }
        })
        task.resume()
    }
}
