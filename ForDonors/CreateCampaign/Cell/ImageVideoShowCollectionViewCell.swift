//
//  ImageVideoShowCollectionViewCell.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 27/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class ImageVideoShowCollectionViewCell: UICollectionViewCell {
  
    @IBOutlet weak var imgVwPlay: UIImageView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet var imgvwToShow: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    //@IBOutlet weak var videoPlayer: YouTubePlayerView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
