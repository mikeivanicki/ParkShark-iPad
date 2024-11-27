//
//  PatrolViewDataService.swift
//  iPad Screens
//
//  Created by Andrew J. McGovern on 10/25/24.
//

import Foundation


struct LatLongInfo: Codable {
    var type: String
    var coordinates: [Double]
}

struct SpotInfo:Codable {
    var spot_id: Int
    var is_handicap: Int
    var latlong: LatLongInfo
    var is_available: Int
    var lot_id: Int
    var row_id: Int
    
//    var license_plate: String?
//    var color: String?
//
//    var detectedID: Int
}

extension SpotInfo: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(spot_id)
        hasher.combine(is_available)
    }
    
    static func == (lhs: SpotInfo, rhs: SpotInfo) -> Bool {
        return lhs.spot_id == rhs.spot_id && lhs.is_available == rhs.is_available
    }
}

class PatrolViewDataService {
    
    var spotInfo: [SpotInfo] = []
    
    static let sharedInstance = PatrolViewDataService()
    private init () {
    }
    
    func fetchSpecificLotSpotData(lotID: Int, _ completionHandler: @escaping (_ status: Bool) -> ()) {
        
        // URL as String
        let requestAPI:String = "https://api.parkshark.mobi/lots/getSpots/\(lotID)"
        
        // convert to URL
        let requestURL: URL = URL(string: requestAPI)!
        
        // instantiate URL Request Object
        let urlRequest: URLRequest = URLRequest(url: requestURL)
        
        // URL Session singleton
        let session = URLSession.shared
        let start = Date()
        
        // initiate the request task in session
        // Note - this run in a background - i.e., non-main queue
        // upon return, we receive the data, http respones and error
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (httpData, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            // http return code 200 is valid. All others mean no data received
            if (statusCode == 200) {
                print("HTTP response 200, file downloaded successfully.")
                do{
                    
//                    for spot in self.spotInfo {
//                        print("Spot ID: \(spot.spot_id), Row ID: \(spot.row_id), Availability: \(spot.is_available)")
//                    }
                    
                    
                    self.spotInfo = try JSONDecoder().decode([SpotInfo].self, from: httpData!)
                    let diff = Date().timeIntervalSince(start)
                    print("Elapsed time: \(diff) seconds")
                    print(self.spotInfo)
                    completionHandler(true)
                }catch {
                    print("Error with Json: \(error)")
                    completionHandler(false)
                }
            } else {
                print("HTTP errror: \(statusCode)")
                completionHandler(false)
            }
        })
        task.resume()
    }
}
