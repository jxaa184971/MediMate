//
//  FilterTableViewController.swift
//  Medimate
//
//  Created by 一川 黄 on 22/03/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {

    var filterType: String!
    var titleSet: Array<String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var title = ""
        if filterType == "searchLocation"
        {
            self.titleSet = SuburbHelper.suburbArray
            title = NSLocalizedString("Search Location", comment:"")
        }
        if filterType == "language"
        {
            self.titleSet = LanguageHelper.otherLanguageArray
            title = NSLocalizedString("GP's Language", comment:"")
        }
        if filterType == "sortBy"
        {
            self.titleSet = [NSLocalizedString("Distance", comment:""), NSLocalizedString("Rating", comment:""), NSLocalizedString("Popularity", comment:"")]
            title = NSLocalizedString("Sort By", comment:"")
        }
        self.navigationItem.title = title
        
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.titleSet.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("valueCell", forIndexPath: indexPath) as! FilterValueCell
        cell.valueLabel.text = self.titleSet[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = self.navigationController?.viewControllers[1] as! SearchListTableViewController
        controller.filter[self.filterType] = self.titleSet[indexPath.row]
        controller.numberOfRowsShowed = 10
        controller.refresh()
        if controller.isList == false
        {
            controller.updateMarkers()
        }
        self.navigationController?.popToViewController(controller, animated: true)
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
