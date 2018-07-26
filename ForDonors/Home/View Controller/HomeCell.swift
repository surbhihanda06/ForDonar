//
//  HomeCell.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 27/02/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {
    @IBOutlet weak var imgVwCoverImage: UIImageView!
    @IBOutlet weak var vwImage: UIView!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblRefund: UILabel!
    @IBOutlet weak var lblDaysLeft: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lblNameTopconstraints: NSLayoutConstraint!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var btnLikeUnlike: UIButton!
    @IBOutlet weak var imgVwLikeUnlike: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.vwImage.layer.masksToBounds = true
        self.vwImage.layer.cornerRadius = self.vwImage.frame.size.height / 2
        self.vwImage.layer.borderWidth = 1.0
        self.vwImage.layer.borderColor = UIColor.darkGray.cgColor
        
        self.imgVwUser.layer.masksToBounds = true
        self.imgVwUser.layer.cornerRadius = self.imgVwUser.frame.size.height / 2
        self.imgVwUser.layer.borderWidth = 1.0
        self.imgVwUser.layer.borderColor = UIColor.darkGray.cgColor
        self.progressBar.transform = self.progressBar.transform.scaledBy(x: 1, y: 2)
        //self.imgVwUser.makeMultigonal(sides: 3)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
