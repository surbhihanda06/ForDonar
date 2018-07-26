//
//  PerkImageCell.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 03/04/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class PerkImageCell: UITableViewCell {
    @IBOutlet weak var imgVwPerkImage: UIImageView!
    @IBOutlet weak var vwImage: UIView!
    @IBOutlet weak var btnImage: UIButton!
    @IBOutlet weak var cameraBorderImgVW: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
