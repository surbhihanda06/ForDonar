//
//  CollaboratorCell.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 29/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class CollaboratorCell: UITableViewCell {
    @IBOutlet weak var vwCollaborator: UIView!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}