//
//  SideFilterTableViewController.swift
//  Medimate
//
//  Created by 一川 黄 on 15/04/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit

class SideFilterTableViewController: UITableViewController, SwitchClickedProtocol{

    var languageSeleted:Bool = false
    var locationSeleted:Bool = false
    var radiusSelected:Bool = false
    
    var showBulkBilling:Bool = true
    
    var languages:Array<String> = LanguageHelper.otherLanguageArray
    var locations:Array<String> = SuburbHelper.suburbArray
    
    var mainViewController: SearchListTableViewController!
    var filter:[String:String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.sectionFooterHeight = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if self.showBulkBilling
        {
            return 4
        }
        else
        {
            return 3
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 && self.languageSeleted
        {
            return (self.languages.count + 1)
        }
        if section == 1 && self.locationSeleted
        {
            return (self.locations.count + 1)
        }
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0
        {
            
            if indexPath.section == 0
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("titleCell", forIndexPath: indexPath) as! FilterTitleCell
                cell.titleLabel.text = NSLocalizedString("Language", comment: "")
                cell.valueLabel.text = self.mainViewController.filter["language"]
                if self.languageSeleted
                {
                    cell.picView.image = UIImage(named: "arrow_up.jpeg")
                }
                else
                {
                    cell.picView.image = UIImage(named: "arrow_down.jpeg")
                }
                return cell
            }
            if indexPath.section == 1
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("titleCell", forIndexPath: indexPath) as! FilterTitleCell
                cell.titleLabel.text = NSLocalizedString("Search Location", comment: "")
                cell.valueLabel.text = self.mainViewController.filter["searchLocation"]
                if self.locationSeleted
                {
                    cell.picView.image = UIImage(named: "arrow_up.jpeg")
                }
                else
                {
                    cell.picView.image = UIImage(named: "arrow_down.jpeg")
                }
                return cell
            }
            if indexPath.section == 2
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("switchCell", forIndexPath: indexPath) as! FilterSwitchCell
                cell.titleLabel.text = NSLocalizedString("Open Now", comment: "")
                cell.filterSwitch.on = false
                cell.delegate = self
                return cell
            }
            if indexPath.section == 3
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("switchCell", forIndexPath: indexPath) as! FilterSwitchCell
                cell.titleLabel.text = NSLocalizedString("Bulk Billing", comment: "")
                cell.filterSwitch.on = false
                cell.delegate = self
                return cell
            }
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("valueCell", forIndexPath: indexPath) as! FilterTitleCell
            if indexPath.section == 0
            {
                if languages[indexPath.row - 1] == mainViewController.filter["language"]
                {
                    cell.titleLabel.text = "\(languages[indexPath.row - 1]) (✓)"
                }
                else
                {
                    cell.titleLabel.text = languages[indexPath.row - 1]
                }
            }
            if indexPath.section == 1
            {
                if locations[indexPath.row - 1] == mainViewController.filter["searchLocation"]
                {
                    cell.titleLabel.text = "\(locations[indexPath.row - 1]) (✓)"
                }
                else
                {
                    cell.titleLabel.text = locations[indexPath.row - 1]
                }
            }
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0
        {
            if indexPath.section == 0
            {
                self.languageSeleted = !self.languageSeleted
            }
            if indexPath.section == 1
            {
                self.locationSeleted = !self.locationSeleted
            }
            self.tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Fade)
        }
        else
        {
            if indexPath.section == 0
            {
                mainViewController.filter["language"] = self.languages[indexPath.row - 1]
            }
            if indexPath.section == 1
            {
                mainViewController.filter["searchLocation"] = self.locations[indexPath.row - 1]
            }
            self.tableView.reloadData()
            mainViewController.refresh()
            if mainViewController.isList == false
            {
                mainViewController.updateMarkers()
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 && (indexPath.section == 0 || indexPath.section == 1)
        {
            return 65
        }
        return self.tableView.rowHeight
    }
    
    // MARK: - Switch Clicked Protocol
    
    func switchChanged(sender: UISwitch, type: String)
    {
        if type == NSLocalizedString("Open Now", comment: "")
        {
            self.mainViewController.onlyShowOpenNow = sender.on
        }
        if type == NSLocalizedString("Bulk Billing", comment: "")
        {
            self.mainViewController.onlyBulkBilling = sender.on
        }
        self.mainViewController.refresh()
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
