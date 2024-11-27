//
//  PatrolViewViewController.swift
//  iPad Screens
//
//  Created by Andrew J. McGovern on 10/9/24.
//

import UIKit
import MapKit

class PatrolViewViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let mySpotsDataService = SpotsDataService.sharedInstance
    let mySpotsModel = SpotsModel.sharedSpotsModel
    
    //MAP AND LOCATION MANAGER
    @IBOutlet weak var patrolMap: MKMapView!
    let locationManager:CLLocationManager = CLLocationManager()
    
    //DATA SERVICE INSTANCES
    let annotationDS = PatrolViewDataService.sharedInstance
    
    //ARRAYS FOR SPOTS & ANNOTATIONS
    var parkingSpots: [Spot] = []
    var parkingAnnotations: [ParkingAnnotation] = []
    
    //REFRESH TIMER
    var timer = Timer()
    
    //REFRESH BY DISTANCE
    let minimumRefreshDistance: Double = 5
    var oldLocation: CLLocation?
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //MAP AND LOCATION MANAGER
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        print("location updating")
        
        patrolMap.delegate = self
        patrolMap.mapType = .standard
        patrolMap.isZoomEnabled = true
        patrolMap.isScrollEnabled = true
        patrolMap.isRotateEnabled = true
        patrolMap.showsUserLocation = true
        patrolMap.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 100, maxCenterCoordinateDistance: 100)
        patrolMap.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: patrolMap.userLocation.coordinate.latitude, longitude: patrolMap.userLocation.coordinate.longitude), latitudinalMeters: patrolMap.cameraZoomRange.minCenterCoordinateDistance, longitudinalMeters: patrolMap.cameraZoomRange.minCenterCoordinateDistance), animated: true)
        patrolMap.userTrackingMode = .followWithHeading
        
        //RESET MAP AND START TIMER
        resetMap()
        fetchSurroundingSpots()
        
        oldLocation = CLLocation(latitude: patrolMap.userLocation.coordinate.latitude, longitude: patrolMap.userLocation.coordinate.longitude)
        
        //print("timer on")
        //timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        //timer.tolerance = 0.2
        //RunLoop.current.add(timer, forMode: .common)
        
        //TESTING
        //fetchSpots(lot: 13)
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
        locationManager.stopUpdatingLocation()
        print("timer & user location updating shut off")
        super.viewDidDisappear(true)
    }
    
    @objc func fireTimer() {
        print("Timer fired!")
        fetchSurroundingSpots()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("updated location")
        
        if let newLocation = locations.last {
            if oldLocation != nil {
                let distance = Double(newLocation.distance(from: oldLocation!))
                if distance > minimumRefreshDistance {
                    fetchSurroundingSpots()
                    //timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
                    oldLocation = newLocation
                }
            }
        }
    }
        
    func resetMap() {
        let annotations = patrolMap.annotations.filter({ !($0 is MKUserLocation) })
        patrolMap.removeAnnotations(annotations)
        parkingSpots = []
        parkingAnnotations = []
    }
        
    func fetchSurroundingSpots() {
        mySpotsDataService.fetchSurroundingSpots(longitude: patrolMap.userLocation.coordinate.longitude, latitude: patrolMap.userLocation.coordinate.latitude, radiusDistance: 25) {
            result, error in
            if result {
                DispatchQueue.main.async {
                    self.loadSurroundingSpots()
                }
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Spots Failure", message: "\(error?.localizedDescription ?? "Spots Error.")", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                        self.present(alert, animated: true)
                }
            }
        }
    }
        
    func loadSurroundingSpots() {
        var newParkingSpotsSet: Set<Spot> = []
        var updatedSpotsArray: [Spot] = []
        var oldSpotsArray: [Spot] = []
        var newParkingAnnotations: [ParkingAnnotation] = []
        
        for newParkingSpot in mySpotsModel.spots {
            newParkingSpotsSet.insert(newParkingSpot)
        }
        
        if !(parkingSpots.isEmpty) {
            let oldParkingSpotsSet = Set(parkingSpots)
            updatedSpotsArray = Array(newParkingSpotsSet.subtracting(oldParkingSpotsSet))
            oldSpotsArray = Array(oldParkingSpotsSet.subtracting(newParkingSpotsSet))
            //print("NOT EMPTY ===========")
            //print(updatedSpotsArray)
            for i in oldSpotsArray {
                print("REMOVING ANNOTATIONS TOO FAR AWAY =========")
                if let outdatedAnnotation = patrolMap.annotations.first(where: {$0.subtitle == "Spot ID: \(i.spotId)"} ) {
                    patrolMap.removeAnnotation(outdatedAnnotation)
                }
            }
            for i in updatedSpotsArray {
                print("REMOVING OUTDATED ANNOTATION =========")
                if let outdatedAnnotation = patrolMap.annotations.first(where: {$0.subtitle == "Spot ID: \(i.spotId)"} ) {
                    patrolMap.removeAnnotation(outdatedAnnotation)
                }
            }
            for parkingSpot in updatedSpotsArray {
                print("ADDING NEW ANNOTATION =========")
                let newParkingAnnotation = ParkingAnnotation(coordinate: CLLocationCoordinate2D(latitude: Double(parkingSpot.latlong[0])!, longitude: Double(parkingSpot.latlong[1])!), title: "\(parkingSpot.spotId)", subtitle: "", status: parkingSpot.isAvailable, lot_id: parkingSpot.lotNumber, row_id: parkingSpot.rowName, spot_id: parkingSpot.spotId)
                newParkingAnnotations.append(newParkingAnnotation)
            }
            parkingSpots = Array(newParkingSpotsSet)
        } else {
            //print("EMPTY ========================")
            parkingSpots = Array(newParkingSpotsSet)
            for parkingSpot in parkingSpots {
                let newParkingAnnotation = ParkingAnnotation(coordinate: CLLocationCoordinate2D(latitude: Double(parkingSpot.latlong[0])!, longitude: Double(parkingSpot.latlong[1])!), title: "\(parkingSpot.spotId)", subtitle: "Spot ID: \(parkingSpot.spotId)", status: parkingSpot.isAvailable, lot_id: parkingSpot.lotNumber, row_id: parkingSpot.rowName, spot_id: parkingSpot.spotId)
                newParkingAnnotations.append(newParkingAnnotation)
                print(newParkingAnnotation.spot_id)
            }
        }
        patrolMap.addAnnotations(newParkingAnnotations)
        print("ADD ANNOTATIONS =======")
    }
    
    /*
    func fetchSpots(lot: Int) {
        //Loading spot data
        annotationDS.fetchSpecificLotSpotData(lotID: lot) {
            result in
            if result {
                DispatchQueue.main.async {
                    self.loadSpots()
                    print("loading spot info")
                }
            }
        }
    }
    
    func loadSpots() {
        var newParkingSpotsSet: Set<SpotInfo> = []
        var updatedSpotsArray: [SpotInfo] = []
        var newParkingAnnotations: [ParkingAnnotation] = []
        
        for newParkingSpot in annotationDS.spotInfo {
            newParkingSpotsSet.insert(newParkingSpot)
        }
        
        if !(parkingSpots.isEmpty) {
            let oldParkingSpotsSet = Set(parkingSpots)
            updatedSpotsArray = Array(newParkingSpotsSet.subtracting(oldParkingSpotsSet))
            
            for i in updatedSpotsArray {
                print("REMOVING OLD ANNOTATION =========")
                let outdatedAnnotation = patrolMap.annotations.first(where: {$0.title == "\(i.spot_id)"} )
                patrolMap.removeAnnotation(outdatedAnnotation!)
            }
            
            for parkingSpot in updatedSpotsArray {
                print("ADDING NEW ANNOTATION =========")
                let newParkingAnnotation = ParkingAnnotation(coordinate: CLLocationCoordinate2D(latitude: parkingSpot.latlong.coordinates[1], longitude: parkingSpot.latlong.coordinates[0]), title: "\(parkingSpot.spot_id)", subtitle: "", status: parkingSpot.is_available, spot_id: parkingSpot.spot_id, is_handicap: parkingSpot.is_handicap, row_id: parkingSpot.row_id
                                                             //                                                             license_plate: parkingSpot.license_plate, color: parkingSpot.color, detectedID: parkingSpot.detectedID
                )
                newParkingAnnotations.append(newParkingAnnotation)
            }
            parkingSpots = Array(newParkingSpotsSet)
            
        } else {
            parkingSpots = Array(newParkingSpotsSet)
            for parkingSpot in parkingSpots {
                let newParkingAnnotation = ParkingAnnotation(coordinate: CLLocationCoordinate2D(latitude: parkingSpot.latlong.coordinates[1], longitude: parkingSpot.latlong.coordinates[0]), title: "\(parkingSpot.spot_id)", subtitle: "", status: parkingSpot.is_available, spot_id: parkingSpot.spot_id, is_handicap: parkingSpot.is_handicap, row_id: parkingSpot.row_id
                                                             //                                                             license_plate: parkingSpot.license_plate, color: parkingSpot.color, detectedID: parkingSpot.detectedID
                )
                
                newParkingAnnotations.append(newParkingAnnotation)
            }
        }
        
        patrolMap.addAnnotations(newParkingAnnotations)
    }
    */
        
        
        
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard let parkingAnnotation = annotation as? ParkingAnnotation else { return nil }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView?.displayPriority = .required
        } else {
            anView?.annotation = annotation
        }
        
        
        switch parkingAnnotation.status {
            case 0:
                anView?.image = UIImage(named: "occupiedSpot")
            case 1:
                anView?.image = UIImage(named: "emptySpot")
            case 2:
                anView?.image = UIImage(named: "closedSpot")
            case 3:
                anView?.image = UIImage(named: "ticketedSpot")
            default:
                anView?.image = UIImage(named: "emptySpot")
        }
        
        parkingAnnotation.title = parkingAnnotation.status == 1 ? "Empty" : "Occupied"
        parkingAnnotation.subtitle = "Spot ID: \(parkingAnnotation.spot_id)"
        
        anView?.canShowCallout = true
        
        let calloutButton = UIButton(type: .system)
        calloutButton.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        calloutButton.setTitle("Not Correct?", for: .normal)
        anView?.rightCalloutAccessoryView = calloutButton
        
        calloutButton.tag = parkingAnnotation.spot_id
        
        calloutButton.addTarget(self, action: #selector(calloutButtonTapped(sender:)), for: .touchUpInside)
        
        return anView
    }
        
    @objc func calloutButtonTapped(sender: UIButton) {
        //print("Callout button tapped!")
        
        let spotId = sender.tag
        //print("Callout button tapped. Spot ID: \(spotId)")
        
        if let parkingAnnotation = patrolMap.annotations.first(where: { ($0 as? ParkingAnnotation)?.spot_id == spotId }) as? ParkingAnnotation {
            
            //print("Annotation found: Spot ID: \(parkingAnnotation.spot_id), Status: \(parkingAnnotation.status)")
            
            if parkingAnnotation.status == 1 {
                presentRedSpotViewController(parkingAnnotation)
            } else {
                presentGreenSpotViewController(parkingAnnotation)
            }
        } else {
            print("No annotation found for Spot ID: \(spotId)")
        }
    }
        
        
    @IBAction func recenterPressed(_ sender: Any) {
        patrolMap.userTrackingMode = .followWithHeading
    }
    
        
    func presentGreenSpotViewController(_ parkingAnnotation: ParkingAnnotation) {
        if let greenSpotVC = self.storyboard?.instantiateViewController(withIdentifier: "GreenSpotViewController") as? GreenSpotViewController {
            
            greenSpotVC.spot = parkingAnnotation.spot_id
            greenSpotVC.lot = parkingAnnotation.lot_id
            greenSpotVC.row = parkingAnnotation.row_id
            
            self.present(greenSpotVC, animated: true, completion: nil)
        }
    }
        
        
    func presentRedSpotViewController(_ parkingAnnotation: ParkingAnnotation) {
        if let redSpotVC = self.storyboard?.instantiateViewController(withIdentifier: "RedSpotViewController") as? RedSpotViewController {
            
            redSpotVC.spot = parkingAnnotation.spot_id
            redSpotVC.lot = parkingAnnotation.lot_id
            redSpotVC.row = parkingAnnotation.row_id
            
            self.present(redSpotVC, animated: true, completion: nil)
        }
    }
    
}
