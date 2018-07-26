//
//  ContributeDetailsCell.swift
//  ForDonors
//
//  Created by NITS_Mac5 on 04/07/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class ContributeDetailsCell: UICollectionViewCell
{
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        cellImageView.layer.cornerRadius = cellImageView.frame.size.width / 2
        // Initialization code
    }

}
