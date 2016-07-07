//
//  LostTableViewCell.swift
//  Bone Tie2
//
//  Created by Alex Arovas on 12/7/15.
//  Copyright © 2015 Alex Arovas. All rights reserved.
//

import UIKit

class LostTableViewCell: UICollectionViewCell {
    @IBOutlet weak var DogImages: UIImageView!
    @IBOutlet weak var DogNames: UILabel!
    @IBOutlet weak var LostView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DogImages.frame = CGRectZero
        DogNames.frame = CGRectMake(50, 50, 100, 10)
    }

    func setSelected(selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
