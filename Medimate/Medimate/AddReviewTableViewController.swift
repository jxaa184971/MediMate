//
//  AddReviewTableViewController.swift
//  Medimate
//
//  Created by 一川 黄 on 8/05/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit

class AddReviewTableViewController: UITableViewController, ButtonClickedProtocol {

    var facility:Facility!
    var parentController: ResultDetailTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
            return 1
        }
        if section == 1
        {
            return 2
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("addReviewCell", forIndexPath: indexPath)


            return cell
        }
        if indexPath.section == 1
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("buttonCell", forIndexPath: indexPath) as! ButtonCell
            cell.delegate = self
            if indexPath.row == 0
            {
                cell.addReviewButton.setTitle("\(NSLocalizedString("Save", comment: ""))", forState: .Normal)
            }
            if indexPath.row == 1
            {
                cell.addReviewButton.setTitle("\(NSLocalizedString("Cancel", comment: ""))", forState: .Normal)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0
        {
            return 335
        }
        return 44
    }
    
    // MARK: - Button Delegate
    func saveButtonClicked()
    {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! AddReviewCell
        
        let waitingRating = cell.waitingRating.rating
        let parkingRating = cell.parkingRating.rating
        let disabilityRating = cell.disabilityRating.rating
        let languageRating = cell.languageRating.rating
        let transportRating = cell.transportRating.rating
        
        let deviceUID =  UIDevice.currentDevice().identifierForVendor!.UUIDString
        let deviceName = UIDevice.currentDevice().name
        let dateString = DateHelper.getCurrentDateStringForReview()
        let facilityID = self.facility.id
        
        let result = HTTPHelper.insertReview(deviceUID, deviceName: deviceName, waiting: waitingRating, parking: parkingRating, disability: disabilityRating, language: languageRating, transport: transportRating, date: dateString, facilityID: facilityID)
        
        if result == "Success"
        {
            print(result)
            let title = NSLocalizedString("Success", comment: "")
            let message = NSLocalizedString("Thanks for the review", comment: "")
            let alterController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: .Default, handler:
                { (action:UIAlertAction!) in
                    self.parentController.afterAddReview()
                    self.navigationController?.popViewControllerAnimated(true)
            })
            
            alterController.addAction(defaultAction)
            self.presentViewController(alterController, animated: true, completion: nil)
            
        }
        else
        {
            print("error")
            let title = NSLocalizedString("Error", comment: "")
            let message = NSLocalizedString("There is an error when add new review. Please try again.", comment: "")
            let alterController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: .Default, handler:nil)
            
            alterController.addAction(defaultAction)
            self.presentViewController(alterController, animated: true, completion: nil)
        }
        
        
    }
    
    func cancelButtonClicked()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
