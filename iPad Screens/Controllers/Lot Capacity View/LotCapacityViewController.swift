//
//  LotCapacityViewController.swift
//  iPad Testing
//
//  Created by Michael Ivanicki on 10/9/24.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class LotCapacityViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var lotMap: MKMapView!
   
    var annotationArray: [LotCustomAnnotation] = []
    
    let lotDS = LotDataService.sharedInstance
    
    //var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //background color of screen
        self.view.backgroundColor = UIColor(red: 243/255.0, green: 250/255.0, blue: 255/255.0, alpha: 1.0)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchLots()
    }
    
    func setupMap() {
        lotMap.delegate = self
        lotMap.mapType = .satellite
        lotMap.isZoomEnabled = true
        lotMap.isScrollEnabled = true
        lotMap.showsUserLocation = true
        lotMap.setRegion(MKCoordinateRegion(center: findCenter(lotID: 9), latitudinalMeters: 500, longitudinalMeters: 500), animated: true)
    }
    
    // Creates an array of custom annotations and plots them onto the map view
    
    func plotLots() {
        
        for lot in lotDS.occupancyInfo {
            let annotation = LotCustomAnnotation (coordinate: findCenter(lotID: lot.lot_id), name: "Lot \(lot.lot_id)", occupancy: "\(round(lot.relativeOccupancy * 100))%")
            annotationArray.append(annotation)
        }
        
        lotMap.addAnnotations(annotationArray)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
         guard annotation is LotCustomAnnotation else { return nil }
         
        var annotationView = lotMap.dequeueReusableAnnotationView(withIdentifier: LotAnnotationView.reuseIdentifier)
         if annotationView == nil {
             annotationView = LotAnnotationView(annotation: annotation, reuseIdentifier: LotAnnotationView.reuseIdentifier)
         } else {
             annotationView?.annotation = annotation
         }
         return annotationView
     }
    
    func fetchLots() {
        //Loading lot and lot occupancy data
        lotDS.fetchAllLotData() {
            result in
            if result {
                DispatchQueue.main.async {
                    print("loading lot info")
                }
            }
        }
        lotDS.fetchOccupancyData() {
            result in
            if result {
                DispatchQueue.main.async {
                    print("loading lot occupancy info")
                    self.setupMap()
                    self.plotLots()
                }
            }
        }
    }
    
    func findCenter(lotID: Int) -> CLLocationCoordinate2D {
        let lot = lotDS.lotInfo.first(where: { $0.lot_id == lotID })!
        let midCoordinate = CLLocationCoordinate2D(latitude: ((lot.bounding_box.top_left[1] + lot.bounding_box.bottom_right[1])/2), longitude: ((lot.bounding_box.top_left[0] + lot.bounding_box.bottom_right[0])/2))
        return midCoordinate
    }

}
