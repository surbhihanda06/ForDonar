//
//  ConnectionTypeCell.swift
//  ForDonors
//
//  Created by NITS_Mac4 on 15/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class ConnectionTypeCell: UITableViewCell {
    @IBOutlet weak var connectionTypeName: UILabel!
    @IBOutlet weak var connectionLogo: UIImageView?
   
    @IBOutlet weak var switchLogo: UISwitch?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
