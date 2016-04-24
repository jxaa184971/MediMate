//
//  FilterHeaderCell.swift
//  Medimate
//
//  Created by 一川 黄 on 24/04/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit

protocol HeaderBtnClickedProtocol {
    // protocol definition goes here
    func backButtonClicked()
    
    func resetButtonClicked()
    
}
class FilterHeaderCell: UITableViewCell {

    @IBOutlet var backButton: UIButton!
    @IBOutlet var resetButton: UIButton!
    var delegate:HeaderBtnClickedProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func backButtonClicked(sender: UIButton) {
        delegate.backButtonClicked()
    }

    @IBAction func resetButtonClicked(sender: UIButton) {
        delegate.resetButtonClicked()
    }
}
