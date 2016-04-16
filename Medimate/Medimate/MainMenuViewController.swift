//
//  MainMenuViewController.swift
//  Medimate
//
//  Created by 一川 黄 on 18/03/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit


class MainMenuViewController: UIViewController {

    @IBOutlet var rightBarButton: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tabBarController?.tabBar.hidden = false

    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
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
        if segue.identifier == "dentistSegue"
        {
            controller.searchCategory = "Dentist"
        }
        if segue.identifier == "pharmacySegue"
        {
            controller.searchCategory = "Pharmacy"
        }
        if segue.identifier == "physioSegue"
        {
            controller.searchCategory = "Physiotherapist"
        }
    }
}
