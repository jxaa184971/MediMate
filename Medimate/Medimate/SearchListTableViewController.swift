//
//  SearchListTableViewController.swift
//  Medimate
//
//  Created by 一川 黄 on 19/03/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit

class SearchListTableViewController: UITableViewController {

    var searchCategory: String!
    var samples: Array<GP>!
    var results: Array<GP>!
    var filter:[String:String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false;
        self.navigationItem.title = self.searchCategory
        
        self.filter = ["searchLocation":"Current Location", "language":"English", "sortBy":"Distance"]
        
        let gp1 = GP(name: "Wilson Jennifer Dr", address: "4 Burke Rd, Malvern East VIC 3145", phone: "(03) 9569 3511", language: "Spanish", rating: 3.8, numberOfReview: 27, distance: 0.8, website: "No website", imageURL: "http://cimg0.ibsrv.net/cimg/www.hospitaljobsonline.com/335x188_60/304/General_Practitioners_325186-5304.jpg")
        
        let gp2 = GP(name: "Dr San Zhang", address: "17 Grattan St, Carlton VIC 3053", phone: "1300 798 598", language:"Chinese", rating: 4.5, numberOfReview: 18, distance: 13.6, website: "joachimdiederich.com", imageURL: "http://gloucestershire.respectyourself.info/wp-content/uploads/2012/07/Brunswick-clinic-Room.jpg")
        
        let gp3 = GP(name: "Dr David L Sweeney", address: "412 Collins St, Melbourne VIC 3000", phone: "(03) 9670 7303", language:"Spanish", rating: 2.8, numberOfReview: 43, distance: 20.2, website: "No website", imageURL: "http://i.dailymail.co.uk/i/pix/2013/10/19/article-2468175-1A43B868000005DC-21_634x424.jpg")
        
        self.samples = [gp1, gp2, gp3]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.refreshTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0
        {
            if self.searchCategory == "GP"
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
            return self.results.count
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
                if self.searchCategory == "GP"
                {
                    cell.filterName.text = "Language Prefer"
                    cell.filterValue.text = self.filter["language"]
                }
                else
                {
                    cell.filterName.text = "Sort By"
                    cell.filterValue.text = self.filter["sortBy"]
                }
            }
            if indexPath.row == 2 && self.searchCategory == "GP"
            {
                cell.filterName.text = "Sort By"
                cell.filterValue.text = self.filter["sortBy"]
            }
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("resultCell", forIndexPath: indexPath) as! SearchResultCell
            cell.nameLabel.text = self.results[indexPath.row].name
            let stars = RatingStarGenerator.ratingStarsFromDouble(self.results[indexPath.row].rating)
            cell.ratingLabel.text = "\(stars) \(self.results[indexPath.row].rating)"
            cell.addressLabel.text = self.results[indexPath.row].address
            cell.reviewsLabel.text = "\(self.results[indexPath.row].numberOfReview) reviews"
            cell.distanceLabel.text = "\(self.results[indexPath.row].distance) km"

            // asynchronous loading images from URL
            let session = NSURLSession.sharedSession()
            let url = NSURL(string: self.results[indexPath.row].imageURL)
            let task = session.dataTaskWithURL(url!, completionHandler:
                {
                    (data, response, error) -> Void in
                    if error != nil
                    {
                        print("error when downloading image from URL")
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0
        {
            return 25
        }
        if indexPath.section == 1
        {
            return 84
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
            return 75
        }
        return self.tableView.sectionHeaderHeight - 15
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1
        {
            return "Results"
        }
        return ""
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    func refreshTableView()
    {
        self.languagePreferedResult()
        self.sortResults()
        self.tableView.reloadData()
    }

    func languagePreferedResult()
    {
        if self.filter["language"] == "English"
        {
            self.results = self.samples
        }
        else
        {
            var language = ""
            if self.filter["language"] == "中文"
            {
                language = "Chinese"
            }
            if self.filter["language"] == "Español"
            {
                language = "Spanish"
            }
            
            var preferedArray = Array<GP>()
            for sample in samples
            {
                if sample.language == language
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
            controller.rowSeleted = indexPath.row
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
