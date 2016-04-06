//
//  SearchListTableViewController.swift
//  Medimate
//
//  Created by 一川 黄 on 19/03/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class SearchListTableViewController: UITableViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    // MARK: - Properties
    var searchCategory: String!    //category of medical facilities, such as GP, Clinic
    var samples: Array<Facility>!
    var results: Array<Facility>!        //search results
    var filter:[String:String]!    //filter settings
    var isList:Bool! = true        //used to determine the view
    var numberOfRowsShowed:Int! = 10
    
    var locationManager:CLLocationManager!
    var mapView:GMSMapView!
    
    @IBOutlet var infoLabel: UILabel!
    
    // MARK: - View Settings
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false;
        self.navigationItem.title = self.searchCategory
        
        // initialize filter settings
        self.filter = ["searchLocation":"Current Location", "language":"English", "sortBy":"Distance"]
        
        // slow down the speed of scrolling table view
        self.tableView.decelerationRate = UIScrollViewDecelerationRateFast
        
        // initialize location manager
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined
        {
            self.locationManager.requestWhenInUseAuthorization()
            var timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(self.popToParentView), userInfo: nil, repeats: false)
        }
        else
        {
            self.locationManager.startUpdatingLocation()
        }
        
        self.samples = Array<Facility>()
        self.results = Array<Facility>()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.NotDetermined
        {
            let results = HTTPHelper.requestForFacilitiesByType(self.searchCategory)
            if results == nil
            {
                print("Internet Issues")
            }
            else
            {
                self.samples = results!
            }
        
            let location = self.getCurrentLocation()
            DistanceCalculator.distanceBetween(location, facilityArray: self.samples)
        
            self.refresh()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Hide the tab bottom bar
    override var hidesBottomBarWhenPushed: Bool {
        get { return true }
        set { super.hidesBottomBarWhenPushed = newValue }
    }

    // MARK: - Table View Setting

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined
        {
            return 0
        }
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isList == true
        {
            if section == 0
            {
                if self.searchCategory == "GP" || self.searchCategory == "Clinic"
                {
                    return 3
                }
                else
                {
                    return 2
                }
            }
            if section == 1
            {
                if self.results.count < self.numberOfRowsShowed
                {
                    return self.results.count
                }
                else
                {
                    return self.numberOfRowsShowed
                }
            }
        }
        if self.isList == false
        {
            if section == 0
            {
                if self.searchCategory == "GP" || self.searchCategory == "Clinic"
                {
                    return 2
                }
                else
                {
                    return 1
                }
            }
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.isList == true
        {
            // initialize filter cell
            if indexPath.section == 0
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("filterCell", forIndexPath: indexPath) as! FilterCell
                if indexPath.row == 0
                {
                    cell.filterName.text = "Search Location"
                    cell.filterValue.text = self.filter["searchLocation"]
                }
                if indexPath.row == 1
                {
                    if self.searchCategory == "GP" || self.searchCategory == "Clinic"
                    {
                        cell.filterName.text = "Language Spoken"
                        cell.filterValue.text = self.filter["language"]
                    }
                    else
                    {
                        cell.filterName.text = "Sort By"
                        cell.filterValue.text = self.filter["sortBy"]
                    }
                }
                if indexPath.row == 2 && (self.searchCategory == "GP" || self.searchCategory == "Clinic")
                {
                    cell.filterName.text = "Sort By"
                    cell.filterValue.text = self.filter["sortBy"]
                }
                return cell
            }
            else
            {
                // initialize result cell
                let cell = tableView.dequeueReusableCellWithIdentifier("resultCell", forIndexPath: indexPath) as! SearchResultCell
                cell.nameLabel.text = self.results[indexPath.row].name
                //let stars = RatingStarGenerator.ratingStarsFromDouble(self.results[indexPath.row].rating)
                cell.ratingLabel.text = ""
                cell.addressLabel.text = self.results[indexPath.row].address
                cell.reviewsLabel.text = ""
                cell.distanceLabel.text = "\(NSString(format:"%.1f",self.results[indexPath.row].distance)) km"
                
                cell.picView.image = UIImage(named: "DefaultImage.png")
                // set the picView display image as a circle
                cell.picView.layer.cornerRadius = CGRectGetHeight(cell.picView.bounds) / 2
                // remove the parts outside the bound
                cell.picView.clipsToBounds =  true
                
                // asynchronous loading images from URL
                let session = NSURLSession.sharedSession()
                let url = NSURL(string: self.results[indexPath.row].imageURL)
                let task = session.dataTaskWithURL(url!, completionHandler:
                    {
                        (data, response, error) -> Void in
                        if error != nil
                        {
                            print("Error: \(error!.localizedDescription)")
                        }
                        else
                        {
                            let image = UIImage(data: data!)

                            dispatch_async(dispatch_get_main_queue(),
                                {
                                    let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as! SearchResultCell
                                    cellToUpdate.picView.image = image
                            })
                        }
                        })
                task.resume()
                return cell
            }
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("filterCell", forIndexPath: indexPath) as! FilterCell
            if indexPath.row == 0
            {
                cell.filterName.text = "Search Location"
                cell.filterValue.text = self.filter["searchLocation"]
            }
            if indexPath.row == 1
            {
                if self.searchCategory == "GP" || self.searchCategory == "Clinic"
                {
                    cell.filterName.text = "Language Prefer"
                    cell.filterValue.text = self.filter["language"]
                }
            }
            return cell
        }
    }
    
    // set height for rows
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0
        {
            return 40
        }
        if indexPath.section == 1
        {
            return 100
        }
        return 0
    }
    
    // set height for header
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
            return 64
        }
        return self.tableView.sectionHeaderHeight
    }
    
    // set title for header
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1
        {
            if isList == true
            {
                if self.filter["searchLocation"] == "Current Location"
                {
                    return "Results ( Within 10km )"
                }
                return "Results"
            }
            else
            {
                return "Map"
            }
        }
        return ""
    }

    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    // MARK: - Location Based Functions

    func getCurrentLocation() -> CLLocation
    {
        return self.locationManager.location!
    }
    
    // MARK: - Map
    
    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView?
    { 
        let facility = marker.userData as! Facility
        
        let infoWindow = NSBundle.mainBundle().loadNibNamed("InfoWindow", owner: self, options: nil).first as! MarkerInfoWindow
        infoWindow.titleLabel.text = facility.name
        if facility.type == "GP"
        {
            infoWindow.typeLabel.text = "General Practitioner"
        }else
        {
            infoWindow.typeLabel.text = "Type: \(facility.type)"
        }
        infoWindow.ratingLabel.text = ""  //"\(RatingStarGenerator.ratingStarsFromDouble(facility.rating)) \(facility.rating)"
        infoWindow.reviewLabel.text = ""  //"\(facility.numberOfReview) reviews"
        infoWindow.addressLabel.text = "Address: \(facility.address)"
        infoWindow.facility = facility

        return infoWindow
    }
    
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        print("tap on info window")
        let selectedFacility = marker.userData as! Facility
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! ResultDetailTableViewController
        
        controller.result = selectedFacility
        self.navigationController?.pushViewController(controller, animated: true)
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
            marker.map = self.mapView
        }
    }
    
        @IBAction func showMap(sender: UIBarButtonItem)
    {
        if self.isList == true
        {
            self.navigationItem.rightBarButtonItem?.title = "List"
            self.isList = false
            var location:CLLocation!
            // initialize map view
            if self.filter["searchLocation"] == "Current Location" ||
                self.filter["searchLocation"] == "All"
            {
                location = self.getCurrentLocation()
            }
            else
            {
                location = SuburbHelper.locationFromSuburb(self.filter["searchLocation"]!)
            }
            let camera = GMSCameraPosition.cameraWithLatitude(location.coordinate.latitude,
                longitude: location.coordinate.longitude, zoom: 5)
            self.mapView = GMSMapView.mapWithFrame(CGRect(x: 0,y: 160,width: self.view.frame.width,height: self.view.frame.height-160), camera: camera)
            self.mapView.myLocationEnabled = true
            self.mapView.settings.myLocationButton = true
            self.mapView.delegate = self
            self.view.addSubview(self.mapView)
            self.updateMarkers()
        }
        else
        {
            self.navigationItem.rightBarButtonItem?.title = "Map"
            self.isList = true
            self.view.subviews.last?.removeFromSuperview()
        }
        self.refresh()
    }
    
    // MARK: - Filter Search Results
    
    func updateSearchLocation()
    {
        if !(self.filter["searchLocation"] == "Current Location")
        {
            var locationBasedResults = Array<Facility>()
            for result in self.results
            {
                if result.suburb == self.filter["searchLocation"]
                {
                    locationBasedResults.append(result)
                }
            }
            self.results = locationBasedResults
        }
        
        if self.isList == false
        {
            var location:CLLocation!
            // initialize map view
            if self.filter["searchLocation"] == "Current Location"
            {
                location = self.getCurrentLocation()
            }
            else
            {
                location = SuburbHelper.locationFromSuburb(self.filter["searchLocation"]!)
            }
            let camera = GMSCameraPosition.cameraWithLatitude(location.coordinate.latitude,
                longitude: location.coordinate.longitude, zoom: 15)
            self.mapView.camera = camera
        }
    }
    
    func refresh()
    {
        var hasDataRetrived = true
        if self.samples.count == 0
        {
            print("No data returned")
            self.errorMessage("There is no data returned from server. Please check the network is working well.")
            return
        }
        else
        {
            self.infoLabel.text = ""
        }
        
        self.languagePreferedResult()
        self.updateSearchLocation()
        self.sortResults()
        
        if self.filter["searchLocation"] == "Current Location"
        {
            self.resultsWithin10KM()
        }
        
        if self.results.count == 0 && hasDataRetrived == true
        {
            self.errorMessage("There is no result satisfied with the search conditions.")
            self.tableView.reloadData()

        }
        else
        {
            print("2")
            self.tableView.reloadData()
            self.createTableFooter()
        }

    }

    func languagePreferedResult()
    {
        if self.filter["language"] == "English"
        {
            self.results = self.samples
        }
        else
        {
            let language = LanguageHelper.englishFromOtherLanguage(self.filter["language"]!)
            
            var preferedArray = Array<Facility>()
            for sample in samples
            {
                if sample.language.containsString(language)
                {
                    preferedArray.append(sample)
                }
            }
            self.results = preferedArray
        }
    }
    
    func sortResults()
    {
        let sortBy = self.filter["sortBy"]
        if sortBy == "Distance"
        {
            self.results.sortInPlace({ $0.distance < $1.distance })
        }
        if sortBy == "Rating"
        {
            self.results.sortInPlace({$0.rating > $1.rating})
        }
        if sortBy == "Popularity"
        {
            self.results.sortInPlace({$0.numberOfReview > $1.numberOfReview})
        }
    }
    
    func resultsWithin10KM ()
    {
        var filtedResults = Array<Facility>()
        for result in results
        {
            if result.distance <= 10
            {
                filtedResults.append(result)
            }
        }
        self.results = filtedResults
    }
    
    func errorMessage(message: String)
    {
        self.tableView.tableFooterView = nil
        let tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 40))
        let loadMoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 40))
        loadMoreLabel.center = tableFooterView.center
        loadMoreLabel.textAlignment = NSTextAlignment.Center
        loadMoreLabel.font = UIFont(name: "Helvetica Neue", size:14)
        loadMoreLabel.textColor = UIColor.grayColor()
        loadMoreLabel.text = message
        loadMoreLabel.numberOfLines = 3
        tableFooterView.addSubview(loadMoreLabel)
        self.tableView.tableFooterView = tableFooterView
    }
    
    // MARK: - Scroll View
    
    func createTableFooter()
    {
        if self.hasMoreDataToLoad()
        {
            self.tableView.tableFooterView = nil
            let tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 40))
            let loadMoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 40))
            loadMoreLabel.center = tableFooterView.center
            loadMoreLabel.textAlignment = NSTextAlignment.Center
            loadMoreLabel.font = UIFont(name: "Helvetica Neue", size:14)
            loadMoreLabel.textColor = UIColor.grayColor()
            loadMoreLabel.text = "Drag For More Data"
            tableFooterView.addSubview(loadMoreLabel)
            self.tableView.tableFooterView = tableFooterView
        }
        else
        {
            self.tableView.tableFooterView = nil
        }
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.hasMoreDataToLoad()
        {
            if self.tableView.contentOffset.y > (self.tableView.contentSize.height - self.tableView.frame.size.height + 20)
            {
                let tableFooterActivityIndicator = UIActivityIndicatorView(frame: CGRect(x: 75, y: 10, width: 20, height: 20))
                tableFooterActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
                tableFooterActivityIndicator.startAnimating()
                (self.tableView.tableFooterView?.subviews[0] as! UILabel).text = "Loading..."
                self.tableView.tableFooterView?.addSubview(tableFooterActivityIndicator)
            
                self.showMoreData()
            }
        }

    }
    
    func showMoreData()
    {
        if (self.results.count - self.numberOfRowsShowed) <= 5
        {
            self.numberOfRowsShowed = self.results.count
        }
        else
        {
            self.numberOfRowsShowed = self.numberOfRowsShowed + 5
        }
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.refresh), userInfo: nil, repeats: false)
    }
    
    func hasMoreDataToLoad() -> Bool
    {
        if self.results.count > self.numberOfRowsShowed
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    
    // MARK: - Other Functions
    
    func popToParentView()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSegue"
        {
            let indexPath = self.tableView.indexPathForSelectedRow!
            let controller = segue.destinationViewController as! ResultDetailTableViewController
            controller.result = self.results[indexPath.row]
        }
        
        if segue.identifier == "filterSegue"
        {
            let controller = segue.destinationViewController as! FilterTableViewController
            let indexPath = self.tableView.indexPathForSelectedRow!
            if indexPath.row == 0
            {
                controller.filterType = "searchLocation"
            }
            if indexPath.row == 1 && (self.searchCategory == "GP" || self.searchCategory == "Clinic")
            {
                controller.filterType = "language"
            }
            if indexPath.row == 2 && (self.searchCategory == "GP" || self.searchCategory == "Clinic")
            {
                controller.filterType = "sortBy"
            }
            if indexPath.row == 1 && self.searchCategory != "GP" && self.searchCategory != "Clinic"
            {
                controller.filterType = "sortBy"
            }
        }
    }
    

}
