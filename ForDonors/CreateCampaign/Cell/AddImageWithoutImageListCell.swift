//
//  AddImageWithoutImageListCell.swift
//  ForDonors
//
//  Created by NITS_Mac4 on 16/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class AddImageWithoutImageListCell: UITableViewCell {
    @IBOutlet weak var gallaryBtn: UIButton!
    @IBOutlet weak var videoBtn: UIButton!
    
    @IBOutlet weak var imgvwPreview: UIImageView!
    @IBOutlet weak var vwPrvwPlay: UIView!
    @IBOutlet weak var imgvwPrvwPlay: UIImageView!
    @IBOutlet weak var btnPrvwPlay: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
