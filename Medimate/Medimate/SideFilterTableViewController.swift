//
//  SideFilterTableViewController.swift
//  Medimate
//
//  Created by Yichuan Huang on 15/04/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit

class SideFilterTableViewController: UITableViewController, SwitchClickedProtocol, HeaderBtnClickedProtocol{

    var languageSeleted:Bool = false
    var locationSeleted:Bool = false
    var categorySelected:Bool = false
    
    var showBulkBilling:Bool = true
    
    var languages:Array<String> = LanguageHelper.otherLanguageArray
    var locations:Array<String> = SuburbHelper.suburbArray
    var categories:Array<String> = ["GP", "Dentist", "Physiotherapist", "Pharmacy"]
    var searchController: SearchListTableViewController!
    var filter:[String:String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
        self.tableView.sectionFooterHeight = 0
        tableView.alwaysBounceVertical = false

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
            return 6
        }
        else
        {
            return 5
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 1 && self.categorySelected
        {
            return (self.categories.count + 1)
        }
        if section == 2 && self.languageSeleted
        {
            return (self.languages.count + 1)
        }
        if section == 3 && self.locationSeleted
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
                let color = UIColor(red: 40/255, green: 130/255, blue: 200/255, alpha: 1)
                
                let cell = tableView.dequeueReusableCellWithIdentifier("headerCell", forIndexPath: indexPath) as! FilterHeaderCell
                cell.backgroundColor = color
                cell.backButton.setTitle(NSLocalizedString("< Back", comment: ""), forState: .Normal)
                cell.resetButton.setTitle(NSLocalizedString("Reset", comment: ""), forState: .Normal)
                cell.delegate = self
                cell.selectionStyle = .None
                return cell
            }
            if indexPath.section == 1
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("titleCell", forIndexPath: indexPath) as! FilterTitleCell
                cell.titleLabel.text = NSLocalizedString("Search Category", comment: "")
                cell.valueLabel.text = NSLocalizedString(self.searchController.searchCategory, comment: "")
                if self.categorySelected
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
                let cell = tableView.dequeueReusableCellWithIdentifier("titleCell", forIndexPath: indexPath) as! FilterTitleCell
                cell.titleLabel.text = NSLocalizedString("Language Spoken", comment: "")
                cell.valueLabel.text = self.searchController.filter["language"]
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
            if indexPath.section == 3
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("titleCell", forIndexPath: indexPath) as! FilterTitleCell
                cell.titleLabel.text = NSLocalizedString("Search Location", comment: "")
                cell.valueLabel.text = self.searchController.filter["searchLocation"]
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
            if indexPath.section == 4
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("switchCell", forIndexPath: indexPath) as! FilterSwitchCell
                cell.titleLabel.text = NSLocalizedString("Open Now", comment: "")
                cell.filterSwitch.on = self.searchController.onlyShowOpenNow
                cell.delegate = self
                return cell
            }
            if indexPath.section == 5
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("switchCell", forIndexPath: indexPath) as! FilterSwitchCell
                cell.titleLabel.text = NSLocalizedString("Bulk Billing", comment: "")
                cell.filterSwitch.on = self.searchController.onlyBulkBilling
                cell.delegate = self
                return cell
            }
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("valueCell", forIndexPath: indexPath) as! FilterTitleCell
            if indexPath.section == 1
            {
                if categories[indexPath.row - 1] == searchController.searchCategory
                {
                    cell.titleLabel.text = "\(NSLocalizedString(categories[indexPath.row - 1], comment: "")) (✓)"
                }
                else
                {
                    cell.titleLabel.text = NSLocalizedString(categories[indexPath.row - 1], comment: "")
                }
            }
            if indexPath.section == 2
            {
                if languages[indexPath.row - 1] == searchController.filter["language"]
                {
                    cell.titleLabel.text = "\(languages[indexPath.row - 1]) (✓)"
                }
                else
                {
                    cell.titleLabel.text = languages[indexPath.row - 1]
                }
            }
            if indexPath.section == 3
            {
                if locations[indexPath.row - 1] == searchController.filter["searchLocation"]
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
            if indexPath.section == 1
            {
                self.categorySelected = !self.categorySelected
            }
            if indexPath.section == 2
            {
                self.languageSeleted = !self.languageSeleted
            }
            if indexPath.section == 3
            {
                self.locationSeleted = !self.locationSeleted
            }
            self.tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Fade)
        }
        else
        {
            if indexPath.section == 1
            {
                if self.categories[indexPath.row - 1] == "GP"
                {
                    self.showBulkBilling = true
                }
                else
                {
                    self.showBulkBilling = false
                }
                searchController.searchCategory = self.categories[indexPath.row - 1]
                searchController.requestForNewData()
                searchController.refresh()
                self.categorySelected = !self.categorySelected
                self.tableView.reloadData()
            }
            if indexPath.section == 2
            {
                searchController.filter["language"] = self.languages[indexPath.row - 1]
                self.languageSeleted = !self.languageSeleted
            }
            if indexPath.section == 3
            {
                searchController.filter["searchLocation"] = self.locations[indexPath.row - 1]
                self.locationSeleted = !self.locationSeleted
            }
            self.tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Fade)
            searchController.refresh()
            if searchController.isList == false
            {
                searchController.updateMarkers()
            }
            
            let mainController = self.searchController.navigationController?.viewControllers[0] as! MainMenuViewController
            mainController.filter = searchController.filter
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 && (indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3)
        {
            return 65
        }
        if indexPath.section == 0
        {
            return 66
        }
        return 50
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
            return 0
        }
        return self.tableView.sectionHeaderHeight
    }
    
    // MARK: - Switch Clicked Protocol
    
    func switchChanged(sender: UISwitch, type: String)
    {
        if type == NSLocalizedString("Open Now", comment: "")
        {
            self.searchController.onlyShowOpenNow = sender.on
        }
        if type == NSLocalizedString("Bulk Billing", comment: "")
        {
            self.searchController.onlyBulkBilling = sender.on
        }
        self.searchController.refresh()
        let mainController = self.searchController.navigationController?.viewControllers[0] as! MainMenuViewController
        mainController.onlyShowOpenNow = searchController.onlyShowOpenNow
        mainController.onlyBulkBilling = searchController.onlyBulkBilling
    }
    
    // MARK: - Header Button Clicked Protocol
    func backButtonClicked()
    {
        searchController.filterButtonClicked()
    }
    
    func resetButtonClicked()
    {
        self.searchController.onlyShowOpenNow = false
        self.searchController.onlyBulkBilling = false
        self.searchController.searchCategory = self.searchController.initialSearchCategory
        self.searchController.filter["searchLocation"] = NSLocalizedString("Current Location (Within 5km)", comment:"")
        self.searchController.filter["language"] = "English"
        self.filter = self.searchController.filter
        self.searchController.requestForNewData()
        self.searchController.refresh()
        self.tableView.reloadData()
        
        let mainController = self.searchController.navigationController?.viewControllers[0] as! MainMenuViewController
        mainController.filter = searchController.filter

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
