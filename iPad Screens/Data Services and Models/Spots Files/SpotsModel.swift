//
//  SpotsModel.swift
//  iPad Screens
//
//  Created by Andrew J. McGovern on 11/25/24.
//

import Foundation

class SpotsModel {
    
    static let sharedSpotsModel = SpotsModel()
    private init() {}
    
    var spots: [Spot] = [] //shared instance of Spots
}
