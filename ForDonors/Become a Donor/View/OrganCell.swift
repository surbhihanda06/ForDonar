//
//  OrganCell.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 22/05/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class OrganCell: UITableViewCell {
    @IBOutlet weak var vwCheck: UIView!
    @IBOutlet weak var imgVwCheck: UIImageView!
    
    @IBOutlet weak var lblOrganName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
