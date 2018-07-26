//
//  MenuTableViewCell.swift
//  ForDonors
//
//  Created by NITS_Mac4 on 21/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var menuImgVw: UIImageView!
    @IBOutlet weak var menuNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
