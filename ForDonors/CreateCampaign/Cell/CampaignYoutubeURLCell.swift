//
//  CampaignYoutubeURLCell.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 28/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class CampaignYoutubeURLCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwHolder: UIView!
    @IBOutlet weak var tfYoutubeURL: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        vwHolder.layer.borderColor = UIColor.lightGray.cgColor
        vwHolder.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
