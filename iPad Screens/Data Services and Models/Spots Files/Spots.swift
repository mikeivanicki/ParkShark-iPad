//
//  Spots.swift
//  iPad Screens
//
//  Created by Andrew J. McGovern on 11/25/24.
//

import Foundation

struct FindAllSpotsRequest: Codable {
    var longitude: Double
    var latitude: Double
    var distance: Double
}

struct FindAllSpotsResponse: Codable {
    
    var spot_info: [Spot]
    
    init?(data: Data) {
        do {
            spot_info = try JSONDecoder().decode([Spot].self, from: data)
        } catch {
            print("Error with Spots json: \(error)")
            return nil
        }
    }
}

struct Spot: Codable {
    let spotId: Int
    let latlong: [String]
    //let distanceMeters: Int
    let lotNumber: Int
    let rowName: String
    let isAvailable: Int
    //let lotActivity: LotActivity
    
    init(spotId: Int, latlong: [String], distanceMeters: Int, lotNumber: Int, rowName: String, isAvailable: Int) {
        self.spotId = spotId
        self.latlong = latlong
        self.lotNumber = lotNumber
        self.rowName = rowName
        self.isAvailable = isAvailable
    }
    
    init?(data: Data) {
        do {
            let spot_info = try JSONDecoder().decode(Spot.self, from: data)
            self.spotId = spot_info.spotId
            self.latlong = spot_info.latlong
            //self.distanceMeters = spot_info.distanceMeters
            self.lotNumber = spot_info.lotNumber
            self.rowName = spot_info.rowName
            self.isAvailable = spot_info.isAvailable
        } catch {
            print("Error with Spots json: \(error)")
            return nil
        }
    }
}

extension Spot: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(spotId)
        hasher.combine(isAvailable)
    }
    
    static func == (lhs: Spot, rhs: Spot) -> Bool {
        return lhs.spotId == rhs.spotId && lhs.isAvailable == rhs.isAvailable
    }
}

struct LotActivity: Codable {/*
    activityId": "No activity",
    "status": "No status",
    "timestamp": "No timestamp",
    "ticket": "No ticket",
    "timeslot": "No timeslot",
    "dayOfWeek": "No day of week",
    "ptimeIn": "No ptime_in",
    "ptimeOut": "No ptime_out",
    "tagActivityId": "No tag activity ID",
    "ticketInfo": "No ticket info",
    "userId": "No user ID",
    "licensePlate": "No license plate"
                              */
}
