//
//  UpdateCell.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 06/06/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class UpdateCell: UITableViewCell {
    
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tvText: UITextView!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
