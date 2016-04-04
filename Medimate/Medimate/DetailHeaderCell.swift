//
//  DetailHeaderCell.swift
//  Medimate
//
//  Created by 一川 黄 on 20/03/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit

class DetailHeaderCell: UITableViewCell {

    @IBOutlet var picView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var reviewLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
