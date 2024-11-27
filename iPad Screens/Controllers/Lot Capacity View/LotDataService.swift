//
//  LotDataService.swift
//  iPad Testing
//
//  Created by Michael Ivanicki on 10/25/24.
//

import Foundation
import MapKit

struct BoundingBox: Decodable {
    var top_left: [Double]
    var bottom_right: [Double]
}

struct LotInfo:Decodable {
    var lot_id: Int
    var lot_type: String
    var is_available: Int
    let auto_lot_id: Int
    let bounding_box: BoundingBox
}

struct OccupancyInfo:Decodable {
    var lot_id: Int
    var totalCount: Int
    var occupiedCount: Int
    var relativeOccupancy: Double
    var lotType: String
    
}

class LotDataService {
   var lotInfo: [LotInfo] = []
    var occupancyInfo: [OccupancyInfo] = []
    //var test: Set <LotInfo> = []
    static let sharedInstance = LotDataService()
    
    private init() {}
    
    
    func fetchAllLotData(_ completionHandler: @escaping (_ status: Bool) -> ()) {
        
        // URL as String
        let requestAPI:String = "https://api.parkshark.mobi/lots/getLots"
        
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
                print()
                do{
                    
                    self.lotInfo = try JSONDecoder().decode([LotInfo].self, from: httpData!)
                    let diff = Date().timeIntervalSince(start)
                    print("Elapsed time: \(diff) seconds")
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
    func fetchOccupancyData(_ completionHandler: @escaping (_ status: Bool) -> ()) {
        
        // URL as String
        let requestAPI:String = "https://api.parkshark.mobi/lots/getOccupancy"
        
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
                print()
                do{
                    
                    self.occupancyInfo = try JSONDecoder().decode([OccupancyInfo].self, from: httpData!)
                    let diff = Date().timeIntervalSince(start)
                    print("Elapsed time: \(diff) seconds")
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
