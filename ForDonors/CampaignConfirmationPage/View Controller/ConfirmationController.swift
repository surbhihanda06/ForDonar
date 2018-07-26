//
//  ConfirmationController.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 29/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import SVProgressHUD
class ConfirmationController: UIViewController {
    
    @IBOutlet weak var tblVwCampaignPreview: UITableView!
    @IBOutlet weak var lblPageTitle: UILabel!
    @IBOutlet weak var vwBack: UIView!
    var dicCampaignDetails: CampaignDetailsResponse!
    
    var allTestPerk: NSMutableArray = NSMutableArray()
    var allPerk = [PerksToSend]()
    var allCollaborator = [User]()
    var allStaticCollaborator: NSMutableArray = NSMutableArray()
    var alIImages: NSMutableArray = NSMutableArray()
    
    var arrComment = [CommentDetails]()
    var arrUpdate = [UpdateDetails]()
    
    var campaignId: Int!
    
    var campaignName: String = ""
    var campaignType: String = ""
    var topicName: String = ""
    var topicId = 0
    var goalAmount: Float = 0.0
    var raisedAmount: Float = 0.0
    var getAmount: Float = 0.0
    var expireDate: Int!
    var campaignDescription: String = ""
    var diffInDays: String = ""
    
    var isVerified = Bool()
    var userImage: String = ""
    var userId: Int!
    var campaignPosterId: Int! = 0
    var isColaborator = false
    
    var addedBankAccount = ""
    
    var parkAmount: String = ""
    
    var resultDay :Int!
    var remainHour :Int!
    var Quotient :Int!
    var reminder :Int!
    
    var commentCount = 0
    var updateCount = 0
    
    var totalCommentCount = 0
    var totalUpdateCount = 0
    
    var fromOrgan = false
    var fromHomeOrUpload: String!
    
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var country : String = ""
    var city : String = ""
    var noContribution: Int = 0
    var contributeContentArray = [ContentListResponse]()
    var checkContribute : Int = 1
    var status : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        userId = UserDefaults.standard.object(forKey: "userId") as? Int ?? 0
        
        cellRegistration()
        
        let dict: [String: String] = ["campaign_name": "Campaign Name", "description": "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "estimated_delivery_date": "02-03-2018", "id": "0", "perks_image": "", "price": "10", "title": "Test Perk"]
        //allTestPerk.add(dict)
        
        let dictColaborator: [String: String] = ["name": "Jessy Lancome", "image": "23"]
        allStaticCollaborator.add(dictColaborator)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        lblPageTitle.text = "Campaign Overview".localized
        makeCampaignDetailsServiceCall()
        AllUpdateListCall(campaignId: campaignId)
        AllCommentListCall(campaignId: campaignId)
        AllContributeListCall(campaignId: campaignId)
        
        if fromHomeOrUpload == "Home"
        {
            lblPageTitle.text = "Details"
            //vwBack.isHidden = false
        }
        else
        {
            lblPageTitle.text = "Campaign Overview"
            //vwBack.isHidden = true
        }
        if fromOrgan == false
        {
            vwBack.isHidden = false
        }
        else
        {
            vwBack.isHidden = true
        }
//        let isBankAdded: Bool = (UserDefaults.standard.bool(forKey: "isBanking"))
//        let isVerified: Bool = (UserDefaults.standard.bool(forKey: "isVerified"))
//        if isBankAdded && isVerified
//        {
//            
//        }
//        else
//        {
//            let moveViewController = PopUpController()
//            moveViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//            self.navigationController?.present(moveViewController, animated: false, completion: nil)
//            moveViewController.isVerified = self.isVerified
//            moveViewController.existBankAccount = self.addedBankAccount
//            moveViewController.creatorImage = self.userImage
//        }
    }
    
    // MARK: - Register Nib
    
    func cellRegistration()   {
        tblVwCampaignPreview.register(UINib(nibName: "NameCell", bundle: Bundle.main), forCellReuseIdentifier: "NameCell")
        
        tblVwCampaignPreview.register(UINib(nibName: "ScrollImageCell", bundle: Bundle.main), forCellReuseIdentifier: "ScrollImageCell")
        
        tblVwCampaignPreview.register(UINib(nibName: "PriceCell", bundle: Bundle.main), forCellReuseIdentifier: "PriceCell")
        
        tblVwCampaignPreview.register(UINib(nibName: "DateCell", bundle: Bundle.main), forCellReuseIdentifier: "DateCell")
        
        tblVwCampaignPreview.register(UINib(nibName: "GetLocationCell", bundle: Bundle.main), forCellReuseIdentifier: "GetLocationCell")
        
        tblVwCampaignPreview.register(UINib(nibName: "GetDescriptionCell", bundle: Bundle.main), forCellReuseIdentifier: "GetDescriptionCell")
        
        tblVwCampaignPreview.register(UINib(nibName: "SelectAPerkCell", bundle: Bundle.main), forCellReuseIdentifier: "SelectAPerkCell")
        
        tblVwCampaignPreview.register(UINib(nibName: "PerkCell", bundle: Bundle.main), forCellReuseIdentifier: "PerkCell")
        
        tblVwCampaignPreview.register(UINib(nibName: "RecentActivityTitleCell", bundle: Bundle.main), forCellReuseIdentifier: "RecentActivityTitleCell")
        
        tblVwCampaignPreview.register(UINib(nibName: "ContributionCountCell", bundle: Bundle.main), forCellReuseIdentifier: "ContributionCountCell")
        
        tblVwCampaignPreview.register(UINib(nibName: "ContributionListCell", bundle: Bundle.main), forCellReuseIdentifier: "ContributionListCell")
        
        tblVwCampaignPreview.register(UINib(nibName: "UpdatesCountCell", bundle: Bundle.main), forCellReuseIdentifier: "UpdatesCountCell")
        
        tblVwCampaignPreview.register(UINib(nibName: "CommentCountCell", bundle: Bundle.main), forCellReuseIdentifier: "CommentCountCell")
        
        tblVwCampaignPreview.register(UINib(nibName: "CollaboratorTitleCell", bundle: Bundle.main), forCellReuseIdentifier: "CollaboratorTitleCell")
        
        tblVwCampaignPreview.register(UINib(nibName: "CollaboratorCell", bundle: Bundle.main), forCellReuseIdentifier: "CollaboratorCell")
        
        tblVwCampaignPreview.register(UINib(nibName: "ConfirmCell", bundle: Bundle.main), forCellReuseIdentifier: "ConfirmCell")
        
        tblVwCampaignPreview.register(UINib(nibName: "UpdateCell", bundle: Bundle.main), forCellReuseIdentifier: "UpdateCell")
        
        tblVwCampaignPreview.register(UINib(nibName: "CommentCell", bundle: Bundle.main), forCellReuseIdentifier: "CommentCell")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action
    
    func randRange (lower: Int , upper: Int) -> Int
    {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    @objc func confirmPressed(sender: UIButton!)
    {
        //makeCampaignDetailsServiceCall()
    }
    @IBAction func btnBackPressed(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @objc func btnConfirmClick(sender: UIButton!)
    {
        
         let isBankAdded: Bool = (UserDefaults.standard.bool(forKey: "isBanking"))
         let isVerified: Bool = (UserDefaults.standard.bool(forKey: "isVerified"))
        if sender.title(for: .normal) == "Publish"
        {
            if isBankAdded == true && isVerified == true
            {
                makePublishRequest(campaignId: campaignId)
            }
            else
            {
                let moveViewController = PopUpController()
                moveViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                self.navigationController?.present(moveViewController, animated: false, completion: nil)
                moveViewController.isVerified = self.isVerified
                moveViewController.existBankAccount = self.addedBankAccount
                moveViewController.creatorImage = self.userImage
            }
            
        }
        else
        {
            if userId != self.campaignPosterId
            {
                let moveViewController = QuickDonationController()
                moveViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                self.navigationController?.present(moveViewController, animated: false, completion: nil)
                moveViewController.campaignId = campaignId
            }
            else
            {
                
            }
        }
        
    }
    @objc func addUpdateClick(sender: UIButton!)
    {
        if userId == self.campaignPosterId
        {
            let moveViewController = AddCommentController()
            moveViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.navigationController?.present(moveViewController, animated: false, completion: nil)
            moveViewController.CampaignId = campaignId
            moveViewController.campaignPosterId = campaignPosterId
            moveViewController.userImage = userImage
            moveViewController.strPurpose = "Update"
        }
        else
        {
            
        }
        
    }
    @objc func getParkClick(sender: UIButton!)
    {
        let details = allPerk[sender.tag]
        self.parkAmount = "\(details.price)"
        let parkId = details.id
        let moveViewController = PaymentDetailsController()
        moveViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.navigationController?.present(moveViewController, animated: false, completion: nil)
        moveViewController.strAmount = self.parkAmount
        moveViewController.campaignId = self.campaignId
        moveViewController.parkId = parkId
        
    }
    @objc func addCommentClick(sender: UIButton!)
    {
        if userId == self.campaignPosterId || self.isColaborator == true
        {
            let moveViewController = AddCommentController()
            moveViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.navigationController?.present(moveViewController, animated: false, completion: nil)
            moveViewController.CampaignId = campaignId
            moveViewController.campaignPosterId = campaignPosterId
            moveViewController.userImage = userImage
            moveViewController.strPurpose = "Comment"
        }
        else
        {
            
        }
        
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
    @objc func btnReadStory(sender: UIButton!)
    {
        let moveViewController = DescriptionController()
        self.navigationController?.pushViewController(moveViewController, animated: true)
        moveViewController.strDescription = campaignDescription
    }
    
    func timerValue(_ timeToEnd: String) -> String
    {
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        let timeUntilEnd = Int((df.date(from: timeToEnd)?.timeIntervalSinceNow)!)
        if timeUntilEnd <= 0
        {
            return " 0"
        }
        else
        {
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
    
    func getDate(unixdate: Int, timezone: String) -> String {
        if unixdate == 0 {return ""}
        let date = NSDate(timeIntervalSince1970: TimeInterval(unixdate))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
        dayTimePeriodFormatter.timeZone = NSTimeZone(name: timezone) as TimeZone!
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return "Updated: \(dateString)"
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
                self.allPerk = self.dicCampaignDetails.perks
                //self.allPerk.removeAll()
                self.campaignName = self.dicCampaignDetails.campaign_name ?? ""
                let topicDetails = self.dicCampaignDetails.topicDetails
                self.topicName = (topicDetails?.name)!
                self.topicId = (topicDetails?.id)!
                self.status = self.dicCampaignDetails.status!
                self.campaignType = self.dicCampaignDetails.campaignType ?? ""
                self.alIImages = self.dicCampaignDetails.images
                self.campaignDescription = self.dicCampaignDetails.description ?? ""
                self.expireDate = self.dicCampaignDetails.expirationDate
                let date = String(self.expireDate)
                self.noContribution = self.dicCampaignDetails.noContribution
                if self.noContribution > 5
                {
                    self.noContribution = 5
                }
                
                if let theDate = Date(jsonDate: "/Date(\(date))/") {
                    let dateformatter = DateFormatter()
                    dateformatter.dateFormat = "MM/dd/yyyy"
                    let finalDate = dateformatter.string(from: theDate)
                    self.diffInDays = self.timerValue(finalDate)
                    print("self.diffInDays",self.diffInDays)
                } else {
                    print("wrong format")
                }
                /*
                let date = Date(timeIntervalSince1970: self.expireDate)
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(abbreviation: "Etc/UTC") //Set timezone that you want
                dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
                let strDate = dateFormatter.string(from: date)
 
                //let date = Date(timeIntervalSince1970: self.expireDate)
                
                */
                /*
                 let formatter = NSDateComponentsFormatter()
                 formatter.allowedUnits = [.Hour, .Minute]
                 formatter.unitsStyle = .Short
                 if let difference = formatter.stringFromDate(date, toDate: nowDate) {
                 print(difference)
                 } else {
                 print("invalid difference")
                 }
 */
                
                
                //self.diffInDays = ""
                self.goalAmount = Float(self.dicCampaignDetails.price)
                self.raisedAmount = Float(self.dicCampaignDetails.raisedAmount)
                self.country = self.dicCampaignDetails.country!
                self.city = self.dicCampaignDetails.city!
                print("raisedAmount",self.raisedAmount)
                print("goalAmount",self.goalAmount)
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
                print("self.getAmount--:> ",self.getAmount)
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
                
                self.campaignPosterId = self.dicCampaignDetails.userId
                self.userImage = self.dicCampaignDetails.profileImg ?? ""
                self.isVerified = self.dicCampaignDetails.verified
                
                
//                if self.userImage != nil
//                {
//                    let getImage = UrlUtil.getUserImage(image: self.userImage)
//                    self.imgVwUser.sd_setImage(with: URL(string: getImage), placeholderImage: UIImage(named: "defaultImage"))
//                }
                
                
                
                self.tblVwCampaignPreview.reloadData()
//                let cell = ContributionListCell()
//                cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: 9)
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
    func makePublishRequest(campaignId: Int)
    {
        //http://fordonor.us-west-2.elasticbeanstalk.com/api/campaign/5644646/activate?userId=78687&status=true
        
        SVProgressHUD.show()
        let id = String(campaignId)
        
        let prmList:[String: Any] = [:]
        let request = MakePutRequest.init(parameterList: prmList, APIName: "/campaign/\(id)/activate?userId=\(String(userId))&status=true")
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: CampaignResponse?) in
            
            SVProgressHUD.dismiss()
            if getMyData?.data != nil
            {
//                let moveViewController = PopUpController()
//                moveViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//                self.navigationController?.present(moveViewController, animated: false, completion: nil)
//                moveViewController.isVerified = self.isVerified
//                moveViewController.creatorImage = self.userImage
                let vc : HomeController = HomeController()
                self.navigationController?.pushViewController(vc, animated: true)
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
                self.tblVwCampaignPreview.reloadData()
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
                        self.tblVwCampaignPreview.reloadData()
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
                self.tblVwCampaignPreview.reloadData()
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
                        self.tblVwCampaignPreview.reloadData()
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
                self.tblVwCampaignPreview.reloadData()
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
                        self.tblVwCampaignPreview.reloadData()
                        let msg:String = err.description
                        Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: msg)
                    }
                    
                }
            }
        })
    }
    /*
    func makeParkList(strCampname: String) -> [[String:Any]]
    {
        var arrPrks = [[String:Any]]()
        for perk in allPerk
        {
            let title: String? = perk.title ?? ""
            let description: String? = perk.description ?? ""
            let price: String? = perk.price ?? ""
            let date: String? = perk.date ?? ""
            let image: UIImage? = perk.image
            
            //TODO: Jhar Atkao from Image
            
            let dict = ["campaign_name": strCampname, "description": description!, "estimated_delivery_date": date!, "id": 0, "perks_image": image!, "price": (price?.toInt(defaultValue: 0))!, "title": title!] as [String : Any]
            arrPrks.append(dict)
        }
        return arrPrks
    }
 
    func makeCollabList(strCampname: String) -> [[String:Any]]
    {
        var arrCollabs = [[String:Any]]()
        for collab in allCollaborator
        {
            let id: Int = collab.id
            let email: String? = collab.email
            let user_img: String? = collab.user_img
            let user_name: String? = collab.user_name
            let campaign_name: String? = collab.campaign_name
            
            let dict = ["id": id, "email": email!, "user_img": user_img!, "user_name": user_name!, "campaign_name": campaign_name!] as [String : Any]
            arrCollabs.append(dict)
        }
        return arrCollabs
    }
    func makeImageList() -> [String]
    {
        var arrImgs = [String]()
        for image in alIImages
        {
            arrImgs.append(image as! String)
        }
        return arrImgs
    }
    */
}

extension ConfirmationController: UICollectionViewDelegate,UICollectionViewDataSource
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
        //let topicImageUrl = String(format:"https://s3-us-west-2.amazonaws.com/fordonor/topic/images/user_\(userId).jpg", userID)
        let topicImageUrl = "https://s3-us-west-2.amazonaws.com/fordonor/user/images/user_\(userID).jpg"
        cell?.cellImageView.sd_setImage(with: URL(string: topicImageUrl ), placeholderImage: UIImage(named: No_Image))
        return cell!
    }
    
}

extension ConfirmationController: UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let count = allPerk.count
        let count1 = allCollaborator.count
        if arrComment.count >= 3
        {
            commentCount = 3
        }
        else
        {
            commentCount = arrComment.count
        }
        if arrUpdate.count >= 3
        {
            updateCount = 3
        }
        else
        {
            updateCount = arrUpdate.count
        }
        print("Total Row:",count + count1 + 14)
        if self.contributeContentArray.count > 0
        {
            checkContribute = 0
            return count + count1 + 14 + self.totalCommentCount + self.totalUpdateCount
        }
        else
        {
            checkContribute = 1
            return count + count1 + 13 + self.totalCommentCount + self.totalUpdateCount
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
            return 140
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
                return 50
            }
            else if allPerk.count >= indexPath.row - 8
            {
                return 54
            }
            else if allPerk.count >= indexPath.row - 9
            {
                return 110
            }
            else if allPerk.count >= indexPath.row - (10 - checkContribute)
            {
                return 54
            }
            else if self.totalUpdateCount > 0 && allPerk.count > indexPath.row - (11 + self.totalUpdateCount - checkContribute)
            {
                return 100
            }
            else if allPerk.count >= indexPath.row - (11 + self.totalUpdateCount - checkContribute)
            {
                return 54
            }
            else if self.totalCommentCount > 0 && allPerk.count > indexPath.row - (12 + self.totalCommentCount + self.totalUpdateCount - checkContribute)
            {
                return 85
            }
            else if allPerk.count >= indexPath.row - (12 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
            {
                return 60
            }
            else
            {
                if allCollaborator.count > 0 && indexPath.row > (13 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
                {
                    if allCollaborator.count <= indexPath.row - 13 && indexPath.row < (13 + allCollaborator.count + allPerk.count + self.totalUpdateCount + self.totalCommentCount - checkContribute)
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
        else if indexPath.row==allPerk.count + indexPath.row - checkContribute
        {
            if indexPath.row == 7 - checkContribute
            {
                return 50
            }
            else if indexPath.row == 8 - checkContribute
            {
                return 54
            }
            else if indexPath.row == 9 - checkContribute
            {
                return 110
            }
            else if indexPath.row == 10 - checkContribute
            {
                return 54
            }
            else if indexPath.row > 10 && indexPath.row < (11 + self.totalUpdateCount - checkContribute)
            {
                return 100
            }
            else if indexPath.row == (11 + self.totalUpdateCount - checkContribute)
            {
                return 54
            }
            else if indexPath.row > 11 && indexPath.row < (12 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
            {
                return 85
            }
            else if allCollaborator.count > 0 && indexPath.row > (12 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
            {
                if allCollaborator.count >= indexPath.row - (12 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
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
           if indexPath.row == (12 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
            {
                return 60
            }
            else
            {
                return 60
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print("indexpath===",indexPath.row)
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
            let amount = Int(self.getAmount)
            let fundText1 = String(amount * 100) + "%"
            let fundText2 = " funded"
            let fundMainString = fundText1 + fundText2
            let range = (fundMainString as NSString).range(of: fundText1)
            let attribute = NSMutableAttributedString.init(string: fundMainString)
            attribute.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 16.0) , range: range)
            attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black , range: range)
            cell.lblPrecentageFund.attributedText = attribute
            
            //cell.progressBar.transform = cell.progressBar.transform.scaledBy(x: 1, y: 2)
            print("self.getAmount-----",self.getAmount)
            cell.progressBar.setProgress(self.getAmount, animated: true)
            DispatchQueue.main.async {
                //
                
            }
            let daysText = " days left"
            let daysMainString = diffInDays + daysText
            let dayRange = (daysMainString as NSString).range(of: diffInDays)
            let dayAttribute = NSMutableAttributedString.init(string: daysMainString)
            dayAttribute.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 16.0) , range: dayRange)
            dayAttribute.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black , range: dayRange)
            cell.lblDate.attributedText = dayAttribute
            
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==4
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "GetLocationCell", for: indexPath) as! GetLocationCell
            cell.selectionStyle = .none
            let topicId = String(self.topicId)
            let topicImageUrl = String(format:"https://s3-us-west-2.amazonaws.com/fordonor/topic/images/topic_\(topicId).jpg",self.topicId)
            cell.imgVwTopic.sd_setImage(with: URL(string: topicImageUrl ), placeholderImage: UIImage(named: No_Image))
            cell.lblTopic.text = self.topicName
            //cell.lblCountyName.text = dicCampaignDetails.location
            //cell.lblCountyName.text = dicCampaignDetails.city! + ", " + dicCampaignDetails.country!
            cell.lblCountyName.text = self.city + ", " + self.country
            return cell
        }
        else if indexPath.row==5
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "GetDescriptionCell", for: indexPath) as! GetDescriptionCell
            cell.selectionStyle = .none
            cell.tvDescription.text = self.campaignDescription
            cell.btnReadStory.layer.masksToBounds = true
            cell.btnReadStory.layer.cornerRadius = 16
            
            cell.btnReadStory?.addTarget(self, action: #selector(self.btnReadStory), for: UIControlEvents.touchUpInside)
            cell.btnReadStory.tag = indexPath.row
            
            return cell
        }
        else if indexPath.row==6
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "SelectAPerkCell", for: indexPath) as! SelectAPerkCell
            cell.selectionStyle = .none
            return cell
        }
        if allPerk.count > 0 && indexPath.row > 6
        {
            if allPerk.count >= indexPath.row - 6
            {
                let details = allPerk[indexPath.row - 7]
                let  cell = tableView.dequeueReusableCell(withIdentifier: "PerkCell", for: indexPath) as! PerkCell
                cell.selectionStyle = .none
                cell.btnGetThisPerk.layer.masksToBounds = true
                cell.btnGetThisPerk.layer.cornerRadius = 16
                
                cell.vwPerkImage.layer.masksToBounds = true
                cell.vwPerkImage.layer.borderWidth = 2
                cell.vwPerkImage.layer.borderColor = UIColor(red: 233/255.0, green: 234/255.0, blue: 237/255.0, alpha: 1).cgColor
                
//                let title = details["title"]
//                let description = details["description"]
//                cell.lblPerkName.text = title
//                cell.tvPerkDescription.text = description
                if details.estimated_delivery_date != nil
                {
                    let estimatedDate = details.estimated_delivery_date
                    let dateformatter = DateFormatter()
                    dateformatter.dateFormat = "MM/dd/yyyy"
                    let getDate = dateformatter.date(from: estimatedDate!)
                    dateformatter.dateFormat = "MMM,yyyy"
                    let finalDate = dateformatter.string(from: getDate!)
                    
                    let daysText = " Estimated Delivery: "
                    let daysMainString = daysText + String(finalDate)
                    let dayRange = (daysMainString as NSString).range(of: String(finalDate))
                    let dayAttribute = NSMutableAttributedString.init(string: daysMainString)
                    dayAttribute.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 14.0), range: dayRange)
                    //boldSystemFont(ofSize: 14.0) , range: dayRange
                    dayAttribute.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black , range: dayRange)
                    cell.lblEstimatedDeliverDate.attributedText = dayAttribute
                }
                
                
                cell.lblPerkName.text = details.title
                cell.tvPerkDescription.text = details.description
               let parkItems = details.items
               cell.tvItems.text = parkItems.map { "\($0)" }.joined(separator:"\n")
                cell.lblPrice.text = "$" + "\(details.price)"
                
                cell.btnGetThisPerk?.addTarget(self, action: #selector(self.getParkClick), for: UIControlEvents.touchUpInside)
                cell.btnGetThisPerk.tag = indexPath.row - 7
                
                /*
                
                let randomItem = Int(arc4random() % UInt32(parkItems.count))
                cell.tvPerkDescription.text = "\(parkItems[randomItem])"
                */
                /*
                let randNum : Int = randRange(lower: 0 , upper: parkItems.count - 1)
                cell.tvPerkDescription.text = parkItems[randNum] as! String
                */
                return cell
            }
            else if allPerk.count >= indexPath.row - 7
            {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "RecentActivityTitleCell", for: indexPath) as! RecentActivityTitleCell
                cell.selectionStyle = .none
                return cell
            }
            else if allPerk.count >= indexPath.row - 8
            {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "ContributionCountCell", for: indexPath) as! ContributionCountCell
                cell.selectionStyle = .none
                return cell
            }
            else if allPerk.count >= indexPath.row - 9 && self.contributeContentArray.count > 0
            {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "ContributionListCell", for: indexPath) as! ContributionListCell
                cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
                cell.selectionStyle = .none
                return cell
            }
            else if allPerk.count >= indexPath.row - (10 - checkContribute)
            {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "UpdatesCountCell", for: indexPath) as! UpdatesCountCell
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
                cell.btnArrow?.addTarget(self, action: #selector(self.btnUpdateArrow), for: UIControlEvents.touchUpInside)
                cell.btnArrow.tag = indexPath.row
                return cell
            }
            else if self.totalUpdateCount > 0 && allPerk.count > indexPath.row - (11 + self.totalUpdateCount - checkContribute)
            {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "UpdateCell", for: indexPath) as! UpdateCell
                cell.selectionStyle = .none
                let count = (indexPath.row + self.totalUpdateCount) - (11 + self.totalUpdateCount + allPerk.count - checkContribute)
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
            else if allPerk.count >= indexPath.row - (11 + self.totalUpdateCount - checkContribute)
            {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "CommentCountCell", for: indexPath) as! CommentCountCell
                cell.selectionStyle = .none
                print("self.totalCommentCount: ",self.totalCommentCount)
                cell.lblCommentCount.text = "(" + String(self.totalCommentCount) + ")"
                cell.btnAddComment?.addTarget(self, action: #selector(self.addCommentClick), for: UIControlEvents.touchUpInside)
                cell.btnAddComment.tag = indexPath.row
                cell.btnArrow?.addTarget(self, action: #selector(self.btnCommentArrow), for: UIControlEvents.touchUpInside)
                cell.btnArrow.tag = indexPath.row
                return cell
            }
            else if self.totalCommentCount > 0 && allPerk.count > indexPath.row - (12 + self.totalCommentCount + self.totalUpdateCount - checkContribute)
            {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
                let count = (indexPath.row + self.totalCommentCount) - (12 + self.totalUpdateCount + self.totalCommentCount + allPerk.count - checkContribute)
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
            else if allPerk.count >= indexPath.row - (12 + self.totalCommentCount + self.totalUpdateCount - checkContribute)
            {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "CollaboratorTitleCell", for: indexPath) as! CollaboratorTitleCell
                cell.selectionStyle = .none
                return cell
            }
            else
            {
                print("indexPath.row:", indexPath.row)
                if allCollaborator.count > 0 && indexPath.row > (13 + self.totalCommentCount + self.totalUpdateCount - checkContribute)
                {
                    if allCollaborator.count <= indexPath.row - 13 && indexPath.row < (13 + allCollaborator.count + allPerk.count  + self.totalCommentCount + self.totalUpdateCount - checkContribute)
                    {
                        let details = allCollaborator[indexPath.row - (allPerk.count + 13  + self.totalCommentCount + self.totalUpdateCount - checkContribute)]
                        let  cell = tableView.dequeueReusableCell(withIdentifier: "CollaboratorCell", for: indexPath) as! CollaboratorCell
                        cell.selectionStyle = .none
                        cell.imgVwUser.layer.masksToBounds = true
                        cell.imgVwUser.layer.cornerRadius = cell.imgVwUser.frame.size.height / 2
                        cell.vwCollaborator.layer.masksToBounds = true
                        cell.vwCollaborator.layer.cornerRadius = cell.vwCollaborator.frame.size.height / 2
                        cell.vwCollaborator.layer.borderWidth = 2
                        cell.vwCollaborator.layer.borderColor = UIColor(red: 233/255.0, green: 234/255.0, blue: 237/255.0, alpha: 1).cgColor
                        let firstName = details.firstname ?? ""
                        let lastName = details.lastname ?? ""
                        let name = firstName + " " + lastName
                        let image = details.profileImg ?? ""
                        
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
        }
        
        else if indexPath.row==allPerk.count + indexPath.row - checkContribute
        {
            if indexPath.row == 7 - checkContribute
            {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "RecentActivityTitleCell", for: indexPath) as! RecentActivityTitleCell
                cell.selectionStyle = .none
                return cell
            }
            if indexPath.row == 8 - checkContribute
            {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "ContributionCountCell", for: indexPath) as! ContributionCountCell
                cell.selectionStyle = .none
                return cell
            }
            if indexPath.row == 9 - checkContribute
            {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "ContributionListCell", for: indexPath) as! ContributionListCell
                cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
                cell.selectionStyle = .none
                return cell
            }
            else if indexPath.row == 10 - checkContribute
            {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "UpdatesCountCell", for: indexPath) as! UpdatesCountCell
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
                cell.btnArrow?.addTarget(self, action: #selector(self.btnUpdateArrow), for: UIControlEvents.touchUpInside)
                cell.btnArrow.tag = indexPath.row
                return cell
            }
            else if indexPath.row > 10 && indexPath.row < (11 + self.totalUpdateCount - checkContribute)
            {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "UpdateCell", for: indexPath) as! UpdateCell
                cell.selectionStyle = .none
                let count = (indexPath.row + self.totalUpdateCount) - (11 + self.totalUpdateCount - checkContribute)
                
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
            else if indexPath.row == (11 + self.totalUpdateCount - checkContribute)
            {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "CommentCountCell", for: indexPath) as! CommentCountCell
                cell.selectionStyle = .none
                cell.lblCommentCount.text = "(" + String(self.totalCommentCount) + ")"
                cell.btnAddComment?.addTarget(self, action: #selector(self.addCommentClick), for: UIControlEvents.touchUpInside)
                cell.btnAddComment.tag = indexPath.row
                cell.btnArrow?.addTarget(self, action: #selector(self.btnCommentArrow), for: UIControlEvents.touchUpInside)
                cell.btnArrow.tag = indexPath.row
                return cell
            }
            else if indexPath.row > 11 && indexPath.row < (12 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
            {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
                let count = (indexPath.row + self.totalCommentCount) - (12 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
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
            else if allCollaborator.count > 0 && indexPath.row > (12 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
            {
                if allCollaborator.count >= indexPath.row - (12 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
                {
                    let details = allCollaborator[indexPath.row - (13 + self.totalUpdateCount + self.totalCommentCount - checkContribute)]
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
            if indexPath.row == (12 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
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
         
        else
        {
            if indexPath.row == (12 + self.totalUpdateCount + self.totalCommentCount - checkContribute)
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
        let  cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmCell", for: indexPath) as! ConfirmCell
        
        cell.btnConfirm?.addTarget(self, action: #selector(self.btnConfirmClick), for: UIControlEvents.touchUpInside)
        cell.btnConfirm.tag = indexPath.row
        cell.selectionStyle = .none
        cell.btnConfirm.tag = indexPath.row
        cell.btnConfirm?.addTarget(self, action: #selector(self.confirmPressed), for: UIControlEvents.touchUpInside)
        if userId != campaignPosterId && self.status == 1
        {
            cell.btnConfirm.setTitle("Contribute", for: .normal)
        }
        else
        {
            cell.btnConfirm.setTitle("Publish", for: .normal)
        }

        return cell
    }
}

