//
//  ResultDetailTableViewController.swift
//  Medimate
//
//  Created by Yichuan Huang on 20/03/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class ResultDetailTableViewController: UITableViewController, GMSMapViewDelegate {

    var result:Facility!
    var mapView:GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false;

        self.navigationItem.title = ""
        self.showMap()
    }
    
    override func viewWillAppear(animated: Bool) {
        if self.revealViewController() != nil
        {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Map
    func showMap()
    {
        // initialize map view
        let location = CLLocation(latitude: self.result.latitude, longitude: self.result.longitude)

        let camera = GMSCameraPosition.cameraWithLatitude(location.coordinate.latitude,
                                                          longitude: location.coordinate.longitude,
                                                          zoom: 12)

        self.mapView = GMSMapView.mapWithFrame(CGRect(x: 0, y: 181, width: self.view.frame.width, height: 155), camera: camera)
        self.mapView.myLocationEnabled = false
        self.mapView.settings.myLocationButton = false
        self.mapView.delegate = self
        self.mapView.myLocationEnabled = true
        self.view.addSubview(self.mapView)
        
        // initialize the location marker
        let position = CLLocationCoordinate2DMake(self.result.latitude, self.result.longitude)
        let marker = GMSMarker(position: position)
        marker.userData = result
        marker.map = self.mapView
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0
        {
            return 1
        }
        if section == 1
        {
            if self.result.website != ""
            {
                return 4
            }
            return 3
        }
        if section == 2
        {
            return 3
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("headerCell", forIndexPath: indexPath) as! DetailHeaderCell
            cell.nameLabel.text = self.result.name
            cell.distanceLabel.text = "\(NSString(format:"%.1f",self.result.distance)) km"
            cell.ratingLabel.text = ""
            if self.result.language == ""
            {
                cell.languageLabel.text = "\(NSLocalizedString("GP's Language", comment:"")): English"
            }
            else
            {
                cell.languageLabel.text = "\(NSLocalizedString("GP's Language", comment:"")): English, \(self.result.language)"

            }
            if result.type == "GP"
            {
                cell.typeLabel.text = "\(NSLocalizedString("Type", comment:"")): \(NSLocalizedString("General Practitioner", comment:""))"
            }
            else
            {
                cell.typeLabel.text = "\(NSLocalizedString("Type", comment:"")): \(NSLocalizedString("\(self.result.type)", comment:""))"
            }
            cell.reviewLabel.text = ""
            
            
            // asynchronouse loading images from URL
            if cell.picView.image == nil
            {
                cell.picView.image = UIImage(named: "DefaultImage.png")
                let session = NSURLSession.sharedSession()
                let url = NSURL(string: self.result.imageURL)
                let task = session.dataTaskWithURL(url!, completionHandler:
                    {
                        (data, response, error) -> Void in
                        if error != nil
                        {
                            print("error when downloading image from URL")
                            print("Error: \(error!.localizedDescription)")
                        } else
                        {
                            
                            let image = UIImage(data: data!)
                            dispatch_async(dispatch_get_main_queue(),
                                {
                                    let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as! DetailHeaderCell
                                    cellToUpdate.picView.image = image
                                    self.tableView.reloadData()
                            })
                        }
                })
                task.resume()
            }
            return cell
        }
        if indexPath.section == 1
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("contactCell", forIndexPath: indexPath) as! DetailContactCell
            if indexPath.row == 0
            {
                cell.titleLabel.text = ""
                cell.valueLabel.text = ""
            }
            if indexPath.row == 1
            {
                cell.titleLabel.text = self.result.address
                cell.valueLabel.text = ""
            }
            if indexPath.row == 2
            {
                cell.titleLabel.text = "\(NSLocalizedString("Phone", comment:"")): "
                cell.valueLabel.text = "\(self.result.phone)"
            }
            if indexPath.row == 3
            {
                cell.titleLabel.text = "\(NSLocalizedString("Website", comment:"")): "
                cell.valueLabel.text = "\(self.result.website)"
            }
            return cell
        }
        if indexPath.section == 2
        {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("openingHourCell", forIndexPath: indexPath) as! DetailOpeningHourCell
            if indexPath.row == 0
            {
                cell.titleLabel.text = NSLocalizedString("Weekday", comment:"")
                if self.result.openningHourWeek == ""
                {
                    cell.valueLabel.text = NSLocalizedString("Unknown", comment:"")
                }
                else
                {
                    cell.valueLabel.text = "\(NSLocalizedString(self.result.openningHourWeek, comment:""))"
                }
            }
            if indexPath.row == 1
            {
                cell.titleLabel.text = NSLocalizedString("Saturday", comment:"")
                if self.result.openningHourSat == ""
                {
                    cell.valueLabel.text = NSLocalizedString("Unknown", comment:"")
                }
                else
                {
                    cell.valueLabel.text = "\(NSLocalizedString(self.result.openningHourSat, comment:""))"
                }
            }
            if indexPath.row == 2
            {
                cell.titleLabel.text = NSLocalizedString("Sunday", comment:"")
                if self.result.openningHourSun == ""
                {
                    cell.valueLabel.text = NSLocalizedString("Unknown", comment:"")
                }
                else
                {
                    cell.valueLabel.text = "\(NSLocalizedString(self.result.openningHourSun, comment:""))"
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0
        {
            return 146
        }
        else if indexPath.section == 1 && indexPath.row == 0
        {
            return 120
        }
        else
        {
            return 40
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.tableView.sectionHeaderHeight
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2
        {
            return NSLocalizedString("Opening Hours", comment:"")
        }
        else
        {
            return ""
        }
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1
        {
            if indexPath.row == 2
            {
                let phoneNumberURL = "tel:\(PhoneNoHelper.phoneNumberFromString(self.result.phone))"
                
                let title = NSLocalizedString("Make Phone Call", comment: "")
                let message = NSLocalizedString("Are you sure to make a phone call of selected medical facility?", comment: "")
                self.alterViewFrom(title, message: message, urlString: phoneNumberURL)
                
            }
            if indexPath.row == 3
            {
                let websiteURL = "http://\(self.result.website)"
                
                let title = NSLocalizedString("Open Website", comment: "")
                let message = NSLocalizedString("Are you sure to open the website of selected medical facility in Web Browser?", comment: "")
                self.alterViewFrom(title, message: message, urlString: websiteURL)
            }
        }
    }
    
    // MARK: - OpenURL
    
    func openURLFromString(string:String)
    {
        UIApplication.sharedApplication().openURL(NSURL(string: string)!)
    }

    // MARK: - Alert
    func alterViewFrom(title:String, message:String, urlString:String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .Default, handler:
            { (action:UIAlertAction!) in
                self.openURLFromString(urlString)
        })
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
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
