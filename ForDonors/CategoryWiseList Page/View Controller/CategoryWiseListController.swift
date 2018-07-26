//
//  CategoryWiseListController.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 24/05/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import SVProgressHUD

class CategoryWiseListController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblVwList: UITableView!
    var subTopicId = 0
    var arrCampaignList = [CampaignDetails]()
    var isLast: Bool = false
    
    var resultDay :Int!
    var remainHour :Int!
    var Quotient :Int!
    var reminder :Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AllCampaignListCall(selectedCategoryId: subTopicId)
        
        tblVwList.register(UINib(nibName: "HomeCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeCell")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblTitle.text = "Campaign".localized
    }
    
    // MARK: - Action
    @IBAction func btnBackPressed(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Service Call
    func AllCampaignListCall(selectedCategoryId: Int)
    {
        SVProgressHUD.show()
        let prmList:[String: Any] = [:]
        let apiName = String(format:"/home?topicId=%d&sortBy=createdDate&size=%d&page=%d&order=DESC",selectedCategoryId, PER_PAGE_CONTENT,PAGE_NUMBER(total: arrCampaignList.count))
        let request = MakeGetRequest.init(parameterList: prmList, APIName: apiName)
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: MyCampaignListResponse?) in
            SVProgressHUD.dismiss()
            if let myData = getMyData
            {
                self.isLast = myData.last
                print("isLast",self.isLast)
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
                self.tblVwList.reloadData()
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
                        self.tblVwList.reloadData()
                        let msg:String = err.description
                        Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: msg)
                    }
                    
                }
            }
        })
    }
    func timerValue(_ timeToEnd: String) -> String {
        
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        let timeUntilEnd = Int((df.date(from: timeToEnd)?.timeIntervalSinceNow)!)
        if timeUntilEnd <= 0 {
            return " Post Expired"
        }
        else {
            Quotient = timeUntilEnd/3600   //hour
            reminder = (timeUntilEnd)%3600
            if Quotient > 24
            {
                resultDay = Quotient/24   //day
                remainHour = Quotient%24
                let seconds1: Int = reminder % 60
                let minutes1: Int = (reminder / 60) % 60
                return String(format: "%02ld", Int(resultDay))
            }
            else
            {
                let seconds1: Int = timeUntilEnd % 60
                let minutes1: Int = (timeUntilEnd / 60) % 60
                let hours1: Int = timeUntilEnd / 3600
                return String(format: "%02ld:%02ld:%02ld", Int(hours1), Int(minutes1), Int(seconds1))
                
            }
        }
    }
}
extension CategoryWiseListController: UITableViewDelegate, UITableViewDataSource
{
    
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 512.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrCampaignList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
            cell.selectionStyle = .none
            
            
            let details = arrCampaignList[indexPath.row]
            cell.lblTitle.text = details.campaign_name?.components(separatedBy: .newlines).joined()
            
            
        let date = String(details.date)
        if let theDate = Date(jsonDate: "/Date(\(date))/") {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MM/dd/yyyy"
            let finalDate = dateformatter.string(from: theDate)
            cell.lblDaysLeft.text = self.timerValue(finalDate) + " days left"
        } else {
            print("wrong format")
        }
            self.view.updateConstraintsIfNeeded()
            
            //cell.lblLocation.text = details.location
            //cell.lblType.text = details.cat_type
            var nameToShow = "By "
            if let firstName = details.first_name, firstName.count > 0
            {
                nameToShow = nameToShow + firstName + " "
            }
            if let lastName = details.last_name, lastName.count > 0
            {
                nameToShow = nameToShow + lastName
            }
            //cell.imgVwUser.image = UIImage.init(named: "23")
            cell.lblName.text = "By Ken Doe"//nameToShow.count > 3 ? nameToShow : "Ken Doe"
            if let price = details.goal_amount
            {
                cell.lblPrice.text = "$" + String(price) + " USD"
            }
            
            //cell.lblLocation.text = details.location
            
            //            let image = details.profile_img
            //            if image != nil
            //            {
            //                cell.imgVwUser.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "defaultImage"))
            //            }
            
            
            
            let images = details.image
            if images.count > 0
            {
                let getImage = UrlUtil.getCampaignImage(image: images[0] as! String)
                
                cell.imgVwCoverImage.sd_setImage(with: URL(string: getImage), placeholderImage: UIImage(named: Default_Image))
            }
            
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let details = arrCampaignList[indexPath.row]
        let moveViewController = ConfirmationController()
        self.navigationController?.pushViewController(moveViewController, animated: true)
        moveViewController.campaignId = details.id
        moveViewController.fromHomeOrUpload = "Home"
    }
}
