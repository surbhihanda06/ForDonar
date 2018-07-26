//
//  PerkCell.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 29/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class PerkCell: UITableViewCell {

    @IBOutlet weak var vwPerkImage: UIView!
    @IBOutlet weak var lblPerkName: UILabel!
    @IBOutlet weak var lblEstimatedDeliverDate: UILabel!
    @IBOutlet weak var tvPerkDescription: UITextView!
    @IBOutlet weak var btnGetThisPerk: UIButton!
    @IBOutlet weak var tvItems: UITextView!
    @IBOutlet weak var imgVwPerkImage: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
