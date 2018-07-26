//
//  TopicCell.swift
//  ForDonors
//
//  Created by NITS_Mac4 on 16/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class TopicCell: UITableViewCell {
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfTopic: UITextField!
    @IBOutlet weak var btnTopic: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
