//
//  ReceiverCell.swift
//  FireVintage
//
//  Created by NITS_Mac3 on 09/02/18.
//  Copyright © 2018 NITS_Mac2. All rights reserved.
//

import UIKit

class ReceiverCell: UITableViewCell {
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var imgVwRcvColor: UIImageView!
    @IBOutlet weak var imgVwReceiver: UIImageView!
    @IBOutlet weak var lblMsgRcvTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
