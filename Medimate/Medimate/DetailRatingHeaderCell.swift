//
//  DetailRatingHeaderCell.swift
//  Medimate
//
//  Created by 一川 黄 on 4/05/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit

class DetailRatingHeaderCell: UITableViewCell {

    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var cosmosView: CosmosView!
    @IBOutlet var reviewLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
