//
//  AskingPriceCell.swift
//  ForDonors
//
//  Created by NITS_Mac4 on 16/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class AskingPriceCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var PriceVw: UIView!
    @IBOutlet weak var tfPrice: UITextField!
    
  // @IBOutlet weak var askingPriceVw: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        PriceVw.layer.borderColor = UIColor.lightGray.cgColor
        PriceVw.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
