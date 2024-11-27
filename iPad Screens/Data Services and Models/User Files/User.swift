//
//  User.swift
//  ParkShark
//
//  Created by Andrew J. McGovern on 12/2/23.
//

import UIKit

struct LoginRequest: Codable {
    var email: String
    var password: String
}

struct LoginResponse: Codable {
    let user: User
    let token: String
    let tokenExpiry: String
    
    init?(data: Data) {
        do {
           let login_response = try JSONDecoder().decode(LoginResponse.self, from: data)
            self.user = login_response.user
            self.token = login_response.token
            self.tokenExpiry = login_response.tokenExpiry
        } catch {
            print("Error with LoginResponse json: \(error)")
            return nil
        }
    }
}


struct Credential: Codable {
    let id: Int
    let user_id: Int
    let email: String
    let password: String
    
    init (int id: Int, user_id: Int, email: String, password: String) {
        self.user_id = user_id
        self.id = id
        self.email = email
        self.password = password
    }
    
     init? (data: Data) {
         do {
            let credential_info = try JSONDecoder().decode(Credential.self, from: data)
             self.user_id = credential_info.user_id
             self.id = credential_info.id
             self.email = credential_info.email
             self.password = credential_info.password
         } catch {
             print("Error with Credential json: \(error)")
             return nil
         }
     }
}

struct User: Codable {
    let user_id: Int
    let vehicle_make: String
    let vehicle_model: String
    let vehicle_year: Int
    let vehicle_color: String
    let license_plate: String
    let tag_id: Int?
    let first_name: String
    let last_name: String
    let user_type: String
    let email: String?
    
    init (user_id: Int, vehicle_make: String, vehicle_model: String, vehicle_year: Int, vehicle_color: String, license_plate: String, tag_id: Int?, first_name: String, last_name: String, user_type: String, email: String?) {
        self.user_id = user_id
        self.vehicle_make = vehicle_make
        self.vehicle_model = vehicle_model
        self.vehicle_year = vehicle_year
        self.vehicle_color =  vehicle_color
        self.license_plate = license_plate
        self.tag_id = tag_id
        self.first_name = first_name
        self.last_name = last_name
        self.user_type = user_type
        self.email = email
    }
    
     init? (data: Data) {
         do {
            let user_info = try JSONDecoder().decode(User.self, from: data)
             self.user_id = user_info.user_id
             self.vehicle_make = user_info.vehicle_make
             self.vehicle_model = user_info.vehicle_model
             self.vehicle_year = user_info.vehicle_year
             self.vehicle_color =  user_info.vehicle_color
             self.license_plate = user_info.license_plate
             self.tag_id = user_info.tag_id
             self.first_name = user_info.first_name
             self.last_name = user_info.last_name
             self.user_type = user_info.user_type
             self.email = user_info.email
         } catch {
             print("Error with User json: \(error)")
             return nil
         }
     }
      
    func toAnyObject () -> Dictionary<String, Any> {
        return  [
            "user_id": user_id,
            "vehicle_make": vehicle_make,
            "vehicle_model": vehicle_model,
            "vehicle_year": vehicle_year,
            "vehicle_color": vehicle_color,
            "license_plate": license_plate,
            "tag_id": tag_id as Any,
            "first_name": first_name,
            "last_name": last_name,
            "user_type": user_type,
            "email": email as Any
        ]
    }
}
