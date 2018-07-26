//
//  ContributionListCell.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 03/07/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class ContributionListCell: UITableViewCell
{
    @IBOutlet weak var colVwContribution: UICollectionView!
    @IBOutlet weak var lblNoContribution: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int)
    {
        colVwContribution.delegate=dataSourceDelegate
        colVwContribution.dataSource=dataSourceDelegate
        //colVwContribution.tag = 1001
        
        //colVwContribution.alwaysBounceHorizontal = true
        //let nib = UINib(nibName: "ImageCell", bundle: Bundle.main)
        //colVwImage?.register(nib, forCellWithReuseIdentifier: "ImageCell")
        
        let nib = UINib(nibName: "ContributeDetailsCell", bundle: Bundle.main)
        colVwContribution?.register(nib, forCellWithReuseIdentifier: "ContributeDetailsCell")
        let flowLayout: UICollectionViewFlowLayout? = (colVwContribution.collectionViewLayout as? UICollectionViewFlowLayout)
        flowLayout?.minimumInteritemSpacing = 0.0
        flowLayout?.minimumLineSpacing = 0.0
        colVwContribution.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
