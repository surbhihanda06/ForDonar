//
//  CategoryCell.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 27/02/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var lblSelected: UILabel!
    
    static let locationNameFont:UIFont = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.thin);
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
