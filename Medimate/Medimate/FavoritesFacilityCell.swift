//
//  FavoritesFacilityCell.swift
//  Medimate
//
//  Created by Yichuan Huang on 27/04/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit

class FavoritesFacilityCell: UITableViewCell {

    @IBOutlet var picView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
