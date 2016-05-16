//
//  ButtonCell.swift
//  Medimate
//
//  Created by Yichuan Huang on 8/05/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit

protocol ButtonClickedProtocol {
    
    func saveButtonClicked()
    
    func cancelButtonClicked()
}

class ButtonCell: UITableViewCell {

    @IBOutlet var addReviewButton: UIButton!
    var delegate:ButtonClickedProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonClicked(sender: UIButton) {
        if sender.currentTitle == NSLocalizedString("Save", comment: "")
        {
            self.delegate.saveButtonClicked()
        }
        if sender.currentTitle == NSLocalizedString("Cancel", comment: "")
        {
            self.delegate.cancelButtonClicked()
        }
    }

}
