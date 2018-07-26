//
//  TableCell.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 04/04/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
