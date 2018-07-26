//
//  ParkDetailsCell.swift
//  ForDonors
//
//  Created by NITS_Mac4 on 16/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class ParkDetailsCell: UITableViewCell {
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var lbldate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vwMain.layer.borderColor = UIColor.lightGray.cgColor
        vwMain.layer.borderWidth = 1.0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
