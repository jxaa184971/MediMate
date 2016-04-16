//
//  FilterSwitchCell.swift
//  Medimate
//
//  Created by 一川 黄 on 16/04/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit

protocol SwitchClickedProtocol {
    // protocol definition goes here
    func switchChanged(sender: UISwitch, type: String)
    
}

class FilterSwitchCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var filterSwitch: UISwitch!
    var delegate:SwitchClickedProtocol!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchSeleted(sender: UISwitch) {
        print("Button \(self.titleLabel.text!) seleted")
        delegate.switchChanged(sender, type: self.titleLabel.text!)
    }
    

}
