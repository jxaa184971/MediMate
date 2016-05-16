//
//  RatingCell.swift
//  Medimate
//
//  Created by Yichuan Huang on 4/05/2016.
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
    
    
    @IBOutlet var waitingLabel: UILabel!
    @IBOutlet var parkingLabel: UILabel!
    @IBOutlet var disabilityLabel: UILabel!
    @IBOutlet var languageLabel: UILabel!
    @IBOutlet var transportLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
