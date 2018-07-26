//
//  SelectWeightCell.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 30/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class SelectWeightCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfWeight: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
