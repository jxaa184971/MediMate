//
//  FilterButtonCell.swift
//  Medimate
//
//  Created by 一川 黄 on 17/04/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit

protocol FilterButtonClickedProtocol {
    
    func filterButtonClicked()
    
}


class FilterButtonCell: UITableViewCell {

    @IBOutlet var filterButton: UIButton!
    @IBOutlet var selectionLabel: UILabel!
    var delegate: FilterButtonClickedProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func filterButtonSelected(sender: AnyObject) {
        delegate.filterButtonClicked()
    }
}
