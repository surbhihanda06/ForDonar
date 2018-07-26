//
//  AddImageCell.swift
//  ForDonors
//
//  Created by NITS_Mac4 on 16/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class AddImageCell: UITableViewCell {
    @IBOutlet weak var gallaryBtn: UIButton!
    @IBOutlet weak var videoBtn: UIButton!
    @IBOutlet weak var scrlVwImage: UIScrollView!
    @IBOutlet weak var btnChoose: UIButton!
    
    @IBOutlet weak var colVwImage: UICollectionView!
    @IBOutlet weak var imgvwPreview: UIImageView!
    @IBOutlet weak var vwPrvwPlay: UIView!
    @IBOutlet weak var imgvwPrvwPlay: UIImageView!
    @IBOutlet weak var btnPrvwPlay: UIButton!
    
    
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
        colVwImage.delegate = dataSourceDelegate
        colVwImage.dataSource = dataSourceDelegate
        colVwImage.tag = 1000
        
        colVwImage.alwaysBounceHorizontal = true
        //let nib = UINib(nibName: "ImageCell", bundle: Bundle.main)
        //colVwImage?.register(nib, forCellWithReuseIdentifier: "ImageCell")
        
        let nib = UINib(nibName: "ImageVideoShowCollectionViewCell", bundle: Bundle.main)
        colVwImage?.register(nib, forCellWithReuseIdentifier: "ImageVideoShowCollectionViewCell")
        
        
        
        let flowLayout: UICollectionViewFlowLayout? = (colVwImage.collectionViewLayout as? UICollectionViewFlowLayout)
        flowLayout?.minimumInteritemSpacing = 0.0
        flowLayout?.minimumLineSpacing = 0.0
        
        
        colVwImage.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        colVwImage.delegate=self
//        colVwImage.dataSource=self
//        colVwImage.alwaysBounceHorizontal = true
//        let nib = UINib(nibName: "ImageCell", bundle: Bundle.main)
//        colVwImage?.register(nib, forCellWithReuseIdentifier: "ImageCell")
//        let flowLayout: UICollectionViewFlowLayout? = (colVwImage.collectionViewLayout as? UICollectionViewFlowLayout)
//        flowLayout?.minimumInteritemSpacing = 0.0
//        flowLayout?.minimumLineSpacing = 0.0
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getYoutubeId(youtubeUrl: String) -> String? {
        return URLComponents(string: youtubeUrl)?.queryItems?.first(where: { $0.name == "v" })?.value
    }
    
   /* private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("arrGetImage.count--", arrGetImage.count)
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.backgroundColor = UIColor.red
        
       cell.imgVwImage.image = UIImage(named: "23")
        
        /*let details: NSDictionary = (arrGetImage[indexPath.row] as? NSDictionary)!
        let type: String = (details["type"] as? String)!
        if type == "url"
        {
            cell.imgVwImage.isHidden = true
            cell.videoPlayer.isHidden = false
            let getUrl: String = (details["ytUrl"] as? String)!
            let url: NSURL = NSURL(string: getUrl)!
            cell.videoPlayer.loadVideoURL(url as URL)
        }
        else if type == "image"
        {
            cell.imgVwImage.isHidden = false
            cell.videoPlayer.isHidden = true
            let image: UIImage = (details["image"] as? UIImage)!
            //cell.imgVwImage.image = UIImage(named: "23")
            cell.imgVwImage.image = image
        }*/
 
        return cell
        
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let details: NSDictionary = (arrGetImage[indexPath.row] as? NSDictionary)!
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 60)
    }*/
    
}
