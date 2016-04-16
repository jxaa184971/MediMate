//
//  FilterSwitchCell.swift
//  Medimate
//
//  Created by 一川 黄 on 16/04/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit

class FilterSwitchCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var filterSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func switchClicked(sender: AnyObject) {
        
    }

}
