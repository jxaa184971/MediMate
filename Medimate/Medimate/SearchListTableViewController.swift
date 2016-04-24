//
//  SearchListTableViewController.swift
//  Medimate
//
//  Created by Yichuan Huang on 19/03/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class SearchListTableViewController: UITableViewController, GMSMapViewDelegate, CLLocationManagerDelegate,FilterButtonClickedProtocol, SWRevealViewControllerDelegate {

    // MARK: - Properties
    var searchCategory: String!        //category of medical facilities, such as GP, Clinic
    var samples: Array<Facility>!
    var results: Array<Facility>!      //search results
    var filter:[String:String]!        //filter settings
    var isList:Bool! = true            //used to determine the view
    var numberOfRowsShowed:Int! = 10   //the number of results showed on tableview
    var isLoading:Bool! = false        //check whether the view is loading or not
    var onlyShowOpenNow = false        //only show the open facility or not
    var onlyBulkBilling = false        //only show the facility support bulk billing
    var filterSeleted = false          //check the filter button selected or not
    
    @IBOutlet var sideBarButton: UIBarButtonItem!
    var locationManager:CLLocationManager!
    var mapView:GMSMapView!
    
    // MARK: - View Settings
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.hidden = true
    
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = NSLocalizedString("\(self.searchCategory)",comment:"")
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.interactivePopGestureRecognizer?.enabled = false
        
        // slow down the speed of scrolling table view
        self.tableView.decelerationRate = UIScrollViewDecelerationRateFast
        self.tableView.sectionFooterHeight = 0
    
        // initialize location manager
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined
        {
            self.locationManager.requestWhenInUseAuthorization()
            _ = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(self.popToParentView), userInfo: nil, repeats: false)
        }
        else
        {
            self.locationManager.startUpdatingLocation()
        }
        
        self.samples = Array<Facility>()
        self.results = Array<Facility>()

        // initialize the side bar menu for filter
        if self.revealViewController() != nil
        {
            let rightView = self.storyboard?.instantiateViewControllerWithIdentifier("SideFilterTableViewController") as! SideFilterTableViewController
            rightView.searchController = self
            
            if self.searchCategory != "GP"
            {
                rightView.showBulkBilling = false
            }
            self.revealViewController().delegate = self
            self.revealViewController().setRightViewController(rightView, animated: true)
            self.sideBarButton.target = self.revealViewController()
            self.sideBarButton.action = #selector(SWRevealViewController.rightRevealToggleAnimated(_:))

            
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.NotDetermined
        {
            let results = HTTPHelper.requestForFacilitiesByType(self.searchCategory)
            if results == nil
            {
                self.errorMessage(NSLocalizedString("No data returned from server. Please check your network connection.", comment: ""))
            }
            else
            {
                self.samples = results!
            }
        
            let location = self.getCurrentLocation()
            DistanceCalculator.distanceBetween(location, facilityArray: self.samples)
        
            self.refresh()
        }
        
        if self.revealViewController() != nil
        {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
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
        if section == 0
        {
            return 1
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
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("filterCell", forIndexPath: indexPath) as! FilterButtonCell
            var selectionString = "\(self.filter["language"]!) | \(self.filter["searchLocation"]!)"
            if self.onlyShowOpenNow == true
            {
                selectionString = selectionString + " | Open Now"
                print(selectionString)
            }
            if self.onlyBulkBilling == true
            {
                selectionString = selectionString + " | Bulk Billing"
                print(selectionString)
            }
            selectionString = selectionString + ""
            cell.selectionLabel.text = selectionString
            cell.delegate = self
            if self.filterSeleted == false
            {
                cell.filterButton.setImage(UIImage(named: "filter.png"), forState: .Normal)
            }
            if self.filterSeleted == true
            {
                cell.filterButton.setImage(UIImage(named: "next.png"), forState: .Normal)
            }
            return cell
        }
        if indexPath.section == 1
        {
            // initialize result cell
            let cell = tableView.dequeueReusableCellWithIdentifier("resultCell", forIndexPath: indexPath) as! SearchResultCell
            cell.nameLabel.text = self.results[indexPath.row].name
            //let stars = RatingStarGenerator.ratingStarsFromDouble(self.results[indexPath.row].rating)
            cell.ratingLabel.text = ""
            cell.addressLabel.text = self.results[indexPath.row].address
            cell.reviewsLabel.text = ""
            cell.distanceLabel.text = "\(NSString(format:"%.1f",self.results[indexPath.row].distance)) km"
            
            // check whether the facility open or not
            if DateHelper.facilityNowOpen(self.results[indexPath.row])
            {
                cell.nowOpenImageView.image = UIImage(named: "open_now.png")
            }
            else
            {
                cell.nowOpenImageView.image = UIImage(named: "blank.png")
            }
            
            if self.results[indexPath.row].bulkBilling == true
            {
                cell.bulkBillingImageView.image = UIImage(named: "bulkBilling.png")
            }
            else
            {
                cell.bulkBillingImageView.image = UIImage(named:"blank.png")
            }
            
            
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
        return UITableViewCell()
    }
    
    // set height for rows
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0
        {
            return 65
        }
        if indexPath.section == 1
        {
            return 100
        }
        return 40
    }
    
    // set height for header
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.tableView.sectionHeaderHeight
    }
    
    // set title for header
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0
        {
            return NSLocalizedString("Your Selection", comment: "")
        }
        if section == 1
        {
            return NSLocalizedString("Results",comment:"")
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0
        {
            UIApplication.sharedApplication().sendAction(self.sideBarButton.action, to: self.sideBarButton.target, from: self, forEvent: nil)
        }
    }

    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    // MARK: - Location Based Functions

    func getCurrentLocation() -> CLLocation
    {
        
        return self.locationManager.location!
        //return CLLocation(latitude: -37.876415, longitude: 145.044455)
    }
    
    // MARK: - Map
    
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
            self.tableView.setContentOffset(CGPointZero, animated: true)
            self.navigationItem.rightBarButtonItem?.title = NSLocalizedString("List",comment:"")
            self.isList = false
            var location:CLLocation!
            // initialize map view
            if self.filter["searchLocation"] == NSLocalizedString("Current Location (Within 5km)", comment:"") || self.filter["searchLocation"] == NSLocalizedString("Current Location (Within 10km)", comment:"")
            {
                location = self.getCurrentLocation()
            }
            else
            {
                location = SuburbHelper.locationFromSuburb(self.filter["searchLocation"]!)
            }
            
            let camera = GMSCameraPosition.cameraWithLatitude(location.coordinate.latitude,
                longitude: location.coordinate.longitude, zoom: 5)
            self.mapView = GMSMapView.mapWithFrame(CGRect(x: 0,y: 160,width: self.view.frame.width,height: self.view.frame.height-160), camera: camera)   //240
            self.mapView.myLocationEnabled = true
            self.mapView.settings.myLocationButton = true
            self.mapView.delegate = self
            self.view.addSubview(self.mapView)
        }
        else
        {
            self.navigationItem.rightBarButtonItem?.title = NSLocalizedString("Map",comment:"")
            self.isList = true
            self.view.subviews.last?.removeFromSuperview()
        }
        self.refresh()
    }
    
    // MARK: - Filter Search Results
    func refresh()
    {
        if self.samples.count == 0
        {
            self.errorMessage(NSLocalizedString("No data returned from server. Please check your network connection.", comment: ""))
            return
        }

        self.languagePreferedResult()
        self.updateSearchLocation()
        self.sortResults()
        if self.onlyShowOpenNow
        {
            self.facilityOpenNow()
        }
        if self.onlyBulkBilling
        {
            self.facilitySupportBulkBilling()
        }
        
        if self.filter["searchLocation"] == NSLocalizedString("Current Location (Within 5km)", comment:"")
        {
            self.resultsWithinDistance(5)
        }
        
        if self.filter["searchLocation"] == NSLocalizedString("Current Location (Within 10km)", comment:"")
        {
            self.resultsWithinDistance(10)
        }
        
        if self.results.count == 0 
        {
            self.errorMessage(NSLocalizedString("No results found matching your selection.", comment: ""))
        }
        else
        {
            self.createTableFooter()
        }
        
        self.tableView.reloadData()
        
        if self.isList == false
        {
            self.updateMarkers()
        }
    }
    
    func updateSearchLocation()
    {
        if self.filter["searchLocation"] != NSLocalizedString("Current Location (Within 5km)",comment:"")
        && self.filter["searchLocation"] != NSLocalizedString("Current Location (Within 10km)",comment:"")
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
            if self.filter["searchLocation"] == NSLocalizedString("Current Location (Within 5km)",comment:"") ||
                self.filter["searchLocation"] == NSLocalizedString("Current Location (Within 10km)",comment:"")
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
        if sortBy == NSLocalizedString("Distance",comment:"")
        {
            self.results.sortInPlace({ $0.distance < $1.distance })
        }
        if sortBy == NSLocalizedString("Rating",comment:"")
        {
            self.results.sortInPlace({$0.rating > $1.rating})
        }
        if sortBy == NSLocalizedString("Popularity",comment:"")
        {
            self.results.sortInPlace({$0.numberOfReview > $1.numberOfReview})
        }
    }
    
    func resultsWithinDistance(km:Double)
    {
        var filtedResults = Array<Facility>()
        for result in results
        {
            if result.distance <= km
            {
                filtedResults.append(result)
            }
        }
        self.results = filtedResults
    }
    
    func facilityOpenNow()
    {
        var filtedResults = Array<Facility>()
        for result in results
        {
            if DateHelper.facilityNowOpen(result)
            {
                filtedResults.append(result)
            }
        }
        self.results = filtedResults
    }
    
    func facilitySupportBulkBilling()
    {
        var filtedResults = Array<Facility>()
        for result in results
        {
            if result.bulkBilling == true
            {
                filtedResults.append(result)
            }
        }
        self.results = filtedResults
    }
    
    func filterButtonClicked()
    {
        UIApplication.sharedApplication().sendAction(self.sideBarButton.action, to: self.sideBarButton.target, from: self, forEvent: nil)
    }
    
    func revealController(revealController: SWRevealViewController!, willMoveToPosition position: FrontViewPosition) {
        if position == FrontViewPosition.Left
        {
            self.filterSeleted = false
            print("Left")
        }
        if position == FrontViewPosition.LeftSide
        {
            self.filterSeleted = true
            print("Left Side")
        }
        self.tableView.reloadData()
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
            loadMoreLabel.text = NSLocalizedString("Drag For More Data",comment:"")
            tableFooterView.addSubview(loadMoreLabel)
            self.tableView.tableFooterView = tableFooterView
        }
        else
        {
            self.tableView.tableFooterView = nil
        }
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.hasMoreDataToLoad() && self.isLoading == false
        {
            if self.tableView.contentOffset.y > (self.tableView.contentSize.height - self.tableView.frame.size.height + 20)
            {
                let tableFooterActivityIndicator = UIActivityIndicatorView(frame: CGRect(x: 75, y: 10, width: 20, height: 20))
                tableFooterActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
                    tableFooterActivityIndicator.startAnimating()
                (self.tableView.tableFooterView?.subviews[0] as! UILabel).text = NSLocalizedString("Loading...", comment:"")
                self.tableView.tableFooterView?.addSubview(tableFooterActivityIndicator)
            
                self.showMoreData()
            }
        }
    }
    
    func showMoreData()
    {
        self.isLoading = true    // start loading more data
        if (self.results.count - self.numberOfRowsShowed) <= 5
        {
            self.numberOfRowsShowed = self.results.count
        }
        else
        {
            self.numberOfRowsShowed = self.numberOfRowsShowed + 5
        }
        
        _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.refresh), userInfo: nil, repeats: false)
        
        // finish loading data after 2 sec, to avoid multiple times loading as one time
        _ = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(self.finishLoading), userInfo: nil, repeats: false)
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
    
    func finishLoading()
    {
        self.isLoading = false
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
            if indexPath.row == 1 && self.searchCategory == "GP"
            {
                controller.filterType = "language"
            }
            if indexPath.row == 2 && self.searchCategory == "GP"
            {
                controller.filterType = "sortBy"
            }
            if indexPath.row == 1 && self.searchCategory != "GP"
            {
                controller.filterType = "sortBy"
            }
        }
    }
}
