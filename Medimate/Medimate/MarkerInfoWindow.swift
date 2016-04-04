//
//  MarkerInfoWindow.swift
//  Medimate
//
//  Created by 一川 黄 on 28/03/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit


class MarkerInfoWindow: UIView {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var reviewLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    var facility:Facility!
    
    @IBAction func btnClicked(sender: AnyObject)
    {
        print("\(self.facility.name)")
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
