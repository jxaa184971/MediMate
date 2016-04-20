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
    
    @IBOutlet var gpButton: UIButton!
    @IBOutlet var dentistButton: UIButton!
    @IBOutlet var physioButton: UIButton!
    @IBOutlet var pharmacyButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let color = UIColor(red: 40/255, green: 130/255, blue: 200/255, alpha: 1)

        self.tabBarController?.tabBar.hidden = false
        self.tabBarController?.tabBar.tintColor = color
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBar.barTintColor = color

        
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
