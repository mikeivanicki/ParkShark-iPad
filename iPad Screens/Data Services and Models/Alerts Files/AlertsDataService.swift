//
//  AlertsDataService.swift
//  iPad Screens
//
//  Created by Michael Ivanicki on 11/11/24.
//

struct Alert: Codable{
    var alertID: Int
    var title: String
    var message: String
    var dateTime: String
    var userID: Int
    var effDate: String
    var endDate: String?
    
    
    enum CodingKeys: String, CodingKey {
            case alertID = "alert_id"
            case title = "title"
            case message = "message"
            case dateTime = "date_time"
            case userID = "userId"
            case effDate = "eff_date"
            case endDate = "end_date"
        }
}

struct AlertResponse: Codable {
    let alerts: [Alert]
    let totalAlerts: Int
}

import Foundation

class AlertsDataService {
    //var alerts: [Alert] = []
    var alertResponse: AlertResponse = AlertResponse(alerts: [], totalAlerts: 0)
    static let sharedInstance = AlertsDataService()
    private init() {}
    
    func fetchAlerts(_ completionHandler: @escaping (_ status: Bool) -> ()) {
        // URL as String
        let requestAPI:String = "https://api.parkshark.mobi:443/alerts/getAllActiveAlerts"
        
        
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
                    
                    self.alertResponse = try JSONDecoder().decode(AlertResponse.self, from: httpData!)
                    print(self.alertResponse)
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
