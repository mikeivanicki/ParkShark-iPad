//
//  SpotsDataService.swift
//  iPad Screens
//
//  Created by Andrew J. McGovern on 11/25/24.
//

import Foundation

class SpotsDataService {
    
    let API_URL = "https://api.parkshark.mobi:443/spots"
    let encoder = JSONEncoder()
    let spotsModel = SpotsModel.sharedSpotsModel

    static let sharedInstance = SpotsDataService()
    private init () {}

    func fetchSurroundingSpots(longitude: Double, latitude: Double, radiusDistance: Double, _ completionHandler: @escaping (_ status: Bool, Error?) -> ()) {
        
        //the API is incorrect with longitude and latitude
        let fetchRequest = FindAllSpotsRequest(longitude: latitude, latitude: longitude, distance: radiusDistance)
        print(fetchRequest)
        
        let requestURL: URL = URL(string: "\(API_URL)/findAllSpots")!
        var urlRequest: URLRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("*/*", forHTTPHeaderField: "Accept")
        do {
            encoder.outputFormatting = .prettyPrinted
            urlRequest.httpBody = try encoder.encode(fetchRequest)
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
                if let spotsResponse = FindAllSpotsResponse(data: httpData) {
                    self.spotsModel.spots = spotsResponse.spot_info
                }
                
                let diff = Date().timeIntervalSince(start)
                print("Elapsed time: \(diff) seconds")
                completionHandler(true, nil)
            } else {
                print("HTTP errror: \(statusCode)")
                print(httpResponse)
                completionHandler(false, error)
            }
        })
        task.resume()
    }

}

