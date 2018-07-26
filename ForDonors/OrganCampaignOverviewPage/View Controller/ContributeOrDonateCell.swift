//
//  ContributeOrDonateCell.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 28/05/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class ContributeOrDonateCell: UITableViewCell {
    @IBOutlet weak var btnContribute: UIButton!
    @IBOutlet weak var btnDonate: UIButton!
    
    @IBOutlet weak var btnPublish: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
