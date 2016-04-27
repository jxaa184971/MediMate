//
//  MainMenuViewController.swift
//  Medimate
//
//  Created by Yichuan Huang on 18/03/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit


class MainMenuViewController: UIViewController {

    @IBOutlet var rightBarButton: UINavigationItem!
    
    @IBOutlet var gpButton: UIButton!
    @IBOutlet var dentistButton: UIButton!
    @IBOutlet var physioButton: UIButton!
    @IBOutlet var pharmacyButton: UIButton!
    
    
    var filter:[String:String]!        //filter settings
    var onlyShowOpenNow = false        //only show the open facility or not
    var onlyBulkBilling = false        //only show the facility support bulk billing
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize filter settings
        self.filter = ["searchLocation":NSLocalizedString("Current Location (Within 5km)", comment:""), "language": "English", "sortBy": NSLocalizedString("Distance",comment:""), "postCode":""]
        
        // change the style of navigation bar          
        let color = UIColor(red: 40/255, green: 130/255, blue: 200/255, alpha: 1)

        self.tabBarController?.tabBar.hidden = false
        self.tabBarController?.tabBar.tintColor = color
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBar.barTintColor = color

        // change button UI
        self.gpButton.backgroundColor = color
        self.gpButton.setTitle(NSLocalizedString("General Practitioner", comment: ""), forState: .Normal)
        self.dentistButton.backgroundColor = color
        self.dentistButton.setTitle(NSLocalizedString("Dentist", comment: ""), forState: .Normal)
        self.physioButton.backgroundColor = color
        self.physioButton.setTitle(NSLocalizedString("Physiotherapist", comment: ""), forState: .Normal)
        self.pharmacyButton.backgroundColor = color
        self.pharmacyButton.setTitle(NSLocalizedString("Pharmacy", comment: ""), forState: .Normal)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
        if self.revealViewController() != nil
        {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let controller = segue.destinationViewController as! SearchListTableViewController

        if segue.identifier == "gpSegue"
        {
            controller.searchCategory = "GP"
            controller.onlyBulkBilling = self.onlyBulkBilling
            controller.initialSearchCategory = "GP"
        }
        if segue.identifier == "dentistSegue"
        {
            controller.searchCategory = "Dentist"
            controller.initialSearchCategory = "Dentist"
        }
        if segue.identifier == "pharmacySegue"
        {
            controller.searchCategory = "Pharmacy"
            controller.initialSearchCategory = "Pharmacy"
        }
        if segue.identifier == "physioSegue"
        {
            controller.searchCategory = "Physiotherapist"
            controller.initialSearchCategory = "Physiotherapist"
        }
        controller.filter = self.filter
        controller.onlyShowOpenNow = self.onlyShowOpenNow
    }
}
