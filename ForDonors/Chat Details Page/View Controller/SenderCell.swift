//
//  SenderCell.swift
//  FireVintage
//
//  Created by NITS_Mac3 on 09/02/18.
//  Copyright © 2018 NITS_Mac2. All rights reserved.
//

import UIKit

class SenderCell: UITableViewCell {
    @IBOutlet weak var imgVwSender: UIImageView!
    @IBOutlet weak var imgVwSenderColor: UIImageView!
    @IBOutlet weak var lblSendingMessage: UILabel!
    @IBOutlet weak var lblMsgSendTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
