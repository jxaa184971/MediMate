//
//  MainMenuViewController.swift
//  Medimate
//
//  Created by 一川 黄 on 18/03/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit


class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        }
        if segue.identifier == "clinicSegue"
        {
            controller.searchCategory = "Clinic"
        }
        if segue.identifier == "dentistSegue"
        {
            controller.searchCategory = "Dentist"
        }
        if segue.identifier == "phySegue"
        {
            controller.searchCategory = "Physiotheropist"
        }
        if segue.identifier == "chiroSegue"
        {
            controller.searchCategory = "Chiro"
        }
    }
}
