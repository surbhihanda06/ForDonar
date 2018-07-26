//
//  ExpiryDateCell.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 28/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class ExpiryDateCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfExpiryDate: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
