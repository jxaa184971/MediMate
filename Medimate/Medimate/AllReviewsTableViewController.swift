//
//  AllReviewsTableViewController.swift
//  Medimate
//
//  Created by 一川 黄 on 4/05/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit

class AllReviewsTableViewController: UITableViewController {

    var allReviews: Array<Review>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.allReviews.count > 0
        {
            return 1
        }
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allReviews.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reviewCell", forIndexPath: indexPath) as! RatingCell
        let review = self.allReviews[indexPath.row]
        cell.deviceLabel.text = review.deviceName
        cell.timeLabel.text = review.date
        cell.waitingTimeRating.rating = review.waitingRating
        cell.waitingTimeRating.text = "\(review.waitingRating)"
        cell.waitingTimeRating.fillMode = 1
        cell.parkingRating.rating = review.parkingRating
        cell.parkingRating.text = "\(review.parkingRating)"
        cell.parkingRating.fillMode = 1
        cell.disabilityRating.rating = review.disabilityRating
        cell.disabilityRating.text = "\(review.disabilityRating)"
        cell.disabilityRating.fillMode = 1
        cell.languageRating.rating = review.languageRating
        cell.languageRating.text = "\(review.languageRating)"
        cell.languageRating.fillMode = 1
        cell.transportRating.rating = review.transportRating
        cell.transportRating.text = "\(review.transportRating)"
        cell.transportRating.fillMode = 1
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0
        {
            return 145
        }
        return 44
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
