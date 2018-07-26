//
//  ChatListCell.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 11/05/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class ChatListCell: UITableViewCell {
    @IBOutlet weak var vwUserName: UIView!
    @IBOutlet weak var lblFirstChar: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var lblTyme: UILabel!
    @IBOutlet weak var messagelabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
