//
//  MyCampaignController.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 29/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import SVProgressHUD

class MyCampaignController: UIViewController {
    
    @IBOutlet weak var lblPageTitle: UILabel!
    @IBOutlet weak var vwSearch: UIView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tblVwCampaignList: UITableView!
    
    var arrCampaignList = [CampaignDetails]()
    var arrAllList = [CampaignDetails]()
    
    var isLast: Bool = false
    
    var userId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        vwSearch.layer.masksToBounds = true
        vwSearch.layer.cornerRadius = 12
        
        tblVwCampaignList.register(UINib(nibName: "MyCampaignCell", bundle: Bundle.main), forCellReuseIdentifier: "MyCampaignCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblPageTitle.text = "My Campaigns".localized
        MyCampaignListCall()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Service Call
    func MyCampaignListCall()
    {
        //This is another change
        //Lets check teh change.
        //http://fordonor.us-west-2.elasticbeanstalk.com/api/user/53447/campaign?sortBy=createdDate&size=1&page=1&direction=DESC
        SVProgressHUD.show()
        userId = UserDefaults.standard.object(forKey: "userId") as? Int ?? 0
        let prmList:[String: Any] = [:] //\(String(format:"%d",userId))
        //MARK:- Static page count need to chagne later
        let apiName = String(format:"/user/%d/campaign?sortBy=createdDate&size=%d&page=%d&direction=DESC",userId, PER_PAGE_CONTENT,PAGE_NUMBER(total: arrCampaignList.count))
        let request = MakeGetRequest.init(parameterList: prmList, APIName: apiName)
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: MyCampaignListResponse?) in
            SVProgressHUD.dismiss()
            if let myData = getMyData
            {
                self.isLast = myData.last
                let tempCampList = myData.allList
                //self.arrCampaignList = myData.allList
                
                if self.arrCampaignList.count > 0
                {
                    self.arrCampaignList.append(contentsOf: tempCampList)
                    //self.arrCampaignList = self.arrCampaignList.uniq()
                }
                else
                {
                    self.arrCampaignList = myData.allList
                }
                
                
                
                //self.tblVwList.setContentOffset(CGPoint.zero, animated: true)
                self.tblVwCampaignList.reloadData()
            }
            else
            {
                if let err = error as? URLError, err.code == .notConnectedToInternet {
                    // no internet connection
                    //print(err)
                    if let vc = UIApplication.topViewController()
                    {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            Validation.showTransparentWindow(sender: vc, strMsg: "No Internet Connection!")
                        }
                    }
                } else {
                    // other failures
                    
                    if let err = error as? DDSError
                    {
                        self.arrCampaignList = [CampaignDetails]()
                        self.tblVwCampaignList.reloadData()
                        let msg:String = err.description
                        Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: msg)
                    }
                }
            }
        })
    }
    
    
    // MARK: - Action

    /*func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //If we reach the end of the table.
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
        {
            //Add ten more rows and reload the table content.
            print("Bottom Refresh")
            //MyCampaignListCall()
            //tableRowNumber += 10
            //tableView.reloadData()
            
            
        }
    }*/
    
    @IBAction func btnBackPressed(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnFilterPressed(_ sender: Any) {
    }
    
    @IBAction func btnSearchPressed(_ sender: Any) {
    }
}
extension MyCampaignController: UIScrollViewDelegate
{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if scrollView == self.tblVwCampaignList
        {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                if isLast == false
                {
                    self.MyCampaignListCall()
                }
                else
                {
                    
                }
            }
        }
    }
}

extension MyCampaignController: UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrCampaignList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 220
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "MyCampaignCell", for: indexPath) as! MyCampaignCell
        
        cell.vwBg.layer.masksToBounds = true
        cell.vwBg.layer.shadowColor = UIColor.darkGray.cgColor
        cell.vwBg.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.vwBg.layer.shadowRadius = 2.0
        cell.vwBg.layer.shadowOpacity = 1.0
        cell.vwBg.layer.cornerRadius = 4
        
//        cell.imgVwImage.layer.masksToBounds = true
//        cell.imgVwImage.layer.cornerRadius = cell.imgVwImage.frame.size.height / 2
        
        let details = arrCampaignList[indexPath.row]
        cell.lblTitle.text = details.campaign_name
        
        if details.campaign_type == "1"
        {
            cell.progressBar.isHidden = false
            let goalAmount: Float
            let raisedAmount: Float
            if details.goal_amount == nil || details.goal_amount == 0
            {
               goalAmount = Float(50.0)
            }
            else
            {
                goalAmount = Float(details.goal_amount)
            }
            if details.raisedAmount == nil || details.raisedAmount == 0
            {
                raisedAmount = Float(40.0)
            }
            else
            {
                raisedAmount = Float(details.raisedAmount)
            }
            //let raisedAmount: Float = Float(details.raisedAmount)
            let getAmount = raisedAmount / goalAmount
            cell.progressBar.setProgress(getAmount, animated: true)
        }
        else
        {
            cell.progressBar.isHidden = true
        }
        
        
        let expiredDate = details.date
        let getDate = String(expiredDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if getDate != "0"
        {
            let date = dateFormatter.date(from: getDate)
            dateFormatter.dateFormat = "MMM dd,yyyy"
            let strDate = dateFormatter.string(from: date!)
            print("strDate:", strDate)
            
            cell.lblDate.text = strDate
        }
        
        
        let price = details.goal_amount
        if price != nil
        {
            //cell.lblAskingPrice.text = "Asking " + String(price)
            cell.lblAskingPrice.text = "Asking $" + String(format:"%d",price!)
        }
        
        let images = details.image
        if images.count > 0
        {
            let getImage = UrlUtil.getCampaignImage(image: images[0] as! String)
            
            cell.imgVwImage.sd_setImage(with: URL(string: getImage), placeholderImage: UIImage(named: Default_Image))
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let details = arrCampaignList[indexPath.row]
        if details.campaign_type == "1"
        {
            let moveViewController = ConfirmationController()
            self.navigationController?.pushViewController(moveViewController, animated: true)
            moveViewController.campaignId = details.id
            moveViewController.fromHomeOrUpload = "Home"
        }
        else
        {
            let moveViewController = OrganCampaignOverviewController()
            self.navigationController?.pushViewController(moveViewController, animated: true)
            moveViewController.campaignId = details.id
            moveViewController.fromHomeOrUpload = "Home"
        }
        
    }
}
