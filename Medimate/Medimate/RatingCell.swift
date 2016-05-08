//
//  RatingCell.swift
//  Medimate
//
//  Created by 一川 黄 on 4/05/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit

class RatingCell: UITableViewCell {

    @IBOutlet var deviceLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var waitingTimeRating: CosmosView!
    @IBOutlet var parkingRating: CosmosView!
    @IBOutlet var disabilityRating: CosmosView!
    @IBOutlet var languageRating: CosmosView!
    @IBOutlet var transportRating: CosmosView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
