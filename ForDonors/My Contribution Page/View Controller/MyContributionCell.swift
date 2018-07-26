//
//  MyContributionCell.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 19/06/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class MyContributionCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgVwCampaignImage: UIImageView!
    @IBOutlet weak var tblVwList: UITableView!
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
//        
//        tblVwList.reloadData()
//        
//        // if the table view is the last UI element, you might need to adjust the height
//        let size = CGSize(width: targetSize.width,
//                          height: tblVwList.frame.origin.y + tblVwList.contentSize.height)
//        return size
//        
//    }
    
    
    
    func setTableViewDataSourceDelegate
        <D: UITableViewDataSource & UITableViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
        tblVwList.delegate=dataSourceDelegate
        tblVwList.dataSource=dataSourceDelegate
        tblVwList.rowHeight = UITableViewAutomaticDimension
        tblVwList.estimatedRowHeight = 30.0
        tblVwList.tag = 1001
        //tableHeightConstraint.constant = tblVwList.contentSize.height
        
        
        tblVwList.register(UINib(nibName: "ContributeListCell", bundle: Bundle.main), forCellReuseIdentifier: "ContributeListCell")
        tblVwList.reloadData()
    }
    
}

