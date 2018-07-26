//
//  SubCategoryCell.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 27/02/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class SubCategoryCell: UICollectionViewCell {
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var lblSubCategoryName: UILabel!
    static let locationNameFont:UIFont = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.thin);
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
