//
//  CollaboratorContainerCell.swift
//  ForDonors
//
//  Created by NITS_Mac4 on 16/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class CollaboratorContainerCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAddCollaborator: UIButton!
    @IBOutlet weak var collaboratorList: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
        collaboratorList.delegate=dataSourceDelegate
        collaboratorList.dataSource=dataSourceDelegate
        collaboratorList.tag = 1001
        
        collaboratorList.alwaysBounceHorizontal = true
        //let nib = UINib(nibName: "ImageCell", bundle: Bundle.main)
        //colVwImage?.register(nib, forCellWithReuseIdentifier: "ImageCell")
        
        let nib = UINib(nibName: "CollaboratorListCell", bundle: Bundle.main)
        collaboratorList?.register(nib, forCellWithReuseIdentifier: "CollaboratorListCell")
        let flowLayout: UICollectionViewFlowLayout? = (collaboratorList.collectionViewLayout as? UICollectionViewFlowLayout)
        flowLayout?.minimumInteritemSpacing = 0.0
        flowLayout?.minimumLineSpacing = 0.0
        collaboratorList.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
//    //MARK: CollectionViewDelegate
//    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
//    {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
//    {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollaboratorListCell", for: indexPath) as! CollaboratorListCell
//        cell.collaboratorImgvw.layer.cornerRadius = cell.collaboratorImgvw.frame.size.height/2
//        cell.collaboratorImgvw.clipsToBounds = true
//        return cell
//    }
//    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
//    {
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0.0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout
//        collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0.0
//    }
    
    
    
   /* func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellCount = CGFloat(10)
        
        if cellCount > 0 {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidth = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing
            let totalCellWidth = cellWidth*cellCount + 5*(cellCount-1)
            let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right
            
            if (totalCellWidth < contentWidth) {
                let padding = (contentWidth - totalCellWidth) / 2.0
                return UIEdgeInsetsMake(0, padding, 0, padding)
            }
        }
        return UIEdgeInsets.zero
    }*/
    
}

