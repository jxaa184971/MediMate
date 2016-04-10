//
//  SettingEditTableViewController.swift
//  Medimate
//
//  Created by 一川 黄 on 10/04/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit

class SettingEditTableViewController: UITableViewController {

    var settingType: String!
    var settingValues: Array<String>!
    var currentSetting: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.settingValues = [NSLocalizedString("Default Language", comment:""), "中文", "Español"]
        self.navigationItem.title = NSLocalizedString("\(settingType)", comment:"")
        
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
        return self.settingValues.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("settingValueCell", forIndexPath: indexPath) as! SettingValueCell
        if self.currentSetting == self.settingValues[indexPath.row]
        {
            cell.valueLabel.text = "\(self.settingValues[indexPath.row]) (✓)"
        }
        else
        {
            cell.valueLabel.text = self.settingValues[indexPath.row]
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if settingType == NSLocalizedString("Language", comment:"")
        {
            var newLanguage = ""
            if indexPath.row == 0
            {
                newLanguage = NSLocalizedString("Default Language", comment:"")
            }
            if indexPath.row == 1
            {
                newLanguage = "中文"
            }
            if indexPath.row == 2
            {
                newLanguage = "Español"
            }
            
            self.showLanguageChangeAlert(newLanguage)
        }
    }

    func showLanguageChangeAlert(changeLanguage:String)
    {
        let title = "\(NSLocalizedString("Are you sure to change the language to", comment:"")) \(changeLanguage)?"
        let message = NSLocalizedString("The language change will take effect after restart the application.", comment:"")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .Default, handler:
            { (action:UIAlertAction!) in
                self.currentSetting = changeLanguage
                self.setLanguage()
        })

        let cancelAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
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

    // MARK: - Language Change
    func setLanguage()
    {
        if self.currentSetting == NSLocalizedString("Default Language", comment:"")
        {
            NSUserDefaults.standardUserDefaults().setObject(["en"], forKey: "AppleLanguages")
        }
        if self.currentSetting == "中文"
        {
            NSUserDefaults.standardUserDefaults().setObject(["zh-Hans"], forKey: "AppleLanguages")
        }
        if self.currentSetting == "Español"
        {
            NSUserDefaults.standardUserDefaults().setObject(["es"], forKey: "AppleLanguages")
        }
        self.tableView.reloadData()
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
