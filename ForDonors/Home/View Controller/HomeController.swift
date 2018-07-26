//
//  HomeController.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 27/02/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class HomeController: UIViewController, TopicListControllerDalegate {
    func fetchTopicDetails(topic: SubTopicList) {
        
    }
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var colVwCategory: UICollectionView!
    @IBOutlet weak var colVwSubCategory: UICollectionView!
    @IBOutlet weak var tblVwList: UITableView!
    
    //.....Menu.....
    @IBOutlet weak var menuTbl: UITableView!
    @IBOutlet weak var vwTransparent: UIView!
    @IBOutlet weak var vwMenu: UIView!
    @IBOutlet weak var userImgVw: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    var firstTimeLoadCheck : Bool = false
    var refreshControll = UIRefreshControl()
    
    var isLast: Bool = false
    
    @IBOutlet weak var vwPlus: UIView!
    
    var selCatId : Int = 0
    var todayDate: String = ""
    var pageCount: Int = 0
    var pageSize: Int = 10
    
    var resultDay :Int!
    var remainHour :Int!
    var Quotient :Int!
    var reminder :Int!
    
    var arrTopicList = [SubTopicList]()
    var arrSubTopicList = [SubTopicList]()
    var selectedCategory: SubTopicList!
    
    var arrCampaignList = [CampaignDetails]()
    var strText: String!
    
    var fromSignUp = false
    
    var IsMenutap = false
    let menuArr: [String] = ["Profile", "Settings", "Create Campaign", "Create Campaign Organ", "Category","My Campaigns","My Contribution","Search Donars","Offer Donars","Chat List","Become A Donor","Logout","Add Verification"]
    let menuImageArr: [String] = ["profile", "setting", "news", "news", "four-black-squares","news","make-an-online-donation","search","offer","chatList","four-black-squares","logout (1)","location"]
    
    
    var arrCategory = NSArray()
    var arrSubCategory = NSArray()
    var SelSubCategory: String = "ALL"

    var selectedindexPath = IndexPath()
    var check : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
        arrCategory=["HEALTH","TECHNOLOGY","ARTS & FILMS","COMMUNITY"]
        arrSubCategory=["ALL","PLEDGES","OFFERS","POPULAR","NEWS"]
        
        tblVwList.register(UINib(nibName: "HomeCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeCell")
        
        colVwCategory.register(UINib(nibName: "CategoryCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CategoryCell")
        
        colVwSubCategory.register(UINib(nibName: "SubCategoryCell", bundle: Bundle.main), forCellWithReuseIdentifier: "SubCategoryCell")
        menuTbl.delegate=self
        menuTbl.dataSource=self
        menuTbl.register(UINib(nibName: "MenuTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MenuTableViewCell")
        self.menuTbl.tableFooterView=UIView()
        vwTransparent.isHidden=true
        
        tblVwList.alwaysBounceVertical = false
        
        self.vwMenu.frame=CGRect(x:-600, y: 20, width: Int(self.view.frame.size.width-(self.view.frame.size.width/2)), height: Int(self.view.frame.size.height))
        
        userImgVw.layer.cornerRadius = userImgVw.frame.size.height/2
        userImgVw.clipsToBounds = true
        userImgVw.layer.borderWidth = 1.0
        userImgVw.layer.borderColor = UIColor.darkGray.cgColor
        
        vwPlus.layer.cornerRadius = vwPlus.frame.size.height/2
        vwPlus.clipsToBounds = true
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        todayDate = formatter.string(from: date)
        
        refreshControll.addTarget(self, action:
            #selector(HomeController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        tblVwList.addSubview(refreshControll)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        lblTitle.text = "Home".localized
        getTopicList(topicId: 0)
        self.AllCampaignListCall(selectedCategoryId: selCatId)
        
        //MenuTbl
        vwTransparent.isHidden=true
        self.vwMenu.frame=CGRect(x:-600, y: 20, width: Int(self.view.frame.size.width-(self.view.frame.size.width/2)), height: Int(self.view.frame.size.height))
        
        let prefs = UserDefaults.standard
        let fname: String = prefs.string(forKey: "FName") ?? ""
        let lname: String = prefs.string(forKey: "LName") ?? ""
        let emailstr: String = prefs.string(forKey: "email") ?? ""
        self.userNameLbl.text = fname + " " + lname
        self.userEmail.text = emailstr
        
        let city: String = prefs.string(forKey: "city") ?? ""
        let state: String = prefs.string(forKey: "state") ?? ""
        let country: String = prefs.string(forKey: "country") ?? ""
        self.userLocation.text = city + ", " + state + ", " + country
       
        let userImage = prefs.string(forKey: "profileImg") ?? ""
        if userImage != ""
        {
            let getImage = UrlUtil.getUserImage(image: userImage)
            userImgVw.sd_setImage(with: URL(string: getImage), placeholderImage: UIImage(named: Default_Image))
            
        }
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        menuTbl.reloadData()
        
        //lblTitle.text = NSLocalizedString("Home", comment: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        arrCampaignList.removeAll()
        self.AllCampaignListCall(selectedCategoryId: selCatId)
        refreshControl.endRefreshing()
    }
    
    @IBAction func btnPlusPressed(_ sender: Any)
    {
        let  vc  = CreateCampaignViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnLogoutPressed(_ sender: Any)
    {
        UserDefaults.standard.set(nil, forKey:
            "userId")
        UserDefaults.standard.set(nil, forKey:
            "FName")
        UserDefaults.standard.set(nil, forKey:
            "LName")
        UserDefaults.standard.set(nil, forKey:
            "Email")
        UserDefaults.standard.synchronize()
        
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func btnSearchPressed(_ sender: Any)
    {
        let moveViewController = SearchController()
        self.navigationController?.pushViewController(moveViewController, animated: true)
    }
    // MARK: - Service Call
    func unlikeCall(campaignId: Int)
    {
        //http://fordonor.us-west-2.elasticbeanstalk.com/api/user/46/like/456646
        if self.check == false
        {
            SVProgressHUD.show()
        }
        let prmList:[String: Any] = [:]
        let userId = UserDefaults.standard.object(forKey: "userId") as? Int ?? 0
        let apiName = String(format:"/user/%d/unlike/%d",userId,campaignId)
        let request = MakePostRequest.init(parameterList: prmList, APIName: apiName)
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: TopicListResponse?) in
            if self.check == false
            {
                SVProgressHUD.dismiss()
            }
            if let response = getMyData
            {
                self.AllCampaignListCall(selectedCategoryId: self.selCatId)
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
                        let msg:String = err.description
                        Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: msg)
                    }
                }
            }
        })
    }
    func likeCall(campaignId: Int)
    {
        //http://fordonor.us-west-2.elasticbeanstalk.com/api/user/46/like/456646
        if self.check == false
        {
            SVProgressHUD.show()
        }
        let prmList:[String: Any] = [:]
        let userId = UserDefaults.standard.object(forKey: "userId") as? Int ?? 0
        let apiName = String(format:"/user/%d/like/%d",userId,campaignId)
        let request = MakePostRequest.init(parameterList: prmList, APIName: apiName)
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: TopicListResponse?) in
            if self.check == false
            {
                SVProgressHUD.dismiss()
            }
            if let response = getMyData
            {
                self.AllCampaignListCall(selectedCategoryId: self.selCatId)
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
                        let msg:String = err.description
                        Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: msg)
                    }
                }
            }
        })
    }
    func getTopicList(topicId: Int)
    {
        SVProgressHUD.show()
        let prmList:[String: Any] = [:]
        let apiName = String(format:"/topic/%d",topicId)
        let request = MakeGetRequest.init(parameterList: prmList, APIName: apiName)
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: TopicListResponse?) in
            SVProgressHUD.dismiss()
            if let response = getMyData
            {
                if let dictTopicList = response.topicList, dictTopicList.subTopic.count > 0
                {
                    self.arrTopicList = dictTopicList.subTopic
                    self.colVwCategory.reloadData()
                    let firstTopic = self.arrTopicList[0]
                    //self.getSubTopicList(topicId: firstTopic.id)
                    //self.selectedCategory = self.arrTopicList[0]
                    let topicDetails = self.arrTopicList[0]
                }
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
                        let msg:String = err.description
                        Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: msg)
                    }
                }
            }
        })
    }
    func getSubTopicList(topicId: Int)
    {
        SVProgressHUD.show()
        let prmList:[String: Any] = [:]
        let apiName = String(format:"/topic/%d",topicId)
        let request = MakeGetRequest.init(parameterList: prmList, APIName: apiName)
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: TopicListResponse?) in
            SVProgressHUD.dismiss()
            if let response = getMyData
            {
                if let dictTopicList = response.topicList, dictTopicList.subTopic.count > 0
                {
                    self.arrSubTopicList = dictTopicList.subTopic
                    self.colVwSubCategory.reloadData()
                }
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
                        let msg:String = err.description
                        Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: msg)
                    }
                }
            }
        })
    }
    
    func AllCampaignListCall(selectedCategoryId: Int)
    {
        if self.check == false
        {
            SVProgressHUD.show()
        }
        let prmList:[String: Any] = [:]
        let apiName = String(format:"/home?topicId=%d&sortBy=createdDate&size=%d&page=%d&order=DESC",selectedCategoryId, pageSize,pageCount)//PAGE_NUMBER(total: arrCampaignList.count)
        let request = MakeGetRequest.init(parameterList: prmList, APIName: apiName)
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: MyCampaignListResponse?) in
            if self.check == false
            {
                SVProgressHUD.dismiss()
            }
            if let myData = getMyData
            {
                self.isLast = myData.last
                print("isLast",self.isLast)
                let tempCampList = myData.allList
                
                //self.arrCampaignList = myData.allList
                //self.arrCampaignList.removeAll()
                if self.arrCampaignList.count > 0
                {
                    self.arrCampaignList.append(contentsOf: tempCampList)
                    //self.arrCampaignList = self.arrCampaignList.uniq()
                }
                else
                {
                    self.arrCampaignList = myData.allList
                }
                if self.check
                {
                    self.tblVwList.reloadRows(at: [self.selectedindexPath], with: .none)
                }
                else
                {
                    self.tblVwList.reloadData()
                }
                self.check = false
                //self.tblVwList.setContentOffset(CGPoint.zero, animated: true)
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
    
    func getCategoryList(topicId: Int)
    {
        SVProgressHUD.show()
        let prmList:[String: Any] = [:]
        let apiName = String(format:"/topic/%d",topicId)
        let request = MakeGetRequest.init(parameterList: prmList, APIName: apiName)
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: TopicListResponse?) in
            SVProgressHUD.dismiss()
            if let response = getMyData
            {
                if let dictTopicList = response.topicList, dictTopicList.subTopic.count > 0
                {
                    let moveViewController = TopicListController()
                    moveViewController.delegate = self
                    moveViewController.subTopic = dictTopicList.subTopic
                    moveViewController.fromHome = "true"
                    self.navigationController?.pushViewController(moveViewController, animated: true)
                }
                else
                {
                    Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: "No Topic found")
                }
                
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
                        let msg:String = err.description
                        Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: msg)
                    }
                    
                }
            }
        })
    }
    func fetchUserInfo()
    {
        SVProgressHUD.show()
        let userId = UserDefaults.standard.object(forKey: "userId") as? Int ?? 0
        let prmList:[String: Any] = [:]
        let apiName = "/user/\(userId)"//String(format:"%d",userId)
        let request = MakeGetRequest.init(parameterList: prmList, APIName: apiName)
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: UserDetailsResponse?) in
            SVProgressHUD.dismiss()
            if getMyData != nil
            {
                let fname = getMyData?.first_name
                let lname = getMyData?.last_name
                self.userNameLbl.text = fname! + " " + lname!
                self.userEmail.text = getMyData?.email
                let country = getMyData?.country!
                let city = getMyData?.city!
                let state = getMyData?.state!
                self.userLocation.text = city! + "," + state! + "," + country!
                let profileImgURL = UrlUtil.getUserImage(image:(getMyData?.profileImg!)!)
                if profileImgURL.count > 0
                {
                    self.userImgVw.sd_setImage(with: URL(string: profileImgURL ), placeholderImage: UIImage(named: Default_Image))
                    /*
                    
                    Alamofire.request(profileImgURL).responseImage { response in
                        if let image = response.result.value {
                            self.userImgVw.image = image
                        }
                    }*/
                }
                UserDefaults.standard.set(getMyData?.id, forKey:
                    "userId")
                UserDefaults.standard.set(getMyData?.first_name, forKey:
                    "FName")
                UserDefaults.standard.set(getMyData?.last_name, forKey:
                    "LName")
                UserDefaults.standard.set(getMyData?.email, forKey:
                    "Email")
            }
            else
            {
                if let err = error as? URLError, err.code == .notConnectedToInternet {
                    
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
                        let msg:String = err.description
                        Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: msg)
                    }
                    
                }
            }
        })
    }

    
    
    
    @IBAction func btnMenuPressed(_ sender: Any) {
        if IsMenutap {
            IsMenutap = false
            vwTransparent.isHidden=true
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.vwMenu.frame=CGRect(x:-600, y: 20, width: Int(self.view.frame.size.width-(self.view.frame.size.width/2)), height: Int(self.view.frame.size.height))
            }, completion: nil)
            
        } else {
            IsMenutap = true
            vwTransparent.isHidden=false
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                
                self.vwMenu.frame=CGRect(x:0, y: 20, width: Int(self.view.frame.size.width-(self.view.frame.size.width/2)), height: Int(self.view.frame.size.height))
               }, completion: nil)
        }
    }
    
    @IBAction func transparentVwBtnAction(_ sender: Any) {
        vwTransparent.isHidden=true
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.vwMenu.frame=CGRect(x:-600, y: 20, width: Int(self.view.frame.size.width-(self.view.frame.size.width/2)), height: Int(self.view.frame.size.height))
           
        }, completion: nil)
        IsMenutap = false
    }
    @objc func btnLikeUnlikePressed(sender: UIButton!)
    {
        check = true
        //selectedindexPath = NSIndexPath(item: sender.tag, section: 0) as IndexPath
        selectedindexPath = IndexPath(row: sender.tag, section: 0)
        let details = arrCampaignList[sender.tag]
        let id = details.id
        let likeStatus = details.isLike
        if likeStatus
        {
            unlikeCall(campaignId: id)
        }
        else
        {
            likeCall(campaignId: id)
        }
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

extension HomeController: UIScrollViewDelegate
{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if scrollView == self.tblVwList
        {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                if isLast == false
                {
                    pageCount = pageCount + 1
                    self.AllCampaignListCall(selectedCategoryId: selCatId)
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
extension HomeController: UITableViewDelegate, UITableViewDataSource
{
    
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView==menuTbl
        {
            return 45.0
        }
        else
        {
            return 517.0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView==menuTbl
        {
           return  menuArr.count
        }
        else
        {
           return arrCampaignList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if tableView==menuTbl
        {
             let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
            print(Locale.preferredLanguage)
            //cell.menuNameLbl.text=self.menuArr[indexPath.row]
            cell.menuNameLbl.text = self.menuArr[indexPath.row].localized
            cell.menuImgVw?.image=UIImage.init(named: menuImageArr[indexPath.row])
            return cell
        }
        else
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
            /*
            if let date = String(details.date)
            {
                
            }
            else
            {
                cell.lblDaysLeft.text = "0 days left"
            }*/
            self.view.updateConstraintsIfNeeded()
            
            cell.lblLocation.text = details.location
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
            
            let goalAmount = Float(details.goal_amount)
            let raisedAmount: Float = Float(details.raisedAmount)
            let getAmount = raisedAmount / goalAmount
            print("getAmount:->",getAmount)
            let amount : Int
            if goalAmount == 0.0
            {
              amount = 0
            }
            else
            {
                amount = Int(getAmount)
            }
            let fundText1 = String(amount * 100) + "%"
            let fundText2 = " funded"
            cell.lblRefund.text = fundText1 + fundText2
            cell.progressBar.setProgress(getAmount, animated: true)
            let images = details.image
            if images.count > 0
            {
                let getImage = UrlUtil.getCampaignImage(image: images[0] as! String)
                
                cell.imgVwCoverImage.sd_setImage(with: URL(string: getImage), placeholderImage: UIImage(named: Default_Image))
            }
            if details.isLike == true
            {
                cell.imgVwLikeUnlike.image = UIImage(named: "fav")
            }
            else
            {
                cell.imgVwLikeUnlike.image = UIImage(named: "love")
            }
            cell.btnLikeUnlike?.addTarget(self, action: #selector(self.btnLikeUnlikePressed), for: UIControlEvents.touchUpInside)
            cell.btnLikeUnlike.tag = indexPath.row
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView==menuTbl
        {
            if (indexPath.row == 0)
            {
                let  vc  = ProfileViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if (indexPath.row == 1)
            {
                let  vc  = SettingsController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if (indexPath.row == 2)
            {
                let  vc  = CreateCampaignViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if (indexPath.row == 3)
            {
                let  vc  = CreateOrganCampaignController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if (indexPath.row == 4)
            {
                self.getCategoryList(topicId: 0)
            }
            else if (indexPath.row == 5)
            {
                let  vc  = MyCampaignController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if (indexPath.row == 6)
            {
                let  vc  = MyContributionController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if (indexPath.row == 7)
            {
                
            }
            else if (indexPath.row == 9)
            {
                let  vc  = ChatListController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if (indexPath.row == 10)
            {
                let moveViewController = BecomeADonorViewController()
                self.navigationController?.present(moveViewController, animated: false, completion: nil)
            }
            else if (indexPath.row == 11)
            {
                let testController = LoginViewController ()
                let navVC = UINavigationController(rootViewController: testController)
                navVC.isNavigationBarHidden = true
                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                UIView.transition(with: self.view.window!, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                    self.navigationController?.pushViewController(testController, animated: true)
                    //self.view.window!.rootViewController = navVC
                }, completion: nil)
            }
            else
            {
                let moveViewController = VerificationController()
                self.navigationController?.present(moveViewController, animated: false, completion: nil)
            }
        }
        else
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
}
extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colVwCategory
        {
            return arrTopicList.count + 1
        }
        else
        {
            return arrSubCategory.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == colVwCategory
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            
            if indexPath.row == 0
            {
                cell.lblCategoryName.text = "ALL"
                if selCatId == 0
                {
                    cell.lblSelected.isHidden = false
                    cell.lblCategoryName.textColor = UIColor.white
                }
                else
                {
                    cell.lblSelected.isHidden = true
                    cell.lblCategoryName.textColor = UIColor(red: 207/255.0, green: 207/255.0, blue: 207/255.0, alpha: 1)
                }
            }
            else
            {
                let topicDetails = arrTopicList[indexPath.row - 1]
                let catName = topicDetails.name
                let catId = topicDetails.id
                cell.lblCategoryName.text = catName.uppercased()
                if selCatId == catId
                {
                    cell.lblSelected.isHidden = false
                    cell.lblCategoryName.textColor = UIColor.white
                }
                else
                {
                    cell.lblSelected.isHidden = true
                    cell.lblCategoryName.textColor = UIColor(red: 207/255.0, green: 207/255.0, blue: 207/255.0, alpha: 1)
                }
                
            }
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCell", for: indexPath) as! SubCategoryCell
            let text = arrSubCategory[indexPath.row] as! String
            cell.lblSubCategoryName.text = text
            cell.vwBg.layer.masksToBounds = true
            cell.vwBg.layer.cornerRadius = 16
            
            if SelSubCategory == text
            {
                cell.vwBg.backgroundColor = UIColor(red: 62/255.0, green: 62/255.0, blue: 62/255.0, alpha: 1)
            }
            else
            {
                cell.vwBg.backgroundColor = UIColor(red: 205/255.0, green: 205/255.0, blue: 205/255.0, alpha: 1)
            }
            return cell
        }
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        arrCampaignList.removeAll()
        pageCount = 0
        if collectionView == colVwCategory
        {
            if indexPath.row == 0
            {
                selCatId = 0
            }
            else
            {
                let selCategory = arrTopicList[indexPath.row - 1]
                selCatId = selCategory.id
            }
            self.AllCampaignListCall(selectedCategoryId: selCatId)
            colVwCategory.reloadData()
        }
        else
        {
            SelSubCategory = arrSubCategory[indexPath.row] as! String
            colVwSubCategory.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == colVwCategory
        {
            if indexPath.row == 0
            {
                return CGSize(width: 80, height: 47);
            }
            else
            {
                let topicDetails = arrTopicList[indexPath.row - 1]
                let text = topicDetails.name
                let width = text.width(withConstrainedHeight: 47, font: CategoryCell.locationNameFont)
                return CGSize(width: width + 10, height: 47);
            }
            
        }
        else
        {
            let text = arrSubCategory[indexPath.row] as! String
            let width = text.width(withConstrainedHeight: 60, font: SubCategoryCell.locationNameFont)
            return CGSize(width: width + 10, height: 60);
        }
    }
}
extension String
{
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat
    {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height);
        
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.width;
    }
}
extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
