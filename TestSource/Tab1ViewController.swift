//
//  Tab1ViewController.swift
//  TestSource
//
//  Created by Star on 1/6/17.
//  Copyright © 2017 Ricardo. All rights reserved.
//

import UIKit
import MapKit

class Tab1ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var labelLat: UILabel!
    @IBOutlet weak var labelLong: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var currentlocation : CLLocation!
    var locationManager : CLLocationManager!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func initialize () {
        // 1. initialize a location manager
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.pausesLocationUpdatesAutomatically  = true
        self.locationManager.activityType = CLActivityType.automotiveNavigation
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        // 2. initialize a map viewe
        self.mapView.delegate = self
        // 3. initialize ui elements
        self.updateUI()
        
    }
    
    //mark - MKMapView delegate
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        var region = MKCoordinateRegion()
        var span = MKCoordinateSpan()
        span.latitudeDelta = 0.005;
        span.longitudeDelta = 0.005;
        region.span = span;
        region.center = userLocation.coordinate;
        self.mapView.setRegion(region, animated: true)
    }
 
    //mark - CLLocationManager delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentlocation = locations.last
        self.updateUI()
    }
    
    func updateUI (){
        if self.currentlocation != nil {
            self.labelLat.text = self.currentlocation.coordinate.latitude.description
            self.labelLong.text = self.currentlocation.coordinate.longitude.description
            self.reverseCoordinatToAddress()
        }else{
            self.labelLat.text = "0.00"
            self.labelLong.text = "0.00"
            self.labelAddress.text = "Unknown address"
        }
    }
    
    func reverseCoordinatToAddress() {

        if self.currentlocation == nil {
            return
        }
        
        let geoCoder = CLGeocoder()
        let location = self.currentlocation
        
        geoCoder.reverseGeocodeLocation(location!, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Address
            var address = "";
            if let formattedAddressLines = placeMark.addressDictionary!["FormattedAddressLines"] as? NSArray{
                for item in formattedAddressLines {
                    address.append(item as! String);
                    address.append(" ");
                }
            }
            self.labelAddress.text = address;
            
        })

    }
}
