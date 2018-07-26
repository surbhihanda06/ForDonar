//
//  GenderCell.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 02/05/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class GenderCell: UITableViewCell {
    
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var tfGender: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
