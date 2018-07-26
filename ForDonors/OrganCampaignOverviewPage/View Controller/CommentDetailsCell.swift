//
//  CommentDetailsCell.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 28/05/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class CommentDetailsCell: UITableViewCell {
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var tvDetails: UITextView!
    @IBOutlet weak var lblUserType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
