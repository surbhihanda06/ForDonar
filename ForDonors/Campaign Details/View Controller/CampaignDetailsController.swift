//
//  CampaignDetailsController.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 30/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class CampaignDetailsController: UIViewController {

    @IBOutlet weak var lblPageTitle: UILabel!
    @IBOutlet weak var tblVwCapaignDetails: UITableView!
    
    var dicCampaignDetails: CampaignDetails!
    
    var allPerk = [Perks]()
    var allCollaborator = [CollaboratorDetails]()
    var alIImages: NSMutableArray = NSMutableArray()
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cellRegistration()
    }

    override func viewWillAppear(_ animated: Bool) {
        lblPageTitle.text = "Campaign Details".localized
        allPerk = dicCampaignDetails.perks
        allCollaborator = dicCampaignDetails.collaborators_user
        alIImages = dicCampaignDetails.image
        tblVwCapaignDetails.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Register Nib
    
    func cellRegistration()   {
        tblVwCapaignDetails.register(UINib(nibName: "NameCell", bundle: Bundle.main), forCellReuseIdentifier: "NameCell")
        
        tblVwCapaignDetails.register(UINib(nibName: "ScrollImageCell", bundle: Bundle.main), forCellReuseIdentifier: "ScrollImageCell")
        
        tblVwCapaignDetails.register(UINib(nibName: "PriceCell", bundle: Bundle.main), forCellReuseIdentifier: "PriceCell")
        
        tblVwCapaignDetails.register(UINib(nibName: "DateCell", bundle: Bundle.main), forCellReuseIdentifier: "DateCell")
        
        tblVwCapaignDetails.register(UINib(nibName: "GetLocationCell", bundle: Bundle.main), forCellReuseIdentifier: "GetLocationCell")
        
        tblVwCapaignDetails.register(UINib(nibName: "GetDescriptionCell", bundle: Bundle.main), forCellReuseIdentifier: "GetDescriptionCell")
        
        tblVwCapaignDetails.register(UINib(nibName: "SelectAPerkCell", bundle: Bundle.main), forCellReuseIdentifier: "SelectAPerkCell")
        
        tblVwCapaignDetails.register(UINib(nibName: "PerkCell", bundle: Bundle.main), forCellReuseIdentifier: "PerkCell")
        
        tblVwCapaignDetails.register(UINib(nibName: "CollaboratorTitleCell", bundle: Bundle.main), forCellReuseIdentifier: "CollaboratorTitleCell")
        
        tblVwCapaignDetails.register(UINib(nibName: "CollaboratorCell", bundle: Bundle.main), forCellReuseIdentifier: "CollaboratorCell")
        
        tblVwCapaignDetails.register(UINib(nibName: "ConfirmCell", bundle: Bundle.main), forCellReuseIdentifier: "ConfirmCell")
        
    }

    // MARK: - Navigation
    
    func imagePressed(_ sender: Any)
    {
        let moveViewController = TopicListController()
        self.navigationController?.pushViewController(moveViewController, animated: true)
    }

    @IBAction func btnBackPressed(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
}

extension CampaignDetailsController: UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = allPerk.count
        let count1 = allCollaborator.count
        print("Total Row:",count + count1 + 9)
        return count + count1 + 9
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row==0
        {
            return 60
        }
        else if indexPath.row==1
        {
            
            return 300
        }
        else if indexPath.row==2
        {
            
            return 80
        }
        else if indexPath.row==3
        {
            
            return 76
        }
        else if indexPath.row==4
        {
            return 60
        }
        else if indexPath.row==5
        {
            return UITableViewAutomaticDimension
        }
        else if indexPath.row==6
        {
            
            return 56
        }
        if allPerk.count > 0 && indexPath.row > 6
        {
            if allPerk.count >= indexPath.row - 6
            {
                return UITableViewAutomaticDimension
            }
            else if allPerk.count >= indexPath.row - 7
            {
                return 60
            }
            else
            {
                if allCollaborator.count > 0 && indexPath.row > 8
                {
                    if allCollaborator.count >= indexPath.row - 8
                    {
                        return 100
                    }
                    else
                    {
                        return 60
                    }
                }
                else
                {
                    return 60
                }
            }
            
        }
        else if indexPath.row==allPerk.count + indexPath.row
        {
            if allCollaborator.count > 0 && indexPath.row > 7
            {
                if allCollaborator.count >= indexPath.row - 7
                {
                    return 100
                }
                else
                {
                    return 60
                }
            }
            else
            {
                return 60
            }
        }
        else
        {
            if indexPath.row==7
            {
                return 60
            }
            else
            {
                
                return 60
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row==0
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! NameCell
            cell.lblName.text = dicCampaignDetails.campaign_name
            
            
            
            return cell
        }
        else if indexPath.row==1
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "ScrollImageCell", for: indexPath) as! ScrollImageCell
            cell.lblName.text = dicCampaignDetails.campaign_type
            for index in 0..<alIImages.count {
                
                frame.origin.x = cell.scrlVwImage.frame.size.width * CGFloat(index)
                frame.size = cell.scrlVwImage.frame.size
                let images = alIImages[index]
                let imageUrl = images
                var imageView : UIImageView
                imageView  = UIImageView(frame:frame)
                //imageView.translatesAutoresizingMaskIntoConstraints = false
                //imageView.addConstraints([NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: CGFloat(1), constant: CGFloat(0))])
                
                
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.sd_setImage(with: URL(string: imageUrl as! String ), placeholderImage: UIImage(named: No_Image))
                
                var btn : UIButton
                btn  = UIButton(frame:frame);
                btn.tag = index
                //btn.addTarget(self, action: #selector(imagePressed(sender:)), for: UIControlEvents.touchUpInside)
                
                cell.scrlVwImage .addSubview(imageView)
                cell.scrlVwImage .addSubview(btn)
            }
            
            cell.scrlVwImage.contentSize = CGSize(width: self.view.frame.size.width * CGFloat(alIImages.count), height: cell.scrlVwImage.frame.size.height)
            
            return cell
        }
        else if indexPath.row==2
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "PriceCell", for: indexPath) as! PriceCell
            let getPrice = dicCampaignDetails.goal_amount
            if getPrice != nil
            {
                //cell.lblPrice.text = "$" + String(getPrice)
                cell.lblPrice.text = "$" + String(format:"%d",getPrice!)
            }
            
            return cell
        }
        else if indexPath.row==3
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! DateCell
            return cell
        }
        else if indexPath.row==4
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "GetLocationCell", for: indexPath) as! GetLocationCell
            cell.lblCountyName.text = dicCampaignDetails.location
            return cell
        }
        else if indexPath.row==5
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "GetDescriptionCell", for: indexPath) as! GetDescriptionCell
            cell.tvDescription.text = dicCampaignDetails.description
            return cell
        }
        else if indexPath.row==6
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "SelectAPerkCell", for: indexPath) as! SelectAPerkCell
            return cell
        }
        if allPerk.count > 0 && indexPath.row > 6
        {
            if allPerk.count >= indexPath.row - 6
            {
                let details = allPerk[indexPath.row - 7]
                let  cell = tableView.dequeueReusableCell(withIdentifier: "PerkCell", for: indexPath) as! PerkCell
                cell.btnGetThisPerk.layer.masksToBounds = true
                cell.btnGetThisPerk.layer.cornerRadius = 6
                
                cell.lblPerkName.text = details.title
                cell.tvPerkDescription.text = details.description
                
                return cell
            }
            else if allPerk.count >= indexPath.row - 7
            {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "CollaboratorTitleCell", for: indexPath) as! CollaboratorTitleCell
                return cell
            }
            else
            {
                if allCollaborator.count > 0 && indexPath.row > 8
                {
                    if allCollaborator.count >= indexPath.row - 8
                    {
                        let details = allCollaborator[indexPath.row - 9]
                        let  cell = tableView.dequeueReusableCell(withIdentifier: "CollaboratorCell", for: indexPath) as! CollaboratorCell
                        cell.imgVwUser.layer.masksToBounds = true
                        cell.imgVwUser.layer.cornerRadius = cell.imgVwUser.frame.size.height / 2
                        cell.lblUserName.text = details.user_name
                        return cell
                    }
                    else
                    {
                        let  cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmCell", for: indexPath) as! ConfirmCell
                        return cell
                    }
                }
                else
                {
                    let  cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmCell", for: indexPath) as! ConfirmCell
                    return cell
                }
                
            }
        }
        else if indexPath.row==allPerk.count + indexPath.row
        {
            if allCollaborator.count > 0 && indexPath.row > 7
            {
                if allCollaborator.count >= indexPath.row - 7
                {
                    let details = allCollaborator[indexPath.row - 8]
                    let  cell = tableView.dequeueReusableCell(withIdentifier: "CollaboratorCell", for: indexPath) as! CollaboratorCell
                    cell.imgVwUser.layer.masksToBounds = true
                    cell.imgVwUser.layer.cornerRadius = cell.imgVwUser.frame.size.height / 2
                    cell.lblUserName.text = details.user_name
                    return cell
                }
                else
                {
                    let  cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmCell", for: indexPath) as! ConfirmCell
                    cell.btnConfirm.setTitle("Publish", for: .normal)
                    cell.btnConfirm.tag = indexPath.row
                    //cell.btnConfirm(self, action: #selector(imagePressed(sender:)), for: UIControlEvents.touchUpInside)
                    return cell
                }
            }
            else
            {
                if indexPath.row==7
                {
                    let  cell = tableView.dequeueReusableCell(withIdentifier: "CollaboratorTitleCell", for: indexPath) as! CollaboratorTitleCell
                    return cell
                }
                else
                {
                    let  cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmCell", for: indexPath) as! ConfirmCell
                    cell.btnConfirm.setTitle("Publish", for: .normal)
                    cell.btnConfirm.tag = indexPath.row
                    //cell.btnConfirm(self, action: #selector(imagePressed(sender:)), for: UIControlEvents.touchUpInside)
                    return cell
                }
            }
        }
        else
        {
            if indexPath.row==7
            {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "CollaboratorTitleCell", for: indexPath) as! CollaboratorTitleCell
                return cell
            }
            else
            {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmCell", for: indexPath) as! ConfirmCell
                cell.btnConfirm.setTitle("Publish", for: .normal)
                cell.btnConfirm.tag = indexPath.row
                //cell.btnConfirm(self, action: #selector(imagePressed(sender:)), for: UIControlEvents.touchUpInside)
                return cell
            }
            
        }
    }
}
