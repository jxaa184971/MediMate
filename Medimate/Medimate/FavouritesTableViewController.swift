//
//  FavouritesTableViewController.swift
//  Medimate
//
//  Created by Yichuan Huang on 27/04/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit

class FavouritesTableViewController: UITableViewController {

    var favouriteList:Array<Facility>!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var homeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.favouriteList = Array<Facility>()
        self.infoLabel.text = ""

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
        self.navigationItem.title = NSLocalizedString("Favourites", comment: "")
    }
    
    override func viewWillAppear(animated: Bool) {
        if hasFavouriteFacility()
        {
            loadFavouriteList()
            self.infoLabel.text = ""
        }
        else
        {
            self.infoLabel.text = NSLocalizedString("You do not have any current favourites. To add a new favourite facility, tap ‘☆’ shown in the top right corner of the facility detail screen.", comment: "")
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Loading Data
    
    func hasFavouriteFacility() -> Bool
    {
        if NSUserDefaults.standardUserDefaults().arrayForKey("favourites") != nil
        {
            let dataList = NSUserDefaults.standardUserDefaults().arrayForKey("favourites") as! Array<NSData>
            if dataList.count > 0
            {
                return true
            }
        }
        return false
    }
    
    func loadFavouriteList()
    {
        let dataList = NSUserDefaults.standardUserDefaults().arrayForKey("favourites") as! Array<NSData>
        self.favouriteList = facilityListFromDataList(dataList)
    }
    
    func facilityListFromDataList(dataList:Array<NSData>) -> Array<Facility>
    {
        var facilityList = Array<Facility>()
        for data in dataList
        {
            let facility = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! Facility
            facilityList.append(facility)
        }
        return facilityList
    }
    
    func dataListFromFacilityList(facilityList:Array<Facility>) -> Array<NSData>
    {
        var dataList = Array<NSData>()
        for facility in facilityList
        {
            let data = NSKeyedArchiver.archivedDataWithRootObject(facility)
            dataList.append(data)
        }
        return dataList
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if hasFavouriteFacility()
        {
            return 1
        }
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favouriteList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("facilityCell", forIndexPath: indexPath) as! FavoritesFacilityCell
        let facility = self.favouriteList[indexPath.row]
        cell.titleLabel.text = facility.name
        cell.addressLabel.text = facility.address
        var imageString = ""
        if facility.type == "GP" || facility.type == "Clinic"
        {
            imageString = "marker_gp.png"
        }
        else if facility.type == "Physiotherapist"
        {
            imageString = "marker_phy.png"
        }
        else if facility.type == "Pharmacy"
        {
            imageString = "marker_pharmacy.png"
        }
        else if facility.type == "Dentist"
        {
            imageString = "marker_dentist.png"
        }
        else if facility.type == "Clinic, Physiotherapist"
        {
            imageString = "marker_gp_phy.png"
        }
        else if facility.type == "Clinic, Dentist"
        {
            imageString = "marker_gp_den.png"
        }
        else if facility.type == "Physiotherapist, Pharmacy"
        {
            imageString = "marker_phy_pha.png"
        }
        else if facility.type == "Clinic, Dentist, Physiotherapist, Pharmacy"
        {
            imageString = "marker_all.png"
        }
        else
        {
            imageString = "DefaultImage.png"
        }
        cell.picView.image = UIImage(named: imageString)

        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0
        {
            return 80
        }
        return tableView.rowHeight
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            if favouriteList.count == 1
            {
                self.favouriteList = Array<Facility>()
                self.tableView.reloadData()
                self.infoLabel.text = NSLocalizedString("You do not have any current favourites. To add a new favourite facility, tap ‘☆’ shown in the top right corner of the facility detail screen.", comment: "")
            }
            else
            {
                favouriteList.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            let dataList = dataListFromFacilityList(self.favouriteList)
            NSUserDefaults.standardUserDefaults().setObject(dataList, forKey: "favourites")
            NSUserDefaults.standardUserDefaults().synchronize()
            
        }
    }
    
    func backToHomePage()
    {
        self.tabBarController?.selectedIndex = 0
    }
    
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
            controller.result = self.favouriteList[indexPath.row]
        }
    }
 

}
