//
//  LicenseNumberCell.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 04/05/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class LicenseNumberCell: UITableViewCell {
    
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var tfLicenseNumber: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
