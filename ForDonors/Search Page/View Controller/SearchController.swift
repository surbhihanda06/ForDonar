//
//  SearchController.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 06/06/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import SVProgressHUD

class SearchController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lblPageTitle: UILabel!
    @IBOutlet weak var vwSearch: UIView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tblVwSearchResult: UITableView!
    @IBOutlet weak var lblNoRecord: UILabel!
    
    var arrCampaignList = [CampaignDetails]()
    
    var strKeyword: String? = ""
    private var timer: Timer?
    private let kTimeoutInSeconds:TimeInterval = 1
    
    var resultDay :Int!
    var remainHour :Int!
    var Quotient :Int!
    var reminder :Int!
    
    var isLast: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //tfSearch.setValue(UIColor(Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5), forKeyPath: "_placeholderLabel.textColor")
        tfSearch.attributedPlaceholder = NSAttributedString(string: "Name Here....",
                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        tblVwSearchResult.register(UINib(nibName: "HomeCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeCell")
        
        vwSearch.layer.masksToBounds = true
        vwSearch.layer.cornerRadius = 8
        vwSearch.layer.borderWidth = 1
        vwSearch.layer.borderColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.2).cgColor
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        lblPageTitle.text = "Search".localized
        tfSearch.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startFetching() {
        
        if let tmr = self.timer
        {
            tmr.invalidate()
        }
        
        self.timer = Timer.scheduledTimer(timeInterval: kTimeoutInSeconds, target:self, selector:#selector(fetch), userInfo:nil, repeats:false)
    }
    
    func stopFetching()
    {
        if let tmr = self.timer
        {
            tmr.invalidate()
        }
    }
    
    @objc func fetch()
    {
        if let keyword = strKeyword
        {
            self.SearchCampaignListCall(text: keyword)
        }
        self.stopFetching()
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        // text hasn't changed yet, you have to compute the text AFTER the edit yourself
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        // do whatever you need with this updated string (your code)
        arrCampaignList = [CampaignDetails]()
        self.tblVwSearchResult.reloadData()
        strKeyword = updatedString
        self.startFetching()
        
        
        // always return true so that changes propagate
        return true
    }
    
    //MARK: - Service Call
    func SearchCampaignListCall(text: String)
    {
        //http://fordonor.us-west-2.elasticbeanstalk.com/api/search/campaign?query=reoli&sortBy=createdDate&direction=DESC&size=5&page=0
        
        SVProgressHUD.show()
        let prmList:[String: Any] = [:]
        let apiName = String(format:"/search/campaign?query=%@&sortBy=createdDate&size=%d&page=%d&direction=DESC",tfSearch.text!, PER_PAGE_CONTENT,PAGE_NUMBER(total: arrCampaignList.count))
        let request = MakePostRequest.init(parameterList: prmList, APIName: apiName)
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: MyCampaignListResponse?) in
            SVProgressHUD.dismiss()
            if let myData = getMyData
            {
                self.isLast = myData.last
                print("isLast",self.isLast)
                let tempCampList = myData.allList
                
                //self.arrCampaignList = myData.allList
                if tempCampList.count == 0
                {
                    //Alert.disPlayAlertMessage(titleMessage: "Sorry!", alertMsg: "No records found.")
                    self.lblNoRecord.isHidden = false
                }
                else
                {
                    self.lblNoRecord.isHidden = true
                    if self.arrCampaignList.count > 0
                    {
                        self.arrCampaignList.append(contentsOf: tempCampList)
                        
                        //self.arrCampaignList = self.arrCampaignList.uniq()
                    }
                    else
                    {
                        self.arrCampaignList = myData.allList
                        //self.tblVwSearchResult.setContentOffset(CGPoint.zero, animated: false)
                    }
                    //
                    
                }
                self.tblVwSearchResult.reloadData()
                
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
                        self.tblVwSearchResult.reloadData()
                        let msg:String = err.description
                        Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: msg)
                    }
                    
                }
            }
        })
    }

    // MARK: - Action
    @IBAction func btnBackPressed(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnFilterPressed(_ sender: Any) {
    }
}
extension SearchController: UITableViewDelegate, UITableViewDataSource
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
        
        let goalAmount = Float(details.goal_amount)
        let raisedAmount: Float = Float(details.raisedAmount)
        let getAmount = raisedAmount / goalAmount
        cell.progressBar.setProgress(getAmount, animated: true)
        
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
        }
    }
}
extension SearchController: UIScrollViewDelegate
{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if scrollView == self.tblVwSearchResult
        {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                if isLast == false
                {
                    if let keyword = strKeyword
                    {
                        self.SearchCampaignListCall(text: keyword)
                    }
                    self.stopFetching()
                }
                else
                {
                    
                }
            }
        }
    }
    /*func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
     
     print("scrollViewWillBeginDragging")
     //isDataLoading = false
     }*/
    
}
