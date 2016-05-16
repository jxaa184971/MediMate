//
//  NearbyViewController.swift
//  Medimate
//
//  Created by Yichuan Huang on 29/04/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit
import GoogleMaps

class NearbyViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    var locationManager:CLLocationManager!
    var mapView:GMSMapView!
    var results:Array<Facility>!
    @IBOutlet var homeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.homeButton.image = ImageHelper.resizeImage(UIImage(named: "homePage.png")!, newWidth: 30)
        self.homeButton.target = self
        self.homeButton.action = #selector(self.backToHomePage)
        
        // change the style of navigation bar
        let color = UIColor(red: 40/255, green: 130/255, blue: 200/255, alpha: 1)
        self.tabBarController?.tabBar.hidden = false
        self.tabBarController?.tabBar.tintColor = color
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        // initialize location manager
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined
        {
            self.locationManager.requestWhenInUseAuthorization()
        }
        else
        {
            self.locationManager.startUpdatingLocation()
        }
        self.results = Array<Facility>()
        
        self.showMap()
    }
    
    override func viewWillAppear(animated: Bool) {
        if self.mapView != nil
        {
            let location = self.getCurrentLocation()
            let camera = GMSCameraPosition.cameraWithLatitude(location.coordinate.latitude,
                                                              longitude: location.coordinate.longitude, zoom: 15)
            self.mapView.camera = camera
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if HTTPHelper.isConnectedToNetwork()
        {
            self.requestForNewData()
            self.updateMarkers()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Data Request
    func requestForNewData()
    {
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.NotDetermined
        {
            let curLocation = self.getCurrentLocation()
            let results = HTTPHelper.requestForFacilitiesNearby(curLocation)
            if results == nil
            {
                print("Error when fetching data")
            }
            else
            {
                self.results = results
            }
            
            let location = self.getCurrentLocation()
            DistanceCalculator.distanceBetween(location, facilityArray: self.results)
        }
    }
    
    // MARK: - Map
    func showMap()
    {
        let location = self.getCurrentLocation()
        let camera = GMSCameraPosition.cameraWithLatitude(location.coordinate.latitude,
                                                          longitude: location.coordinate.longitude, zoom: 15)
        self.mapView = GMSMapView.mapWithFrame(CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height-110), camera: camera)
        self.mapView.myLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        self.mapView.delegate = self
        self.view.addSubview(self.mapView)
    }
    
    func getCurrentLocation() -> CLLocation
    {
        return self.locationManager.location!
    }
    
    // add markers to map view
    func updateMarkers()
    {
        self.mapView.clear()
        
        for result in results
        {
            let position = CLLocationCoordinate2DMake(result.latitude, result.longitude)
            let marker = GMSMarker(position: position)
            marker.userData = result
            var imageString = ""
            if result.type == "GP" || result.type == "Clinic"
            {
                imageString = "marker_gp.png"
            }
            else if result.type == "Physiotherapist"
            {
                imageString = "marker_phy.png"
            }
            else if result.type == "Pharmacy"
            {
                imageString = "marker_pharmacy.png"
            }
            else if result.type == "Dentist"
            {
                imageString = "marker_dentist.png"
            }
            else if result.type == "Clinic, Physiotherapist"
            {
                imageString = "marker_gp_phy.png"
            }
            else if result.type == "Clinic, Dentist"
            {
                imageString = "marker_gp_den.png"
            }
            else if result.type == "Physiotherapist, Pharmacy"
            {
                imageString = "marker_phy_pha.png"
            }
            else if result.type == "Clinic, Dentist, Physiotherapist, Pharmacy"
            {
                imageString = "marker_all.png"
            }
            else
            {
                imageString = "marker.png"
            }

            let image = UIImage(named:imageString)
            marker.icon = ImageHelper.resizeImage(image!, newWidth: 35)

            marker.map = self.mapView
        }
    }

    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView?
    {
        let facility = marker.userData as! Facility
        
        let infoWindow = NSBundle.mainBundle().loadNibNamed("InfoWindow", owner: self, options: nil).first as! MarkerInfoWindow
        infoWindow.titleLabel.text = facility.name
        if facility.type == "GP"
        {
            infoWindow.typeLabel.text = "\(NSLocalizedString("Type",comment:"")): \(NSLocalizedString("General Practitioner",comment:""))"
        }else
        {
            infoWindow.typeLabel.text = "\(NSLocalizedString("Type",comment:"")): \(NSLocalizedString("\(facility.type)",comment:""))"
        }
        infoWindow.ratingLabel.text = ""  //"\(RatingStarGenerator.ratingStarsFromDouble(facility.rating)) \(facility.rating)"
        infoWindow.reviewLabel.text = ""  //"\(facility.numberOfReview) reviews"
        infoWindow.addressLabel.text = "\(NSLocalizedString("Address",comment:"")): \(facility.address)"
        infoWindow.facility = facility
        
        return infoWindow
    }
    
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        let selectedFacility = marker.userData as! Facility
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! ResultDetailTableViewController
        
        controller.result = selectedFacility
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func backToHomePage()
    {
        self.tabBarController?.selectedIndex = 0
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
