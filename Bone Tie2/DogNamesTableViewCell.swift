//
//  DogNamesTableViewCell.swift
//  Bone Tie2
//
//  Created by Alex Arovas on 12/6/15.
//  Copyright © 2015 Alex Arovas. All rights reserved.
//

import UIKit

class DogNamesTableViewCell: UITableViewCell {
    @IBOutlet weak var DogImage: UIImageView!
    @IBOutlet weak var DogName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

