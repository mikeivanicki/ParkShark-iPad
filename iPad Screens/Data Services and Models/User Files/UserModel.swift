//
//  UserModel.swift
//  ParkShark
//
//  Created by Andrew J. McGovern on 12/2/23.
//

class UserModel {
    
    static let sharedUserModel = UserModel()
    private init() {}
    
    var user: User? //shared instance of User
}
