//
//  OrganCampaignOverviewController.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 28/05/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import SVProgressHUD

class OrganCampaignOverviewController: UIViewController {

    @IBOutlet weak var tblVwOrganCampOverview: UITableView!
    @IBOutlet weak var lblPageTitle: UILabel!
    
    var dicCampaignDetails: CampaignDetailsResponse!
    
    var allTestPerk: NSMutableArray = NSMutableArray()
    var allCollaborator = [User]()
    var alIImages: NSMutableArray = NSMutableArray()
    
    var arrComment = [CommentDetails]()
    var arrUpdate = [UpdateDetails]()
    
    var commentCount = 0
    var updateCount = 0
    
    var totalCommentCount = 0
    var totalUpdateCount = 0
    
    var campaignId: Int = 0
    var userId: Int = 0
    
    var campaignName: String = ""
    var campaignType: String = ""
    var topicName: String = ""
    var goalAmount: Float = 0.0
    var raisedAmount: Float = 0.0
    var getAmount: Float = 0.0
    var expireDate: Int = 0
    var campaignDescription: String = ""
    var diffInDays: String = ""
    
    var isVerified = Bool()
    var userImage: String = ""
    
    var isColaborator = false
    
    var resultDay :Int!
    var remainHour :Int!
    var Quotient :Int!
    var reminder :Int!
    
    var campaignPosterId: Int! = 0
    
    var fromOrgan = false
    var fromHomeOrUpload: String!
    
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var parentViewcontroller = String()
    var countryID = String()
    var country : String = ""
    var city  :String = ""
    var noContribution: Int = 0
    var contributeContentArray = [ContentListResponse]()
    var checkContribute : Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userId = UserDefaults.standard.object(forKey: "userId") as? Int ?? 0
        cellRegistration()
        
        let dict: [String: String] = ["campaign_name": "Campaign Name", "description": "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "estimated_delivery_date": "02-03-2018", "id": "0", "perks_image": "", "price": "10", "title": "Test Perk"]
        allTestPerk.add(dict)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        makeCampaignDetailsServiceCall()
        AllUpdateListCall(campaignId: campaignId)
        AllCommentListCall(campaignId: campaignId)
        AllContributeListCall(campaignId: campaignId)
        //lblPageTitle.text = "Campaign Overview".localized
        if fromHomeOrUpload == "Home"
        {
            lblPageTitle.text = "Details"
            //vwBack.isHidden = false
        }
        else
        {
            lblPageTitle.text = "Campaign Overview".localized
            //vwBack.isHidden = true
        }
    }
    
    // MARK: - Register Nib
    
    func cellRegistration()   {
        tblVwOrganCampOverview.register(UINib(nibName: "NameCell", bundle: Bundle.main), forCellReuseIdentifier: "NameCell")
        
        tblVwOrganCampOverview.register(UINib(nibName: "ScrollImageCell", bundle: Bundle.main), forCellReuseIdentifier: "ScrollImageCell")
        
        tblVwOrganCampOverview.register(UINib(nibName: "PriceCell", bundle: Bundle.main), forCellReuseIdentifier: "PriceCell")
        
        tblVwOrganCampOverview.register(UINib(nibName: "DateCell", bundle: Bundle.main), forCellReuseIdentifier: "DateCell")
        
        tblVwOrganCampOverview.register(UINib(nibName: "GetLocationCell", bundle: Bundle.main), forCellReuseIdentifier: "GetLocationCell")
        
        tblVwOrganCampOverview.register(UINib(nibName: "OrganImageCell", bundle: Bundle.main), forCellReuseIdentifier: "OrganImageCell")
        
        tblVwOrganCampOverview.register(UINib(nibName: "PersonalDetailsCell", bundle: Bundle.main), forCellReuseIdentifier: "PersonalDetailsCell")
        
        tblVwOrganCampOverview.register(UINib(nibName: "GetDescriptionCell", bundle: Bundle.main), forCellReuseIdentifier: "GetDescriptionCell")
        
        tblVwOrganCampOverview.register(UINib(nibName: "SelectAnOfferCell", bundle: Bundle.main), forCellReuseIdentifier: "SelectAnOfferCell")
        
        tblVwOrganCampOverview.register(UINib(nibName: "PRECell", bundle: Bundle.main), forCellReuseIdentifier: "PRECell")
        
        tblVwOrganCampOverview.register(UINib(nibName: "AskingPriceCell", bundle: Bundle.main), forCellReuseIdentifier: "AskingPriceCell")
        
        tblVwOrganCampOverview.register(UINib(nibName: "PolicyCell", bundle: Bundle.main), forCellReuseIdentifier: "PolicyCell")
        
        tblVwOrganCampOverview.register(UINib(nibName: "RecentActivityTitleCell", bundle: Bundle.main), forCellReuseIdentifier: "RecentActivityTitleCell")
        
        tblVwOrganCampOverview.register(UINib(nibName: "ContributionTitleCell", bundle: Bundle.main), forCellReuseIdentifier: "ContributionTitleCell")
        
        tblVwOrganCampOverview.register(UINib(nibName: "UpdateTitleCell", bundle: Bundle.main), forCellReuseIdentifier: "UpdateTitleCell")
        
        tblVwOrganCampOverview.register(UINib(nibName: "UpdateDetailsCell", bundle: Bundle.main), forCellReuseIdentifier: "UpdateDetailsCell")
        
        tblVwOrganCampOverview.register(UINib(nibName: "CommentsTitleCell", bundle: Bundle.main), forCellReuseIdentifier: "CommentsTitleCell")
        
        tblVwOrganCampOverview.register(UINib(nibName: "CommentStaticCell", bundle: Bundle.main), forCellReuseIdentifier: "CommentStaticCell")
        
        tblVwOrganCampOverview.register(UINib(nibName: "CommentDetailsCell", bundle: Bundle.main), forCellReuseIdentifier: "CommentDetailsCell")
        
        tblVwOrganCampOverview.register(UINib(nibName: "CollaboratorTitleCell", bundle: Bundle.main), forCellReuseIdentifier: "CollaboratorTitleCell")
        
        tblVwOrganCampOverview.register(UINib(nibName: "CollaboratorCell", bundle: Bundle.main), forCellReuseIdentifier: "CollaboratorCell")
        
        tblVwOrganCampOverview.register(UINib(nibName: "ContributeOrDonateCell", bundle: Bundle.main), forCellReuseIdentifier: "ContributeOrDonateCell")
        
        tblVwOrganCampOverview.register(UINib(nibName: "ContributionListCell", bundle: Bundle.main), forCellReuseIdentifier: "ContributionListCell")
        
        tblVwOrganCampOverview.register(UINib(nibName: "UpdateCell", bundle: Bundle.main), forCellReuseIdentifier: "UpdateCell")
        
        tblVwOrganCampOverview.register(UINib(nibName: "CommentCell", bundle: Bundle.main), forCellReuseIdentifier: "CommentCell")
    }
    
    // MARK: - Service Call
    
    func makeCampaignDetailsServiceCall()
    {
        SVProgressHUD.show()
        let id = String(campaignId)
        let prmList:[String: Any] = [:]
        let request = MakeGetRequest.init(parameterList: prmList, APIName: "/campaign/\(id)")
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: CampaignResponse?) in
            
            SVProgressHUD.dismiss()
            if getMyData?.data != nil
            {
                self.dicCampaignDetails = getMyData?.data
                self.campaignPosterId = (self.dicCampaignDetails?.userId)!
                self.campaignName = self.dicCampaignDetails.campaign_name ?? ""
                let topicDetails = self.dicCampaignDetails.topicDetails
                if topicDetails?.name != nil
                {
                    self.topicName = (topicDetails?.name)!
                }
                else
                {
                    self.topicName = ""
                }
                self.campaignType = self.dicCampaignDetails.campaignType ?? ""
                self.alIImages = self.dicCampaignDetails.images
                self.goalAmount = Float(self.dicCampaignDetails.price)
                self.raisedAmount = Float(self.dicCampaignDetails.raisedAmount)
                if self.raisedAmount == 0.0
                {
                    self.raisedAmount = 40.0
                }
                if self.goalAmount == 0.0
                {
                    self.goalAmount = 50.0
                }
                let percentAmount = self.raisedAmount / self.goalAmount
                self.getAmount = Float(percentAmount)
                self.country = self.dicCampaignDetails.country!
                self.city = self.dicCampaignDetails.city!
                print("raisedAmount",self.raisedAmount)
                print("goalAmount",self.goalAmount)
                print("getamount",self.getAmount)
                self.campaignDescription = self.dicCampaignDetails.description ?? ""
                self.expireDate = self.dicCampaignDetails.expirationDate
                let date = String(self.expireDate)
                if let theDate = Date(jsonDate: "/Date(\(date))/") {
                    let dateformatter = DateFormatter()
                    dateformatter.dateFormat = "MM/dd/yyyy"
                    let finalDate = dateformatter.string(from: theDate)
                    self.diffInDays = self.timerValue(finalDate)
                    print("self.diffInDays",self.diffInDays)
                } else {
                    print("wrong format")
                }
                //self.diffInDays = self.timerValue(self.expireDate)
                self.allCollaborator = self.dicCampaignDetails.arrCollaborators
                for i in 0..<self.allCollaborator.count
                {
                    let collaboratorDetails = self.allCollaborator[i]
                    let id = collaboratorDetails.id
                    if id == self.userId
                    {
                        self.isColaborator = true
                    }
                    else
                    {
                        self.isColaborator = false
                    }
                }
                self.noContribution = self.dicCampaignDetails.noContribution
                if self.noContribution > 5
                {
                    self.noContribution = 5
                }
                self.userImage = self.dicCampaignDetails.profileImg ?? ""
                self.isVerified = self.dicCampaignDetails.verified
                //                if self.userImage != nil
                //                {
                //                    let getImage = UrlUtil.getUserImage(image: self.userImage)
                //                    self.imgVwUser.sd_setImage(with: URL(string: getImage), placeholderImage: UIImage(named: "defaultImage"))
                //                }
                
                self.tblVwOrganCampOverview.reloadData()
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
    
    func AllUpdateListCall(campaignId: Int)
    {
        //http://fordonor.us-west-2.elasticbeanstalk.com/api/campaign/53675/update?sortBy=createdDate&direction=DESC&size=10&page=0
        
        SVProgressHUD.show()
        let prmList:[String: Any] = [:]
        let apiName = String(format:"/campaign/\(campaignId)/update?sortBy=createdDate&size=%d&page=%d&order=DESC", PER_PAGE_CONTENT,PAGE_NUMBER(total: arrUpdate.count))
        let request = MakeGetRequest.init(parameterList: prmList, APIName: apiName)
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: UpdateListResponse?) in
            SVProgressHUD.dismiss()
            if let myData = getMyData
            {
                self.arrUpdate = myData.allUpdate
                if self.arrUpdate.count > 3
                {
                    self.totalUpdateCount = 3
                }
                else
                {
                    self.totalUpdateCount = self.arrUpdate.count
                }
                self.totalUpdateCount = self.arrUpdate.count
                self.tblVwOrganCampOverview.reloadData()
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
                        self.arrUpdate = [UpdateDetails]()
                        self.tblVwOrganCampOverview.reloadData()
                        let msg:String = err.description
                        Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: msg)
                    }
                    
                }
            }
        })
    }
    func AllCommentListCall(campaignId: Int)
    {
        //http://fordonor.us-west-2.elasticbeanstalk.com/api/campaign/53675/comment?sortBy=createdDate&direction=DESC&size=10&page=0
        SVProgressHUD.show()
        let prmList:[String: Any] = [:]
        let apiName = String(format:"/campaign/\(campaignId)/comment?sortBy=createdDate&size=%d&page=%d&order=DESC", PER_PAGE_CONTENT,PAGE_NUMBER(total: arrComment.count))
        let request = MakeGetRequest.init(parameterList: prmList, APIName: apiName)
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: CommentListResponse?) in
            SVProgressHUD.dismiss()
            if let myData = getMyData
            {
                self.arrComment = myData.allComment
                if self.arrComment.count > 3
                {
                    self.totalCommentCount = 3
                }
                else
                {
                    self.totalCommentCount = self.arrComment.count
                }
                self.tblVwOrganCampOverview.reloadData()
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
                        self.arrComment = [CommentDetails]()
                        self.tblVwOrganCampOverview.reloadData()
                        let msg:String = err.description
                        Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: msg)
                    }
                    
                }
            }
        })
    }
    
    
    func AllContributeListCall(campaignId: Int)
    {
        SVProgressHUD.show()
        let prmList:[String: Any] = [:]
        let request = MakeGetRequest.init(parameterList: prmList, APIName: "/campaign/contribution?id=\(campaignId)&sortBy=createdDate&direction=DESC")
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: ContributeListResponse?) in
            SVProgressHUD.dismiss()
            if let myData = getMyData
            {
                self.contributeContentArray = myData.content!
                print(myData.content![0].amount!)
                print(myData.content![0].contributorID!)
                self.tblVwOrganCampOverview.reloadData()
            }
            else
            {
                if let err = error as? URLError, err.code == .notConnectedToInternet
                {
                    if let vc = UIApplication.topViewController()
                    {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
                        {
                            Validation.showTransparentWindow(sender: vc, strMsg: "No Internet Connection!")
                        }
                    }
                }
                else
                {
                    if let err = error as? DDSError
                    {
                        self.tblVwOrganCampOverview.reloadData()
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
        var timeUntilEnd = Int()
        if timeToEnd != ""
        {
            timeUntilEnd = Int((df.date(from: timeToEnd)?.timeIntervalSinceNow)!)
        }
        if timeUntilEnd <= 0
        {
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

    // MARK: - Action
    @IBAction func btnBackPressed(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnDonateClick(sender: UIButton!)
    {
        if userId != self.campaignPosterId
        {
//            let  vc  = ChatDetailsController()
//            self.navigationController?.pushViewController(vc, animated: true)
//            vc.receiverId = String(format:"%d",campaignPosterId)
//            vc.campaignId = String(format:"%d",campaignId)
            
            let  vc  = ChatDetailsuserController()
            vc.campaignPosterId = campaignPosterId!
            vc.campaignId = campaignId
            vc.selectedTopicID = 57518
            vc.receiverName = self.dicCampaignDetails.firstname! + " " + self.dicCampaignDetails.lastname!
            vc.campaignName = self.dicCampaignDetails.campaign_name
            //vc.topicID = self.dicCampaignDetails.topicDetails.id
            self.navigationController?.pushViewController(vc, animated: true)
//            vc.receiverId = String(format:"%d",campaignPosterId)
//            vc.campaignId = String(format:"%d",campaignId)
        }
    }
    
    @objc func btnContributeClick(sender: UIButton!)
    {
        if userId != self.campaignPosterId
        {
            let moveViewController = QuickDonationController()
            moveViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            moveViewController.campaignId = self.campaignId
            self.navigationController?.present(moveViewController, animated: false, completion: nil)
        }
        else
        {
            
        }
    }
    
    func getPaymentFee()
    {
        SVProgressHUD.show()
        let prmList:[String: Any] = [:]
        let request = MakeGetRequest.init(parameterList: prmList, APIName: "/fee/\(countryID)")
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: OrganCampaignPaymentResponse?) in
            SVProgressHUD.dismiss()
            if getMyData != nil
            {
                let moveViewController = PaymentDetailsController()
                moveViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                moveViewController.campaignId = self.campaignId
                let listingFee : Int = (getMyData?.listingFee)!
                var str1 = String()
                str1 = String(listingFee)
                moveViewController.strAmount = str1
                self.navigationController?.present(moveViewController, animated: false, completion: nil)
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
                }
                else
                {
                    if let err = error as? DDSError
                    {
                        let msg:String = err.description
                        Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: msg)
                    }
                }
            }
        })
    }
    
    @objc func btnPublishClick(sender: UIButton!)
    {
        let isBankAdded: Bool = (UserDefaults.standard.bool(forKey: "isBanking"))
        let isVerified: Bool = (UserDefaults.standard.bool(forKey: "isVerified"))
        //getPaymentFee()
        if isBankAdded && isVerified
        {
            getPaymentFee()
        }
        else
        {
            let vc: PopUpController = PopUpController()
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.navigationController?.present(vc, animated: false, completion: nil)
        }
    }
    
    @objc func addUpdateClick(sender: UIButton!)
    {
        if userId == self.campaignPosterId
        {
            let moveViewController = AddCommentController()
            //moveViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            
            moveViewController.CampaignId = campaignId
            moveViewController.campaignPosterId = campaignPosterId
            moveViewController.userImage = userImage
            moveViewController.strPurpose = "Update"
            self.navigationController?.pushViewController(moveViewController, animated: true)
            //self.navigationController?.present(moveViewController, animated: false, completion: nil)
        }
        else
        {
            
        }
        
    }
    
    @objc func addCommentClick(sender: UIButton!)
    {
        let moveViewController = AddCommentController()
        //moveViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        moveViewController.CampaignId = campaignId
        moveViewController.campaignPosterId = campaignPosterId
        moveViewController.userImage = userImage
        moveViewController.strPurpose = "Comment"
        self.navigationController?.pushViewController(moveViewController, animated: true)
        //self.navigationController?.present(moveViewController, animated: false, completion: nil)
//        if userId == self.campaignPosterId || self.isColaborator == true
//        {
//            let moveViewController = AddCommentController()
//            moveViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//            self.navigationController?.present(moveViewController, animated: false, completion: nil)
//            moveViewController.CampaignId = campaignId
//            moveViewController.campaignPosterId = campaignPosterId
//            moveViewController.userImage = userImage
//            moveViewController.strPurpose = "Comment"
//        }
//        else
//        {
//
//        }
    }
    
    @objc func btnCommentArrow(sender: UIButton!)
    {
        let moveViewController = CommentListController()
        self.navigationController?.pushViewController(moveViewController, animated: true)
        moveViewController.strPurpose = "Comment"
        moveViewController.campaignId = campaignId
    }
    @objc func btnUpdateArrow(sender: UIButton!)
    {
        let moveViewController = CommentListController()
        self.navigationController?.pushViewController(moveViewController, animated: true)
        moveViewController.strPurpose = "Update"
        moveViewController.campaignId = campaignId
    }
    
}

extension OrganCampaignOverviewController: UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if self.contributeContentArray.count > 5
        {
            return 5
        }
        else
        {
            return self.contributeContentArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContributeDetailsCell", for: indexPath) as? ContributeDetailsCell
        cell?.cellLabel.text = "$" + String(format: "%d", self.contributeContentArray[indexPath.row].amount!)
        cell?.cellImageView.layer.cornerRadius = (cell?.cellImageView.frame.size.height)! / 2
        let userID : Int = UserDefaults.standard.value(forKey: "userId")! as! Int
        let topicImageUrl = "https://s3-us-west-2.amazonaws.com/fordonor/user/images/user_\(userID).jpg"
        cell?.cellImageView.sd_setImage(with: URL(string: topicImageUrl ), placeholderImage: UIImage(named: No_Image))
        return cell!
    }
    
}

extension OrganCampaignOverviewController: UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = allTestPerk.count
        let count1 = allCollaborator.count
        print("Total Row:",count + count1 + 20)
        if self.contributeContentArray.count > 0
        {
            checkContribute = 0
            return count + count1 + 20 + self.totalCommentCount + self.totalUpdateCount
        }
        else
        {
            checkContribute = 1
            return count + count1 + 19 + self.totalCommentCount + self.totalUpdateCount
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row==0
        {
            return 25
        }
        else if indexPath.row==1
        {
            return 306
        }
        else if indexPath.row==2
        {
            return 58
        }
        else if indexPath.row==3
        {
            return 64
        }
        else if indexPath.row==4
        {
            return 42
        }
        else if indexPath.row==5
        {
            return 120
        }
        else if indexPath.row==6
        {
            return 100
        }
        else if indexPath.row==7
        {
            return 140
        }
        else if indexPath.row==8
        {
            return 56
        }
        else if indexPath.row==9
        {
            return 100
        }
        else if indexPath.row==10
        {
            return 83
        }
        else if indexPath.row==11
        {
            return 120
        }
        else if indexPath.row==12
        {
            return 50
        }
        else if indexPath.row==13
        {
            return 54
        }
        else if indexPath.row==14
        {
            return 80
        }
        else if indexPath.row==(15 - checkContribute)
        {
            return 54
        }
        else if indexPath.row > 15 && indexPath.row < (16 + self.totalUpdateCount - checkContribute)
        {
            return 100
        }
        else if indexPath.row == (16 + self.totalUpdateCount - checkContribute)
        {
            return 54
        }
        else if indexPath.row > 16 && indexPath.row < (17 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
        {
            return 85
        }
        else if indexPath.row == (17 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
        {
            return 54
        }
        if allTestPerk.count > 0 && indexPath.row > (17 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
        {
            if allTestPerk.count >= indexPath.row - (17 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
            {
                return 150
            }
             else if allTestPerk.count >= indexPath.row - (18 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
            {
                return 60
            }
            else if allCollaborator.count > 0 && indexPath.row > (19 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
            {
                if allCollaborator.count >= indexPath.row - (19 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
                {
                    return 100
                }
                else
                {
                    return 44
                }
            }
            else
            {
                return 44
            }
        }
        else if indexPath.row==(allTestPerk.count + indexPath.row + self.totalUpdateCount + self.totalCommentCount - checkContribute)
        {
            if indexPath.row == (18 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
            {
                return 60
            }
            else if allCollaborator.count > 0 && indexPath.row > (19 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
            {
                if allCollaborator.count >= indexPath.row - (19 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
                {
                    return 100
                }
                else
                {
                    return 44
                }
            }
            else
            {
                return 44
            }
        }
        else
        {
            if indexPath.row == (19 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
            {
                return 60
            }
            else
            {
                return 44
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if indexPath.row==0
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! NameCell
            cell.selectionStyle = .none
            if campaignType == "1"
            {
                cell.lblName.text = "Donation Camp"
            }
            else
            {
                cell.lblName.text = "Organ Camp"
            }
            
            return cell
        }
        else if indexPath.row==1
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "ScrollImageCell", for: indexPath) as! ScrollImageCell
            cell.selectionStyle = .none
            cell.lblName.text = self.campaignName
            for index in 0..<alIImages.count {
                
                frame.origin.x = cell.scrlVwImage.frame.size.width * CGFloat(index)
                frame.size = cell.scrlVwImage.frame.size
                let images: String = alIImages[index] as! String
                let imageUrl = UrlUtil.getCampaignImage(image: images)
                var imageView : UIImageView
                imageView  = UIImageView(frame:frame)
                //imageView.translatesAutoresizingMaskIntoConstraints = false
                //imageView.addConstraints([NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: CGFloat(1), constant: CGFloat(0))])
                
                
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.sd_setImage(with: URL(string: imageUrl ), placeholderImage: UIImage(named: No_Image))
                
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
            cell.selectionStyle = .none
            //cell.lblTopic.text = self.topicName
            //let getPrice = String(self.goalAmount)
            let getPrice = String(self.raisedAmount)
            if getPrice != nil
            {
                cell.lblPrice.text = "raised of $" + String(getPrice)
            }
            
            return cell
        }
        else if indexPath.row==3
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! DateCell
            cell.selectionStyle = .none
            let fundText1 = "216%"
            let fundText2 = " funded"
            let fundMainString = fundText1 + fundText2
            let range = (fundMainString as NSString).range(of: fundText1)
            let attribute = NSMutableAttributedString.init(string: fundMainString)
            attribute.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 16.0) , range: range)
            attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black , range: range)
            cell.lblPrecentageFund.attributedText = attribute
            
            cell.progressBar.setProgress(self.getAmount, animated: true)
            
            let daysText = " days left"
            let daysMainString = diffInDays + daysText
            let dayRange = (daysMainString as NSString).range(of: diffInDays)
            let dayAttribute = NSMutableAttributedString.init(string: daysMainString)
            dayAttribute.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 16.0) , range: dayRange)
            dayAttribute.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black , range: dayRange)
            cell.lblDate.attributedText = dayAttribute
            
            return cell
        }
        else if indexPath.row==4
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "GetLocationCell", for: indexPath) as! GetLocationCell
            cell.selectionStyle = .none
            cell.lblTopic.text = self.topicName
            cell.lblCountyName.text = self.city + ", " + self.country
            //cell.lblCountyName.text = dicCampaignDetails.location
            return cell
        }
        else if indexPath.row==5
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "OrganImageCell", for: indexPath) as! OrganImageCell
            cell.selectionStyle = .none
            cell.vwOrgan.layer.masksToBounds = true
            cell.vwOrgan.layer.cornerRadius = cell.vwOrgan.frame.size.height / 2
            return cell
            
        }
        else if indexPath.row==6
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "PersonalDetailsCell", for: indexPath) as! PersonalDetailsCell
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==7
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "GetDescriptionCell", for: indexPath) as! GetDescriptionCell
            cell.selectionStyle = .none
            cell.tvDescription.text = self.campaignDescription
            cell.btnReadStory.layer.masksToBounds = true
            cell.btnReadStory.layer.cornerRadius = 16
            cell.tvDescription.text = campaignDescription
            return cell
        }
        else if indexPath.row==8
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "SelectAnOfferCell", for: indexPath) as! SelectAnOfferCell
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==9
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "PRECell", for: indexPath) as! PRECell
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==10
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "AskingPriceCell", for: indexPath) as! AskingPriceCell
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==11
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "PolicyCell", for: indexPath) as! PolicyCell
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==12
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "RecentActivityTitleCell", for: indexPath) as! RecentActivityTitleCell
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==13
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "ContributionTitleCell", for: indexPath) as! ContributionTitleCell
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==14
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "ContributionListCell", for: indexPath) as! ContributionListCell
            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==(15 - checkContribute)
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "UpdateTitleCell", for: indexPath) as! UpdateTitleCell
            cell.selectionStyle = .none
            if self.userId == self.campaignPosterId
            {
                cell.btnAddUpdate.isHidden = false
            }
            else
            {
                cell.btnAddUpdate.isHidden = true
            }
            cell.lblUpdateCount.text = "(" + String(self.totalUpdateCount) + ")"
            cell.btnAddUpdate?.addTarget(self, action: #selector(self.addUpdateClick), for: UIControlEvents.touchUpInside)
            cell.btnAddUpdate.tag = indexPath.row
            cell.btnAllUpdate?.addTarget(self, action: #selector(self.btnUpdateArrow), for: UIControlEvents.touchUpInside)
            cell.btnAllUpdate.tag = indexPath.row
            return cell
        }
        else if indexPath.row > 15 && indexPath.row < (16 + self.totalUpdateCount - checkContribute)
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "UpdateCell", for: indexPath) as! UpdateCell
            cell.selectionStyle = .none
            
            let count = (indexPath.row + self.totalUpdateCount) - (11 + self.totalUpdateCount)
            cell.lblTitle.text = arrUpdate[count].posterFirstName! + "" + arrUpdate[count].posterLastName!
            cell.tvText.text = arrUpdate[count].message
            
            let date = Date(timeIntervalSince1970: arrUpdate[count].createdDate!)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
            cell.lblTime.text = dateFormatter.string(from: date)
            
            return cell
        }
        if allTestPerk.count > 0 && indexPath.row > (17 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
        {
            if allTestPerk.count >= indexPath.row - (17 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
            {
                let details: [String: String] = allTestPerk[indexPath.row - (18 + self.totalUpdateCount + self.totalCommentCount  - checkContribute)] as! [String : String]
                let  cell = tableView.dequeueReusableCell(withIdentifier: "CommentDetailsCell", for: indexPath) as! CommentDetailsCell
                cell.selectionStyle = .none
                cell.lblUserName.text = details["campaign_name"]
                cell.tvDetails.text = details["description"]
                
                return cell
            }
                
            else if allTestPerk.count >= indexPath.row - (18 + self.totalUpdateCount + self.totalCommentCount  - checkContribute)
            {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "CollaboratorTitleCell", for: indexPath) as! CollaboratorTitleCell
                cell.selectionStyle = .none
                return cell
            }
            else if allCollaborator.count > 0 && indexPath.row > (19 + self.totalUpdateCount + self.totalCommentCount  - checkContribute)
            {
                if allCollaborator.count >= indexPath.row - (19 + self.totalUpdateCount + self.totalCommentCount  - checkContribute)
                {
                    let details = allCollaborator[indexPath.row - (20 + self.totalUpdateCount + self.totalCommentCount  - checkContribute)]
                    let  cell = tableView.dequeueReusableCell(withIdentifier: "CollaboratorCell", for: indexPath) as! CollaboratorCell
                    cell.selectionStyle = .none
                    cell.imgVwUser.layer.masksToBounds = true
                    cell.imgVwUser.layer.cornerRadius = cell.imgVwUser.frame.size.height / 2
                    cell.vwCollaborator.layer.borderWidth = 2
                    cell.vwCollaborator.layer.borderColor = UIColor(red: 233/255.0, green: 234/255.0, blue: 237/255.0, alpha: 1).cgColor
                    let firstName = details.firstname ?? ""
                    let lastName = details.lastname ?? ""
                    let name = firstName + " " + lastName
                    let image = details.profileImg
                    
                    let getImage = UrlUtil.getUserImage(image: image)
                    cell.imgVwUser.sd_setImage(with: URL(string: getImage), placeholderImage: UIImage(named: Default_Image))
                    cell.lblUserName.text = name as? String
                    return cell
                }
                else
                {
                    return self.cellForConfirm(tableView: tableView, indexPath: indexPath)
                }
            }
            else
            {
                return self.cellForConfirm(tableView: tableView, indexPath: indexPath)
            }
        }
        else if indexPath.row == (16 + self.totalUpdateCount - checkContribute - checkContribute)
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTitleCell", for: indexPath) as! CommentsTitleCell
            cell.selectionStyle = .none
            print("self.totalCommentCount: ",self.totalCommentCount)
            cell.lblCommentCount.text = "(" + String(self.totalCommentCount) + ")"
            cell.btnAddComment?.addTarget(self, action: #selector(self.addCommentClick), for: UIControlEvents.touchUpInside)
            cell.btnAddComment.tag = indexPath.row
            cell.btnAllComment?.addTarget(self, action: #selector(self.btnCommentArrow), for: UIControlEvents.touchUpInside)
            cell.btnAllComment.tag = indexPath.row
            
            return cell
        }
        else if indexPath.row > 16 && indexPath.row < (17 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
            cell.selectionStyle = .none
            
            let count = (indexPath.row + self.totalCommentCount) - (17 + self.totalUpdateCount + self.totalCommentCount)
            cell.selectionStyle = .none
            
            cell.lblName.text = arrComment[count].posterFirstName! + "" + arrComment[count].posterLastName!
            let date = Date(timeIntervalSince1970: arrComment[count].createdDate!)
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
            
            cell.lblTime.text = dateFormatter.string(from: date)
            cell.tvText.text = arrComment[count].message
            
            return cell
        }
        else if indexPath.row == (17 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "CommentStaticCell", for: indexPath) as! CommentStaticCell
            cell.selectionStyle = .none
            return cell
        }
        
        else if indexPath.row==(allTestPerk.count + indexPath.row + self.totalUpdateCount + self.totalCommentCount - checkContribute)
        {
            if indexPath.row == (18 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
            {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "CollaboratorTitleCell", for: indexPath) as! CollaboratorTitleCell
                cell.selectionStyle = .none
                return cell
            }
            else if allCollaborator.count > 0 && indexPath.row > (19 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
            {
                if allCollaborator.count >= indexPath.row - (19 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
                {
                    let details = allCollaborator[indexPath.row - (20 + self.totalUpdateCount + self.totalCommentCount - checkContribute)]
                    let  cell = tableView.dequeueReusableCell(withIdentifier: "CollaboratorCell", for: indexPath) as! CollaboratorCell
                    cell.selectionStyle = .none
                    cell.imgVwUser.layer.masksToBounds = true
                    cell.imgVwUser.layer.cornerRadius = cell.imgVwUser.frame.size.height / 2
                    cell.vwCollaborator.layer.borderWidth = 2
                    cell.vwCollaborator.layer.borderColor = UIColor(red: 233/255.0, green: 234/255.0, blue: 237/255.0, alpha: 1).cgColor
                    let firstName = details.firstname
                    let lastName = details.lastname
                    let name = firstName! + " " + lastName!
                    let image = details.profileImg
                    
                    let getImage = UrlUtil.getUserImage(image: image)
                    cell.imgVwUser.sd_setImage(with: URL(string: getImage), placeholderImage: UIImage(named: Default_Image))
                    cell.lblUserName.text = name as? String
                    return cell
                }
                else
                {
                    return self.cellForConfirm(tableView: tableView, indexPath: indexPath)
                }
            }
            else
            {
                return self.cellForConfirm(tableView: tableView, indexPath: indexPath)
            }
        }
        else
        {
            if indexPath.row == (19 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
            {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "CollaboratorTitleCell", for: indexPath) as! CollaboratorTitleCell
                cell.selectionStyle = .none
                return cell
            }
            else
            {
                return self.cellForConfirm(tableView: tableView, indexPath: indexPath)
            }
        }
    }
    
    
    func cellForConfirm(tableView:UITableView, indexPath: IndexPath) -> UITableViewCell
    {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "ContributeOrDonateCell", for: indexPath) as! ContributeOrDonateCell
        cell.selectionStyle = .none
        cell.btnDonate?.addTarget(self, action: #selector(self.btnDonateClick), for: UIControlEvents.touchUpInside)
        cell.btnDonate.tag = indexPath.row
        
        cell.btnContribute?.addTarget(self, action: #selector(self.btnContributeClick), for: UIControlEvents.touchUpInside)
        cell.btnContribute.tag = indexPath.row
        cell.btnPublish.addTarget(self, action: #selector(self.btnPublishClick(sender:)), for: .touchUpInside)
        cell.btnPublish.tag = indexPath.row
        cell.selectionStyle = .none
        if userId != campaignPosterId && dicCampaignDetails.status == 1
        {
            cell.btnDonate.isHidden = false
            cell.btnContribute.isHidden = false
            cell.btnPublish.isHidden = true
        }
        else
        {
            cell.btnDonate.isHidden = true
            cell.btnContribute.isHidden = true
            cell.btnPublish.isHidden = false
        }

        return cell
    }
}
