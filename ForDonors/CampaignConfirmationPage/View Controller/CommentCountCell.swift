//
//  CommentCountCell.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 18/04/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class CommentCountCell: UITableViewCell {

    @IBOutlet weak var btnAddComment: UIButton!
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var lblCommentCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
