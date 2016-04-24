//
//  ProfileTableViewController.swift
//  Medimate
//
//  Created by Yichuan Huang on 10/04/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    var settings:[String:String]!        //settings

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let color = UIColor(red: 40/255, green: 130/255, blue: 200/255, alpha: 1)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let languages = NSUserDefaults.standardUserDefaults().objectForKey("AppleLanguages") as! NSArray
        let language = languages[0] as! String
        if language == "zh-Hans"
        {
            self.settings = [NSLocalizedString("System Language", comment:""): "中文"]
        }
        else if language == "es"
        {
            self.settings = [NSLocalizedString("System Language", comment:""): "Español"]
        }
        else if language == "en"
        {
            self.settings = [NSLocalizedString("System Language", comment:""): "English"]
        }
        
        NSUserDefaults.standardUserDefaults().setObject(["zh-Hans"], forKey: "AppleLanguages")
        NSUserDefaults.standardUserDefaults().synchronize()
        
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
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("settingCell", forIndexPath: indexPath) as! SettingCell
            cell.titleLabel.text = NSLocalizedString("System Language", comment:"")
            cell.valueLabel.text = self.settings["\(NSLocalizedString("System Language", comment:""))"]
            return cell
        }
        
        return UITableViewCell()
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "settingSegue"
        {
            let indexPath = self.tableView.indexPathForSelectedRow
            if indexPath?.row == 0
            {
                let controller = segue.destinationViewController as! SettingEditTableViewController
                controller.settingType = NSLocalizedString("System Language", comment:"")
                controller.currentSetting = self.settings["\(NSLocalizedString("System Language", comment:""))"]
            }
        }
    }
 

}
