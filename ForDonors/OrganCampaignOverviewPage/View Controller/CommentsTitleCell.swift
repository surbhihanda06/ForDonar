//
//  CommentsTitleCell.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 28/05/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class CommentsTitleCell: UITableViewCell {

    @IBOutlet weak var btnAddComment: UIButton!
    @IBOutlet weak var btnAllComment: UIButton!
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
