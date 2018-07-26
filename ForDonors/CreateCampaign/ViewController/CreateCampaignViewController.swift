//
//  CreateCampaignViewController.swift
//  ForDonors
//
//  Created by NITS_Mac4 on 16/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit
import AVFoundation
import AlamofireImage
import Alamofire
import SVProgressHUD
class CreateCampaignViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UINavigationControllerDelegate,StateListDelegate,CityDelegate,CountryListDelegate
{
    @IBOutlet weak var lblPageTitle: UILabel!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var vwChoose: UIView!
    @IBOutlet weak var vwUrl: UIView!
    @IBOutlet weak var tfUrl: UITextField!
    @IBOutlet weak var vwLink: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    var selectedDate : String = ""
    var selctdColCellIndex = 0
   
    @IBOutlet weak var vwTransparent: UIView!
    @IBOutlet weak var webVw: UIWebView!
    
    var arrPerkList = [Perks]()
    var arrImage: NSMutableArray = NSMutableArray()
    var arrCollaborators = [User]()
    
    var selectedId: NSMutableArray = NSMutableArray()
    var selectedName: NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var tblvwCampaign: UITableView!
    var imagePickerController = UIImagePickerController()
    
    let screenSize = UIScreen.main.bounds
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    
    var campaignId: Int = 0
    
    var categoryName = ""
    var categoryType = ""
    
    var campName = ""
    var campTagName = ""
    var campYoutubeURL = ""
    var campDesc = ""
    var campTopic = ""
    var campExpDate = ""
    var campLocation = ""
    var campAskPrice = ""
    
    var fromCreateCampaign: Bool = false
    
    var selectedTopic: SubTopicList!
    var countryID = String()
    var stateID = String()
    var cityID = String()
    var countryName = String()
    var stateName = String()
    var cityName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cellRegistration()
        
        vwUrl.layer.masksToBounds = true
        vwUrl.layer.cornerRadius = 5
        vwUrl.layer.borderWidth = 1
        vwUrl.layer.borderColor = UIColor.white.cgColor
        
        vwLink.layer.masksToBounds = true
        vwLink.layer.cornerRadius = 2
        vwLink.layer.borderWidth = 1
        vwLink.layer.borderColor = UIColor.white.cgColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        vwTransparent.addGestureRecognizer(tap)
    }
    
    func getStateDetails(stateId: String, stateName: String)
    {
        self.stateID = stateId
        self.stateName = stateName
        self.cityName = ""
        self.tblvwCampaign.reloadData()
    }
    
    func cityDetails(cityId: String, cityName: String)
    {
        self.cityID = cityId
        self.cityName = cityName
        self.tblvwCampaign.reloadData()
    }
    
    func getCountryDetails(countryId: String, countryName: String, countrySortname: String)
    {
        self.countryID = countryId
        self.countryName = countryName
        self.cityName = ""
        self.stateName = ""
        self.tblvwCampaign.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblPageTitle.text = "Create Campaign".localized
        vwMain.isHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    // MARK: cellRegistration
    func cellRegistration()   {
        
        self.tblvwCampaign.register(UINib(nibName: "AddImageWithoutImageListCell", bundle: Bundle.main), forCellReuseIdentifier: "AddImageWithoutImageListCell")
        
        self.tblvwCampaign.register(UINib(nibName: "AddImageCell", bundle: Bundle.main), forCellReuseIdentifier: "AddImageCell")
        
        self.tblvwCampaign.register(UINib(nibName: "CampaignNameTableCell", bundle: Bundle.main), forCellReuseIdentifier: "CampaignNameTableCell")
        
        self.tblvwCampaign.register(UINib(nibName: "CampaignTagLineCell", bundle: Bundle.main), forCellReuseIdentifier: "CampaignTagLineCell")
        
        self.tblvwCampaign.register(UINib(nibName: "CampaignYoutubeURLCell", bundle: Bundle.main), forCellReuseIdentifier: "CampaignYoutubeURLCell")
        
        
        self.tblvwCampaign.register(UINib(nibName: "DescriptionCell", bundle: Bundle.main), forCellReuseIdentifier: "DescriptionCell")
        
        self.tblvwCampaign.register(UINib(nibName: "TopicCell", bundle: Bundle.main), forCellReuseIdentifier: "TopicCell")
        
        self.tblvwCampaign.register(UINib(nibName: "ExpiryDateCell", bundle: Bundle.main), forCellReuseIdentifier: "ExpiryDateCell")
        
        self.tblvwCampaign.register(UINib(nibName: "LocationCell", bundle: Bundle.main), forCellReuseIdentifier: "LocationCell")
        
        self.tblvwCampaign.register(UINib(nibName: "AskingPriceCell", bundle: Bundle.main), forCellReuseIdentifier: "AskingPriceCell")
        
        self.tblvwCampaign.register(UINib(nibName: "AddPerkCell", bundle: Bundle.main), forCellReuseIdentifier: "AddPerkCell")
        
        self.tblvwCampaign.register(UINib(nibName: "ParkDetailsCell", bundle: Bundle.main), forCellReuseIdentifier: "ParkDetailsCell")
        
        self.tblvwCampaign.register(UINib(nibName: "AddNewPerkCell", bundle: Bundle.main), forCellReuseIdentifier: "AddNewPerkCell")
        
        self.tblvwCampaign.register(UINib(nibName: "CollaboratorContainerCell", bundle: Bundle.main), forCellReuseIdentifier: "CollaboratorContainerCell")
        
        self.tblvwCampaign.register(UINib(nibName: "NextButtonCell", bundle: Bundle.main), forCellReuseIdentifier: "NextButtonCell")
        
        self.tblvwCampaign.delegate=self
        self.tblvwCampaign.dataSource=self
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNextPressed(_ sender: Any)
    {
        self.view.endEditing(true)
        if arrImage.count == 0
        {
            Alert.disPlayAlertMessage(titleMessage: "Campaign Image or Video", alertMsg: "Please put atlease one image or video!")
            return
        }
        
        if campName.isEmpty
        {
            Alert.disPlayAlertMessage(titleMessage: "Campaign Name", alertMsg: "Please enter campaign name!")
            return
        }
        
//        if campTagName.isEmpty
//        {
//            Alert.disPlayAlertMessage(titleMessage: "Campaign Tag Name", alertMsg: "Please enter campaign tag name!")
//            return
//        }
        
        if campDesc.isEmpty
        {
            Alert.disPlayAlertMessage(titleMessage: "Campaign Description", alertMsg: "Please enter campaign description!")
            return
        }
        
        if campTopic.isEmpty
        {
            Alert.disPlayAlertMessage(titleMessage: "Campaign Topic", alertMsg: "Please enter campaign topic!")
            return
        }
        
        if selectedDate.isEmpty
        {
            Alert.disPlayAlertMessage(titleMessage: "Campaign Expire Date", alertMsg: "Please enter campaign expire date!")
            return
        }
        
//        if campLocation.isEmpty
//        {
//            Alert.disPlayAlertMessage(titleMessage: "Campaign Location", alertMsg: "Please enter campaign location!")
//            return
//        }
        if countryName == ""
        {
            Alert.disPlayAlertMessage(titleMessage: "Campaign Country", alertMsg: "Please enter campaign country!")
            return
        }
        
        if stateName == ""
        {
            Alert.disPlayAlertMessage(titleMessage: "Campaign State", alertMsg: "Please enter campaign state!")
            return
        }
        
        if cityName == ""
        {
            Alert.disPlayAlertMessage(titleMessage: "Campaign City", alertMsg: "Please enter campaign city!")
            return
        }
        
        if campAskPrice.isEmpty
        {
            Alert.disPlayAlertMessage(titleMessage: "Campaign Price", alertMsg: "Please enter campaign price!")
            return
        }
        
//        if arrPerkList.count == 0
//        {
//            Alert.disPlayAlertMessage(titleMessage: "Campaign Perk", alertMsg: "Please enter atleast one perk!")
//            return
//        }
        
//        if arrCollaborators.count == 0
//        {
//            Alert.disPlayAlertMessage(titleMessage: "Campaign Collaborator", alertMsg: "Please select atleast one collaborator!")
//            return
//        }
 
        //let arrColabDet = self.convertCollaborator(strCampname: campName)
        let arrCampaignImages = self.convertToImageArr()
        //let dictDetails = CampaignDetails.init(first_name: "", last_name: "", email: "", profile_img: "", cat_type: self.categoryType, campaign_type: "DOLLAR", campaign_name: campName, description: campDesc, goal_amount: campAskPrice.toInt(defaultValue: 0), location: campLocation, tag_line: campTagName, cat_name: self.categoryName, image: arrImgToSend, collaborators_user: arrColabDet, perks: arrPerkList, bloodgroup: "", organ: "", camp_media: "", date: campExpDate)
        
        var topicId = ""
        var topicActive = true
        var topicName = ""
        var topicParentId = ""
        if let topic = selectedTopic
        {
            topicId = String(format:"%d",topic.id)
            topicActive = topic.active
            topicName = topic.name
            topicParentId = String(format:"%d",topic.parentId)
        }
        
        let userDefaults = UserDefaults.standard
        let userId = UserDefaults.standard.object(forKey: "userId") as? Int ?? 0
        let username = userDefaults.object(forKey: "username") as? String ?? ""
        //let userId = userDefaults.object(forKey: "userId") as? Int ?? 0
        let FName = userDefaults.object(forKey: "FName") as? String ?? ""
        let LName = userDefaults.object(forKey: "LName") as? String ?? ""
        let email = userDefaults.object(forKey: "email") as? String ?? ""
        let Gender = userDefaults.object(forKey: "Gender") as? String ?? ""
        let phoneNumber = userDefaults.object(forKey: "phoneNumber") as? String ?? ""
        let birthDate = userDefaults.object(forKey: "birthDate") as? String ?? ""
        let address = userDefaults.object(forKey: "address") as? String ?? ""
        let country = userDefaults.object(forKey: "country") as? String ?? ""
        let city = userDefaults.object(forKey: "city") as? String ?? ""
        let state = userDefaults.object(forKey: "state") as? String ?? ""
        let zipCode = userDefaults.object(forKey: "zipCode") as? String ?? ""

        
        SVProgressHUD.show()
        //let prmList:[String: Any] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT") as TimeZone!
        let dataDate = dateFormatter.date(from: selectedDate )!
        let finalDate = Int((dataDate.timeIntervalSince1970) * 1000)
        let strDate : String = String(finalDate)
        
        var prmList:[String: Any] = ["campaignName":campName, "campaignDescription":campDesc, "youtubeLink": campYoutubeURL, "goalAmount": campAskPrice, "expirationDate":strDate, "campaignType":"1","topic.id": topicId, "topic.active": topicActive, "topic.name": topicName, "topic.parentId": topicParentId, "user.id": String(format:"%d",userId), "user.firstname": FName, "user.lastname": LName, "user.email": email,"user.phoneNumber":phoneNumber,"user.gender":Gender,"user.birthDate":birthDate,"campaign.countryId":Int(countryID)!,"campaign.cityId":Int(cityID)! , "user.address.id" : 123 , "user.address.address" : "abc" , "user.address.city" : self.cityName , "user.address.state" : self.stateName , "user.address.country" : self.countryName]
        
        //,"user.address.address":address,"user.address.city":city,"user.address.state":state,"user.address.country":country,"user.address.zipCode":zipCode
        
        let arrPerkImages = NSMutableArray()
        for i in 0..<self.arrPerkList.count
        {
            let perk = self.arrPerkList[i]
            
            var key = String(format:"perks[%d].title",i)
            var value = perk.title
            prmList[key] = value
            
            key = String(format:"perks[%d].description",i)
            value = perk.description
            prmList[key] = value
            
            key = String(format:"perks[%d].price",i)
            value = perk.price
            prmList[key] = value
            
            key = String(format:"perks[%d].estimatedDeliveryDate",i)
            value = perk.date
            prmList[key] = value
            
            key = String(format:"perks[%d].items",i)
            value = String(format:"[%@]", perk.items.componentsJoined(by: ","))
            prmList[key] = value
            
            let filePath = self.saveImageToDocumentDir(image: perk.image)
            arrPerkImages.add(filePath)
        }
        for i in 0..<self.arrCollaborators.count
        {
            let collaborator = self.arrCollaborators[i]
            let id = String(format:"%d",collaborator.id)
            var key = String(format:"collaborators[%d]user.id",i)
            var value = id
            prmList[key] = value
            
            key = String(format:"collaborators[%d]user.firstname",i)
            value = collaborator.firstname!
            prmList[key] = value
            
            key = String(format:"collaborators[%d]user.lastname",i)
            value = collaborator.lastname!
            prmList[key] = value
            
            key = String(format:"collaborators[%d]user.email",i)
            value = collaborator.email!
            prmList[key] = value
            
            key = String(format:"collaborators[%d]user.phoneNumber",i)
            value = collaborator.phoneNumber!
            prmList[key] = value
            
            key = String(format:"collaborators[%d]user.gender",i)
            value = collaborator.gender!
            prmList[key] = value
            
            key = String(format:"collaborators[%d]user.birthDate",i)
            value = collaborator.birthDate!
            prmList[key] = value
            
        }
        
        prmList["campaignFiles"] = arrCampaignImages
        prmList["perkFiles"] = arrPerkImages
        
        
        if fromCreateCampaign
        {
            let apiName = "/campaign/\(campaignId)/update"
            let request = MakePutRequest.init(parameterList: prmList, APIName: apiName)
            RequestExecutor.uploadRequest(request, completion:{ (error: Error?, getMyData: CampaignResponse?) in
                self.handleData(error: error, getMyData: getMyData)
            })
        }
        else
        {
            let apiName = "/campaign/add"
            let request = MakePostRequest.init(parameterList: prmList, APIName: apiName)
            RequestExecutor.uploadRequest(request, completion:{ (error: Error?, getMyData: CampaignResponse?) in
                self.handleData(error: error, getMyData: getMyData)
            })
        }
        /*let moveViewController = ConfirmationController()
        moveViewController.dicCampaignDetails = dictDetails
        self.navigationController?.pushViewController(moveViewController, animated: true)*/
     }
    
    func handleData(error: Error?, getMyData: CampaignResponse?)
    {
        SVProgressHUD.dismiss()
        if let response = getMyData
        {
            if let campDetails = response.data
            {
                let moveViewController = ConfirmationController()
                self.campaignId = campDetails.id
                moveViewController.campaignId = campDetails.id//String(format:"%d",campDetails.id)
                moveViewController.fromHomeOrUpload = "Upload"
                self.navigationController?.pushViewController(moveViewController, animated: true)
                self.fromCreateCampaign = true
            }
            else
            {
                let message = response.message ?? "Some error occured, please try again"
                Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: message)
            }
            self.view.endEditing(true)
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
    }
    
    func convertCollaborator(strCampname: String) -> [CollaboratorDetails]
    {
        var arrColab = [CollaboratorDetails]()
        for colab in arrCollaborators
        {
            let id: Int = colab.id
            let first_name: String? = colab.firstname ?? ""
            let last_name: String? = colab.lastname ?? ""
            let profile_img: String = colab.profileImg ?? ""
            let email: String? = colab.email ?? ""
            let user_name =  first_name! + " " + last_name!
            
            let colabDet = CollaboratorDetails(id: id, email: email!, user_img: profile_img, user_name: user_name, campaign_name: strCampname)
            arrColab.append(colabDet)
        }
        return arrColab
    }
    
    func convertToImageArr() -> NSMutableArray
    {
        let arrImg = NSMutableArray()
        for i in 0..<self.arrImage.count
        {
            let dict: NSDictionary = (arrImage[i] as? NSDictionary)!
            if let urlImg: URL = dict["url"] as? URL
            {
                //let url = NSURL.fileURL(withPath: urlImg)
                arrImg.add(urlImg)
            }
        }
        return arrImg
    }
    
    // MARK: TableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let count = arrPerkList.count
        return count + 15
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row==0
        {
            if self.arrImage.count == 0
            {
                return 159
            }
            else
            {
                return 298
            }
        }
        else if indexPath.row==1
        {
            return 74
        }
        else if indexPath.row==2
        {
            return 83
        }
        else if indexPath.row==3
        {
            return 83 //140
        }
        else if indexPath.row==4
        {
            return 83
        }
        else if indexPath.row==5
        {
            return 83
        }
        else if indexPath.row==6
        {
            return 83
        }
        else if indexPath.row==7
        {
            return 83
        }
        else if indexPath.row==8
        {
            return 83
        }
        else if indexPath.row==9
        {
            return 83
        }
        else if indexPath.row==10
        {
            return 83
        }
        else if indexPath.row==11
        {
            return 44
        }
        if indexPath.row > 11 && arrPerkList.count > 0
        {
            if indexPath.row <= arrPerkList.count + 11
            {
                return 220
            }
            else if indexPath.row == arrPerkList.count + 12
            {
                return 165
            }
            else if indexPath.row == arrPerkList.count + 13
            {
                return 140
            }
            else
            {
                return 44
            }
        }
        else
        {
            if indexPath.row == 12
            {
                return 165
            }
            else if indexPath.row == 13
            {
                return 140
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
            if self.arrImage.count == 0
            {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "AddImageWithoutImageListCell", for: indexPath) as! AddImageWithoutImageListCell
                cell.gallaryBtn?.addTarget(self, action: #selector(self.gallaryClick), for: UIControlEvents.touchUpInside)
                cell.gallaryBtn.tag = indexPath.row
                
                cell.videoBtn?.addTarget(self, action: #selector(self.VideoClick), for: UIControlEvents.touchUpInside)
                cell.videoBtn.tag = indexPath.row
                
                cell.selectionStyle = .none
                return cell
            }
            else
            {
                
                let  cell = tableView.dequeueReusableCell(withIdentifier: "AddImageCell", for: indexPath) as! AddImageCell
                cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
                cell.gallaryBtn?.addTarget(self, action: #selector(self.gallaryClick), for: UIControlEvents.touchUpInside)
                cell.gallaryBtn.tag = indexPath.row
                
                cell.videoBtn?.addTarget(self, action: #selector(self.VideoClick), for: UIControlEvents.touchUpInside)
                cell.videoBtn.tag = indexPath.row
                
                if self.arrImage.count > 0
                {
                    let details: NSDictionary = (arrImage[selctdColCellIndex] as? NSDictionary)!
                    let type: String = (details["type"] as? String)!
                    if type == "youtube"
                    {
                        cell.vwPrvwPlay.isHidden = false
                        cell.btnPrvwPlay.isHidden = false
                        cell.imgvwPrvwPlay.image = UIImage(named: "ytPlay")
                        cell.btnPrvwPlay?.addTarget(self, action: #selector(self.playVideoORshowImage(sender:)), for: UIControlEvents.touchUpInside)
                        cell.btnPrvwPlay.tag = selctdColCellIndex
                        let getUrl: String = (details["url"] as? String)!
                        let youtubeVideoID = (extractYoutubeIdFromLink(link: getUrl))!
                        let downloadURL = NSURL(string: "https://img.youtube.com/vi/\(youtubeVideoID)/default.jpg")!
                        cell.imgvwPreview.sd_setImage(with: downloadURL as URL, placeholderImage: UIImage(named: No_Image))
                    }
                    else if type == "video"
                    {
                        cell.vwPrvwPlay.isHidden = false
                        cell.btnPrvwPlay.isHidden = false
                        cell.imgvwPrvwPlay.image = UIImage(named: "play")
                        cell.btnPrvwPlay?.addTarget(self, action: #selector(self.playVideoORshowImage(sender:)), for: UIControlEvents.touchUpInside)
                        cell.btnPrvwPlay.tag = selctdColCellIndex
                        //let getUrl: String = (details["url"] as? String)!
                        //let downloadURL = NSURL(string: getUrl)!
                        //cell.imgvwPreview.sd_setImage(with: downloadURL as URL, placeholderImage: UIImage(named: No_Image))
                        if let getUrl = details["url"] as? URL
                        {
                            DispatchQueue.global().async {
                                let asset = AVAsset(url: getUrl as URL)
                                let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
                                assetImgGenerate.appliesPreferredTrackTransform = true
                                let time = CMTimeMake(1, 2)
                                let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                                if img != nil {
                                    let frameImg  = UIImage(cgImage: img!)
                                    DispatchQueue.main.async(execute: {
                                        cell.imgvwPreview.image = frameImg
                                    })
                                }
                            }
                        }
                        
                        
                    }
                    else if type == "image"
                    {
                        cell.vwPrvwPlay.isHidden = true
                        cell.btnPrvwPlay.isHidden = false
                        if let getUrl = details["url"] as? URL
                        {
                            cell.imgvwPreview.sd_setImage(with: getUrl as URL, placeholderImage: UIImage(named: No_Image))
                        }
                        
                        cell.btnPrvwPlay?.addTarget(self, action: #selector(self.playVideoORshowImage(sender:)), for: UIControlEvents.touchUpInside)
                        cell.btnPrvwPlay.tag = selctdColCellIndex
                    }
                }
                cell.selectionStyle = .none
                return cell
            }
        }
        else if indexPath.row==1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CampaignNameTableCell") as! CampaignNameTableCell
            
            cell.lblTitle.text = "Campaign Name".localized
            cell.tfCampaignName.tag = indexPath.row
            cell.tfCampaignName.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CampaignTagLineCell") as! CampaignTagLineCell
            cell.lblTitle.text = "Campaign Tag Line".localized
            cell.tfCampaignTagLine.tag = indexPath.row
            cell.tfCampaignTagLine.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        
        else if indexPath.row==3
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell") as! DescriptionCell
            cell.lblTitle.text = "Description".localized
            cell.tvDescription.tag = indexPath.row
            cell.tvDescription.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==4
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell") as! TopicCell
            cell.lblTitle.text = "Topic".localized
            cell.btnTopic?.addTarget(self, action: #selector(self.topicPressed), for: UIControlEvents.touchUpInside)
            cell.btnTopic.tag = indexPath.row
            cell.tfTopic.tag = indexPath.row
            cell.tfTopic.delegate = self
            cell.tfTopic.text = campTopic
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==5
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExpiryDateCell") as! ExpiryDateCell
            cell.lblTitle.text = "End Date".localized
            let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = .date
            datePickerView.minimumDate = Date()
            if selectedDate.isEmpty
            {
                datePickerView.date = Date()
            }
            else
            {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = dateOnlyFormat
                let date = dateFormatter.date(from: selectedDate)
                datePickerView.date = date ?? Date()
            }
            
            datePickerView.addTarget(self, action: #selector(expireDateChanged(_:)), for: .valueChanged)
            cell.tfExpiryDate.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(dateDoneButtonClicked(_:)))
            
            cell.tfExpiryDate.inputView = datePickerView
            cell.tfExpiryDate.text = selectedDate
            cell.tfExpiryDate.tag = indexPath.row
            cell.tfExpiryDate.delegate = self
            cell.selectionStyle = .none
            return cell
        }
//        else if indexPath.row==6
//        {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
//            cell.lblTitle.text = "Location".localized
//            cell.tfLocation.tag = indexPath.row
//            cell.tfLocation.delegate = self
//            cell.tfLocation.text = campLocation
//            cell.btnLocation?.addTarget(self, action: #selector(self.locationPressed), for: UIControlEvents.touchUpInside)
//            cell.btnLocation.tag = indexPath.row
//
//            cell.selectionStyle = .none
//            return cell
//        }
            //Country
        else if indexPath.row==6
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
            cell.lblTitle.text = "Country".localized
            cell.tfLocation.tag = indexPath.row
            cell.tfLocation.delegate = self
            //cell.tfLocation.text = campLocation
            cell.tfLocation.text = self.countryName
            cell.btnLocation.tag = indexPath.row
            //cell.btnLocation?.addTarget(self, action: #selector(self.locationPressed), for: UIControlEvents.touchUpInside)
            cell.btnLocation.addTarget(self, action: #selector(self.locationPressed(sender:)), for: UIControlEvents.touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
            //State
        else if indexPath.row==7
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
            cell.lblTitle.text = "State".localized
            cell.tfLocation.tag = indexPath.row
            cell.tfLocation.delegate = self
            //cell.tfLocation.text = campLocation
            cell.tfLocation.text = self.stateName
            cell.btnLocation.tag = indexPath.row
            //cell.btnLocation?.addTarget(self, action: #selector(self.statePressed), for: UIControlEvents.touchUpInside)
            cell.btnLocation.addTarget(self, action: #selector(self.statePressed(sender:)), for: UIControlEvents.touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
            //City
        else if indexPath.row==8
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
            cell.lblTitle.text = "City".localized
            cell.tfLocation.tag = indexPath.row
            cell.tfLocation.delegate = self
            //cell.tfLocation.text = campLocation
            cell.tfLocation.text = self.cityName
            cell.btnLocation.tag = indexPath.row
            //cell.btnLocation?.addTarget(self, action:#selector(self.cityPressed), for: UIControlEvents.touchUpInside)
            cell.btnLocation.addTarget(self, action: #selector(self.cityPressed(sender:)), for: UIControlEvents.touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==9
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CampaignYoutubeURLCell") as! CampaignYoutubeURLCell
            cell.lblTitle.text = "YouTube Link".localized
            cell.tfYoutubeURL.tag = indexPath.row
            cell.tfYoutubeURL.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==10
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AskingPriceCell") as! AskingPriceCell
            cell.lblTitle.text = "Asking".localized
            cell.tfPrice.tag = indexPath.row
            cell.tfPrice.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==11
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddPerkCell") as! AddPerkCell
            cell.lblTitle.text = "Add Perks".localized
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row > 11 && arrPerkList.count > 0
        {
            print("indexPath.row", indexPath.row)
            print("arrPerkList.count", arrPerkList.count)
        
            if indexPath.row <= arrPerkList.count + 11
            {
                let details = arrPerkList[indexPath.row-12]
                let  cell = tableView.dequeueReusableCell(withIdentifier: "ParkDetailsCell", for: indexPath) as! ParkDetailsCell
                let title = details.title
                let price = details.price
                let description = details.description
                cell.lblTitle.text = title
                cell.lblPrice.text = String(format: "$%@", price!)
                cell.tvDescription.text = description
                cell.lbldate.text = details.date
                cell.selectionStyle = .none
                return cell
            }
            else if indexPath.row == arrPerkList.count + 12
            {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewPerkCell") as! AddNewPerkCell
                cell.lblTitle.text = "Add New Perk".localized
                cell.btnAddNewPark?.addTarget(self, action: #selector(self.AddPark), for: UIControlEvents.touchUpInside)
                cell.btnAddNewPark.tag = indexPath.row
                cell.selectionStyle = .none
                return cell
            }
            else if indexPath.row == arrPerkList.count + 13
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CollaboratorContainerCell") as! CollaboratorContainerCell
                cell.lblTitle.text = "Add Collaborators".localized
                cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
                cell.btnAddCollaborator.layer.masksToBounds = true
                cell.btnAddCollaborator.layer.cornerRadius = 10
                cell.btnAddCollaborator?.addTarget(self, action: #selector(self.AddCollaborator), for: UIControlEvents.touchUpInside)
                cell.btnAddCollaborator.tag = indexPath.row
                cell.selectionStyle = .none
                
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NextButtonCell") as! NextButtonCell
                cell.btnNext.setTitle("Next".localized, for: .normal)
                cell.btnNext?.addTarget(self, action: #selector(self.btnNextPressed(_:)), for: UIControlEvents.touchUpInside)
                cell.selectionStyle = .none
                return cell
            }
        }
        else
        {
            if indexPath.row == 12
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewPerkCell") as! AddNewPerkCell
                cell.lblTitle.text = "Add New Perk".localized
                cell.btnAddNewPark?.addTarget(self, action: #selector(self.AddPark), for: UIControlEvents.touchUpInside)
                cell.btnAddNewPark.tag = indexPath.row
                cell.selectionStyle = .none
                return cell
            }
            else if indexPath.row == 13
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CollaboratorContainerCell") as! CollaboratorContainerCell
                cell.lblTitle.text = "Add Collaborators".localized
                cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
                cell.btnAddCollaborator.layer.masksToBounds = true
                cell.btnAddCollaborator.layer.cornerRadius = 10
                cell.btnAddCollaborator?.addTarget(self, action: #selector(self.AddCollaborator), for: UIControlEvents.touchUpInside)
                cell.btnAddCollaborator.tag = indexPath.row
                cell.selectionStyle = .none
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NextButtonCell") as! NextButtonCell
                cell.btnNext.setTitle("Next".localized, for: .normal)
                cell.btnNext?.addTarget(self, action: #selector(self.btnNextPressed(_:)), for: UIControlEvents.touchUpInside)
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView.tag == 0
        {
            
        }
        else
        {
        }
        
    }
    
    // MARK: - Action
    
    @objc func expireDateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateOnlyFormat
        selectedDate = dateFormatter.string(from: sender.date)
        
        let indexPath = NSIndexPath(row: 5, section: 0)
        self.tblvwCampaign.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
    }
    
    @objc func dateDoneButtonClicked(_ sender: UITextField) {
        //your code when clicked on done
        if selectedDate.isEmpty
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateOnlyFormat
            selectedDate = dateFormatter.string(from: Date())
        }
        self.tblvwCampaign.reloadData()

    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        vwMain.isHidden = true
    }
    
    @IBAction func btnCancelPressed(_ sender: Any)
    {
        vwMain.isHidden = true
    }
    @IBAction func btnDonePressed(_ sender: Any)
    {
        
        if tfUrl.text != ""
        {
            self.vwMain.isHidden = true
            let dicDetails: NSMutableDictionary = NSMutableDictionary()
            dicDetails.setValue(tfUrl.text, forKey: "url")
            dicDetails.setValue("youtube", forKey: "type")
            arrImage.add(dicDetails)
            self.arrImage = self.reArrengeArray(arrImges: self.arrImage)
            DispatchQueue.main.async {
                //let indexPath = IndexPath(item: 0, section: 0)
                //self.tblvwCampaign.reloadRows(at: [indexPath], with: .fade)
                self.tblvwCampaign.reloadData()
                let collectionView = self.tblvwCampaign.viewWithTag(1000) as! UICollectionView
                collectionView.reloadData()
            }
        }
        else
        {
            Alert.disPlayAlertMessage(titleMessage: "Sorry!", alertMsg: "Please add URL.")
        }
        
    }
    
    @objc func gallaryClick(sender: UIButton!)
    {
        attachmentActionSheetForImage()
    }
    
    @objc func locationPressed(sender: UIButton!)
    {
        if sender.tag == 6
        {
            let moveViewController = CountryListController()
            self.present(moveViewController, animated: true, completion: nil)
            moveViewController.delegate = self
        }
    }
    
    @objc func statePressed(sender: UIButton!)
    {
        if sender.tag == 7 && self.countryID != ""
        {
            let viewController = StateController()
            viewController.delegate = self
            viewController.countryId = self.countryID
            let navigationController = UINavigationController(rootViewController: viewController)
            present(navigationController, animated: true, completion: nil)
        }
    }
    
    @objc func cityPressed(sender: UIButton!)
    {
        if sender.tag == 8 && self.stateID != ""
        {
            let viewController = CityController()
            viewController.delegate = self
            viewController.stateId = self.stateID
            let navigationController = UINavigationController(rootViewController: viewController)
            present(navigationController, animated: true, completion: nil)
        }
    }
    
    @objc func topicPressed(sender: UIButton!)
    {
        self.getTopicList(topicId: 0)
    }
    
    
    @objc func AddCollaborator(sender: UIButton!) {
        vwMain.isHidden = true
        vwUrl.isHidden = true
        
        let moveViewController = CollaboratorListController()
        moveViewController.delegate = self
        moveViewController.selectedCollaborators = arrCollaborators
        self.navigationController?.pushViewController(moveViewController, animated: true)
        
        
    }

    @objc func AddPark(sender: UIButton!) {
        let moveViewController = AddParkController()
        moveViewController.delegate = self
        self.navigationController?.pushViewController(moveViewController, animated: true)
    }
    @objc func VideoClick(sender: UIButton!) {
        
        self.attachmentActionSheet()
        //getVideoOption()
        
        //startCameraFromViewController(viewController: self, withDelegate: self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        
    }
    
    private func getVideoOption()
    {
        let settingsActionSheet: UIAlertController = UIAlertController(title:nil, message:nil, preferredStyle:UIAlertControllerStyle.actionSheet)
        settingsActionSheet.addAction(UIAlertAction(title:"Video from YouTube", style:UIAlertActionStyle.default, handler:{ action in
            self.vwMain.isHidden = false
            self.vwUrl.isHidden = false
            self.tfUrl.text = ""
        }))
        settingsActionSheet.addAction(UIAlertAction(title:"Video from Phone", style:UIAlertActionStyle.default, handler:{ action in
            self.attachmentActionSheet()
        }))
        settingsActionSheet.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.cancel, handler:nil))
        present(settingsActionSheet, animated:true, completion:nil)
    }
    
    private func attachmentActionSheetForImage()
    {
        /*let settingsActionSheet: UIAlertController = UIAlertController(title:nil, message:nil, preferredStyle:UIAlertControllerStyle.actionSheet)
        settingsActionSheet.addAction(UIAlertAction(title:"Take Photo from Camera", style:UIAlertActionStyle.default, handler:{ action in
            self.showImagePickerForImage(type: "takePhoto")
        }))
        settingsActionSheet.addAction(UIAlertAction(title:"Choose Photo from Album", style:UIAlertActionStyle.default, handler:{ action in
            self.showImagePickerForImage(type: "choosePhoto")
        }))
        settingsActionSheet.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.cancel, handler:nil))
        present(settingsActionSheet, animated:true, completion:nil)*/
        
        self.showImagePickerForImage(type: "choosePhoto")
    }
    
    private func attachmentActionSheet()
    {
        /*let settingsActionSheet: UIAlertController = UIAlertController(title:nil, message:nil, preferredStyle:UIAlertControllerStyle.actionSheet)
        settingsActionSheet.addAction(UIAlertAction(title:"Record video", style:UIAlertActionStyle.default, handler:{ action in
            self.showImagePicker(type: "RecordVideo")
        }))
        settingsActionSheet.addAction(UIAlertAction(title:"Choose video from Album", style:UIAlertActionStyle.default, handler:{ action in
            self.showImagePicker(type: "chooseVideo")
        }))
        settingsActionSheet.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.cancel, handler:nil))
        present(settingsActionSheet, animated:true, completion:nil)*/
        
        self.showImagePicker(type: "chooseVideo")
    }
    
    func showImagePicker(type:String)
    {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        /*if type == "RecordVideo"
        {
            imagePickerController.mediaTypes = [kUTTypeMovie as NSString as String]
            //imagePickerController.cameraCaptureMode = .photo
            if (UIImagePickerController.isSourceTypeAvailable(.camera))
            {
                imagePickerController.sourceType = .camera
            }
            else
            {
                let alertVC = UIAlertController(
                    title: "No Camera",
                    message: "Sorry, this device has no camera",
                    preferredStyle: .alert)
                let okAction = UIAlertAction(
                    title: "OK",
                    style:.default,
                    handler: nil)
                alertVC.addAction(okAction)
                present(
                    alertVC,
                    animated: true,
                    completion: nil)
            }
        }
        else
        {
            imagePickerController.sourceType = .photoLibrary
        }*/
        
        imagePickerController.mediaTypes = [kUTTypeMovie as String]
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    func showImagePickerForImage(type:String)
    {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        /*if type == "takePhoto"
        {
            imagePickerController.mediaTypes = [kUTTypeImage as NSString as String]
            //imagePickerController.cameraCaptureMode = .photo
            if (UIImagePickerController.isSourceTypeAvailable(.camera))
            {
                imagePickerController.sourceType = .camera
            }
            else
            {
                let alertVC = UIAlertController(
                    title: "No Camera",
                    message: "Sorry, this device has no camera",
                    preferredStyle: .alert)
                let okAction = UIAlertAction(
                    title: "OK",
                    style:.default,
                    handler: nil)
                alertVC.addAction(okAction)
                present(
                    alertVC,
                    animated: true,
                    completion: nil)
            }
        }
        else
        {
            imagePickerController.sourceType = .photoLibrary
        }*/
        imagePickerController.mediaTypes = [kUTTypeImage as String]
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    /*
    func startCameraFromViewController(viewController: UIViewController, withDelegate delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            return false
        }
        
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.mediaTypes = [kUTTypeMovie as NSString as String]
        cameraController.allowsEditing = false
        cameraController.delegate = delegate
        
        present(cameraController, animated: true, completion: nil)
        return true
    }
    */
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setImageAndVideo(file: Any)
    {
        var dictMedia:[String: Any] = ["type":"","url":""]
        if let value = file as? UIImage
        {
            let filePath = self.saveImageToDocumentDir(image: value)
            dictMedia["type"] = "image"
            dictMedia["url"] = filePath
        }
        
        if let value = file as? NSURL
        {
            dictMedia["type"] = "video"
            dictMedia["url"] = value
        }
        
        self.arrImage.add(dictMedia)
        self.arrImage = self.reArrengeArray(arrImges: self.arrImage)
        DispatchQueue.main.async {
            //let indexPath = IndexPath(item: 0, section: 0)
            //self.tblvwCampaign.reloadRows(at: [indexPath], with: .fade)
            self.tblvwCampaign.reloadData()
            if let collectionView = self.tblvwCampaign.viewWithTag(1000) as? UICollectionView
            {
                collectionView.reloadData()
            }
        }
    }
    
    func saveImageToDocumentDir(image: UIImage) -> URL
    {
        var returnFilePath: URL!
        // get the documents directory url
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // choose a name for your image
        let fileName = Validation.generateFileName(strExtention: "jpg")
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        // get your UIImage jpeg data representation and check if the destination file url already exists
        if let data = UIImageJPEGRepresentation(image, 7.0),
            !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                // writes the image data to disk
                try data.write(to: fileURL)
                print("file saved")
                returnFilePath = fileURL
            } catch {
                print("error saving file:", error)
            }
            
            return returnFilePath
        }
        return returnFilePath
    }
    
    
    
    
    // MARK: - Service Call
    
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
                    let moveViewController = TopicListController()
                    moveViewController.delegate = self
                    moveViewController.subTopic = dictTopicList.subTopic
                    moveViewController.fromHome = "false"
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
    
    
    
    func Upload(file: Any)
    {
        SVProgressHUD.show()
        let prmList:[String: Any] = ["inputFile": file]
        let request = MakePostRequest.init(parameterList: prmList, APIName: "/campaign/uploadfile")
        RequestExecutor.uploadRequest(request, completion:{ (error: Error?, getMyData: FileUploadResponse?) in
            SVProgressHUD.dismiss()
            if getMyData != nil
            {
                let contentURL = getMyData?.url
                let lastPathContent = (contentURL! as NSString).pathExtension
                var dictMedia:[String: Any] = ["type":"","url":""]
                if lastPathContent.uppercased() == "JPG" || lastPathContent.uppercased() == "JPEG" || lastPathContent.uppercased() == "PNG"
                {
                    dictMedia["type"] = "image"
                    dictMedia["url"] = contentURL
                }
                else
                {
                    dictMedia["type"] = "video"
                    dictMedia["url"] = contentURL
                }
                self.arrImage.add(dictMedia)
                self.arrImage = self.reArrengeArray(arrImges: self.arrImage)
                DispatchQueue.main.async {
                    //let indexPath = IndexPath(item: 0, section: 0)
                    //self.tblvwCampaign.reloadRows(at: [indexPath], with: .fade)
                    self.tblvwCampaign.reloadData()
                    let collectionView = self.tblvwCampaign.viewWithTag(1000) as! UICollectionView
                    collectionView.reloadData()
                }
                
                
//                self.tblvwCampaign.reloadDataWithCompletion() {
//                    // reloadData is guaranteed to have completed
//
//                }
                
                
                
                
                //let username: String = getMyData!.Name!
                //let role: String = getMyData!.Role!
                
                self.view.endEditing(true)
                //_=self.navigationController?.popToRootViewController(animated: true)
                //Alert.disPlayAlertMessage(titleMessage: "Login Success", alertMsg: "Thank you \(username), for logging in as \(role)")
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
    
    func reArrengeArray(arrImges: NSMutableArray) -> NSMutableArray
    {
        let imageindexSet = NSMutableIndexSet()
        let videoindexSet = NSMutableIndexSet()
        let youtubeindexSet = NSMutableIndexSet()
        for i in (0..<arrImges.count)
        {
            if let dict = arrImges[i] as? [String: Any], let type = dict["type"] as? String, type == "youtube"
            {
                youtubeindexSet.add(i)
            }
            if let dict = arrImges[i] as? [String: Any], let type = dict["type"] as? String, type == "video"
            {
                videoindexSet.add(i)
            }
            if let dict = arrImges[i] as? [String: Any], let type = dict["type"] as? String, type == "image"
            {
                imageindexSet.add(i)
            }
        }
        
        let arrTempImage: NSMutableArray = NSMutableArray()
        arrTempImage.addObjects(from: arrImges.objects(at: youtubeindexSet as IndexSet))
        arrTempImage.addObjects(from: arrImges.objects(at: videoindexSet as IndexSet))
        arrTempImage.addObjects(from: arrImges.objects(at: imageindexSet as IndexSet))
        return arrTempImage
    }
    
    func extractYoutubeIdFromLink(link: String) -> String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        guard let regExp = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return nil
        }
        let nsLink = link as NSString
        let options = NSRegularExpression.MatchingOptions(rawValue: 0)
        let range = NSRange(location: 0, length: nsLink.length)
        let matches = regExp.matches(in: link as String, options:options, range:range)
        if let firstMatch = matches.first {
            return nsLink.substring(with: firstMatch.range)
        }
        else
        {
            return nil
        }
    }
    
    
    /*
    func setImagesInScrollView(getAllImages: NSMutableArray)
    {
        for index in 0..<getAllImages.count {
            
            frame.origin.x = self.scrlVwProImages.frame.size.width * CGFloat(index)
            frame.size = self.scrlVwProImages.frame.size
            let images = getAllImages[index]
            let imageUrl = images
            var imageView : UIImageView
            imageView  = UIImageView(frame:frame);
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.sd_setImage(with: URL(string: imageUrl as! String ), placeholderImage: UIImage(named: No_Image))
            
            var btn : UIButton
            btn  = UIButton(frame:frame);
            btn.tag = index
            btn.addTarget(self, action: #selector(imagePressed(sender:)), for: UIControlEvents.touchUpInside)
            
            self.scrlVwProImages .addSubview(imageView)
            self.scrlVwProImages .addSubview(btn)
        }
        self.scrlVwProImages.contentSize = CGSize(width: self.view.frame.size.width * CGFloat(getAllImages.count), height: self.scrlVwProImages.frame.size.height)
    }
    */
}
// MARK: - UIImagePickerControllerDelegate

extension CreateCampaignViewController: UIImagePickerControllerDelegate
{
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        dismiss(animated: true, completion: nil)
        // Handle a movie capture
        if mediaType == kUTTypeMovie {
            guard let path = (info[UIImagePickerControllerMediaURL] as! NSURL).path else { return }
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) {
                //UISaveVideoAtPathToSavedPhotosAlbum(path, self, #selector(CreateCampaignViewController.video(_:didFinishSavingWithError:contextInfo:)), nil)
                 let videoPath = info[UIImagePickerControllerMediaURL] as? NSURL
                //Upload(file: videoPath ?? "")
                self.setImageAndVideo(file: videoPath ?? "")
                
            }
        }
        else
        {
            let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.setImageAndVideo(file: selectedImage)
            //let imageView = UIImageView()
            //imageView.image = UIImage(contentsOfFile: imagePath)
            
            //Upload(file: selectedImage)
            /*
            print("Image saved")
            let dicDetails: NSMutableDictionary = NSMutableDictionary()
            dicDetails.setValue(imageView.image, forKey: "image")
            dicDetails.setValue("image", forKey: "type")
            arrImage.add(dicDetails)
            let collectionView = self.tblvwCampaign.viewWithTag(1) as! UICollectionView
            collectionView.reloadData()
            */
            //let indexPath = NSIndexPath(row: 0, section: 0)
            //self.tblvwCampaign.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
            //self.tblvwCampaign.reloadData()
        }
    }
    func video(videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
        var title = "Success"
        var message = "Video was saved"
        if let _ = error {
            title = "Error"
            message = "Video failed to save"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

//MARK:- UICollectionViewDelegate

extension CreateCampaignViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        if collectionView.tag == 1000
        {
            return 1
        }
        else if collectionView.tag == 1001
        {
            return 1
        }
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 1000
        {
            return arrImage.count
        }
        else if collectionView.tag == 1001
        {
            return arrCollaborators.count + 1
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView.tag == 1000
        {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageVideoShowCollectionViewCell", for: indexPath) as! ImageVideoShowCollectionViewCell
            //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
            //cell.imgvwToShow.image = UIImage(named: "chatList")
            
            let details: NSDictionary = (arrImage[indexPath.row] as? NSDictionary)!
            let type: String = (details["type"] as? String)!
            if type == "youtube"
            {
                cell.imgVwPlay.isHidden = false
                cell.btnPlay.isHidden = false
                cell.imgVwPlay.image = UIImage(named: "ytPlay")
                //cell.btnPlay?.addTarget(self, action: #selector(self.playYoutubeVideo(sender:)), for: UIControlEvents.touchUpInside)
                cell.btnPlay?.addTarget(self, action: #selector(self.selectCellCollectionView(sender:)), for: UIControlEvents.touchUpInside)
                cell.btnPlay.tag = indexPath.row
                let getUrl: String = (details["url"] as? String)!
                let youtubeVideoID = (extractYoutubeIdFromLink(link: getUrl))!
                let downloadURL = NSURL(string: "https://img.youtube.com/vi/\(youtubeVideoID)/default.jpg")!
                cell.imgvwToShow.sd_setImage(with: downloadURL as URL, placeholderImage: UIImage(named: No_Image))
                
                cell.btnClose?.addTarget(self, action: #selector(self.deleteImageOrVideo(sender:)), for: UIControlEvents.touchUpInside)
                cell.btnClose.tag = indexPath.row
            }
            else if type == "video"
            {
                cell.imgVwPlay.isHidden = false
                cell.btnPlay.isHidden = false
                cell.imgVwPlay.image = UIImage(named: "play")
                //cell.btnPlay?.addTarget(self, action: #selector(self.playNormalVideo(sender:)), for: UIControlEvents.touchUpInside)
                cell.btnPlay?.addTarget(self, action: #selector(self.selectCellCollectionView(sender:)), for: UIControlEvents.touchUpInside)
                cell.btnPlay.tag = indexPath.row
                if let getUrl = details["url"] as? URL
                {
                    DispatchQueue.global().async {
                        let asset = AVAsset(url: getUrl as URL)
                        let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
                        assetImgGenerate.appliesPreferredTrackTransform = true
                        let time = CMTimeMake(1, 2)
                        let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                        if img != nil {
                            let frameImg  = UIImage(cgImage: img!)
                            DispatchQueue.main.async(execute: {
                                cell.imgvwToShow.image = frameImg
                            })
                        }
                    }
                }
                cell.btnClose?.addTarget(self, action: #selector(self.deleteImageOrVideo(sender:)), for: UIControlEvents.touchUpInside)
                cell.btnClose.tag = indexPath.row
            }
            else if type == "image"
            {
                cell.imgVwPlay.isHidden = true
                cell.btnPlay.isHidden = false
                if let getUrl = details["url"] as? URL
                {
                    cell.imgvwToShow.sd_setImage(with: getUrl as URL, placeholderImage: UIImage(named: No_Image))
                }
                //cell.btnPlay?.addTarget(self, action: #selector(self.showImage(sender:)), for: UIControlEvents.touchUpInside)
                cell.btnPlay?.addTarget(self, action: #selector(self.selectCellCollectionView(sender:)), for: UIControlEvents.touchUpInside)
                cell.btnPlay.tag = indexPath.row
                cell.btnClose?.addTarget(self, action: #selector(self.deleteImageOrVideo(sender:)), for: UIControlEvents.touchUpInside)
                cell.btnClose.tag = indexPath.row
            }
            
            return cell
            
        }
        else if collectionView.tag == 1001
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollaboratorListCell", for: indexPath) as! CollaboratorListCell
            if indexPath.row == 0
            {
                cell.collaboratorImgvw.image = UIImage(named:"search_addCollaborator")
                cell.collaboratorName.text = "Search Contacts"
                
                cell.btnClose.isHidden = true
                cell.imgvwClose.isHidden = true
                
                return cell
            }
            else
            {
                let colaborator = arrCollaborators[indexPath.row-1]
                let fistName = colaborator.firstname ?? ""
                let lastName = colaborator.lastname ?? ""
                let profileImgURL = UrlUtil.getUserImage(image:colaborator.profileImg ?? "") 
                
                cell.collaboratorName.text = fistName  + " " + lastName
                //let getUrl: String = colaborator.profileImg ?? ""
                let downloadURL = NSURL(string: profileImgURL)
                
                //cell.collaboratorImgvw.image = UIImage(named:Default_Image)
                cell.collaboratorImgvw.sd_setImage(with: downloadURL! as URL, placeholderImage: UIImage(named: Default_Image))
                cell.collaboratorImgvw.layer.cornerRadius = cell.collaboratorImgvw.frame.size.height/2
                cell.collaboratorImgvw.clipsToBounds = true
                cell.collaboratorImgvw.layer.borderWidth = 2
                cell.collaboratorImgvw.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
                
                cell.btnClose?.addTarget(self, action: #selector(self.deleteCollaborator(sender:)), for: UIControlEvents.touchUpInside)
                cell.btnClose.tag = indexPath.row
                
                cell.btnClose.isHidden = false
                cell.imgvwClose.isHidden = false
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        //let details: NSDictionary = (arrImage[indexPath.row] as? NSDictionary)!
        if collectionView.tag == 1001
        {
            if indexPath.row == 0
            {
                self.AddCollaborator(sender: UIButton())
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 1000
        {
            return 2.0
        }
        else if collectionView.tag == 1001
        {
            return 1.0
        }
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 1000
        {
            return 2.0
        }
        else if collectionView.tag == 1001
        {
            return 1.0
        }
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 1000
        {
            return CGSize(width: 75, height: 55)
        }
        else if collectionView.tag == 1001
        {
            return CGSize(width: 100, height: 104)
        }
        return CGSize(width: 0, height: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView.tag == 1000
        {
            return UIEdgeInsets.zero
        }
        else if collectionView.tag == 1001
        {
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
        }
        return UIEdgeInsets.zero
    }
    
    
    
    @objc func selectCellCollectionView(sender: UIButton!)
    {
        self.selctdColCellIndex = sender.tag
        self.tblvwCampaign.reloadData()
    }
    
    @objc func deleteImageOrVideo(sender: UIButton!)
    {
        if arrImage.count >= sender.tag
        {
            arrImage.removeObject(at: sender.tag)
            selctdColCellIndex = selctdColCellIndex - 1 <= 0 ? 0 : selctdColCellIndex - 1
            DispatchQueue.main.async {
                self.tblvwCampaign.reloadData()
                let collectionView = self.tblvwCampaign.viewWithTag(1000) as! UICollectionView
                collectionView.reloadData()
            }
        }
        
    }
    
    @objc func deleteCollaborator(sender: UIButton!)
    {
        if arrCollaborators.count >= sender.tag
        {
            arrCollaborators.remove(at: sender.tag-1)
            DispatchQueue.main.async {
                self.tblvwCampaign.reloadData()
                let collectionView = self.tblvwCampaign.viewWithTag(1001) as! UICollectionView
                collectionView.reloadData()
            }
        }
        
    }
    
    
    @objc func playVideoORshowImage(sender: UIButton!)
    {
        let details: NSDictionary = (arrImage[sender.tag] as? NSDictionary)!
        let type: String = (details["type"] as? String)!
        if type == "youtube"
        {
            let getUrl: String = (details["url"] as? String)!
            let youtubeVideoID = (extractYoutubeIdFromLink(link: getUrl))!
            let moveViewController = YouTubeViewController()
            moveViewController.youtubeID = youtubeVideoID
            self.present(moveViewController, animated: true, completion: nil)
        }
        else if type == "video"
        {
            if let getUrl = details["url"] as? URL
            {
                self.playURLVideo(videoURL: getUrl)
            }
            
        }
        else //image
        {
            if let getUrl = details["url"] as? URL
            {
                let moveViewController = ImageFullViewController()
                moveViewController.urlImg = getUrl
                self.present(moveViewController, animated: true, completion: nil)
            }
        }
    }
    
    func playURLVideo(videoURL: URL)
    {
        if videoURL.isFileURL
        {
            let strURL = videoURL.absoluteString
            let fileURL = URL(fileURLWithPath: strURL)
            let player = AVPlayer(url: fileURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
        else
        {
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
        
    }
    /*@objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        //self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }*/
    
}

//MARK:- CollaboratorListControllerDalegate
extension CreateCampaignViewController: CollaboratorListControllerDalegate
{
    func fetchCollaboratorList(selectedCollaborator: [User])
    {
        self.arrCollaborators = selectedCollaborator
        DispatchQueue.main.async {
            //let indexPath = IndexPath(item: 0, section: 0)
            //self.tblvwCampaign.reloadRows(at: [indexPath], with: .fade)
            self.tblvwCampaign.reloadData()
            let collectionView = self.tblvwCampaign.viewWithTag(1001) as! UICollectionView
            collectionView.reloadData()
        }
    }
}

// MARK: - AddParkControllerDalegate
extension CreateCampaignViewController: AddParkControllerDalegate
{
    func getPerkData(PerkDetails:Perks!)
    {
        //arrPerkList = PerkDetails
        arrPerkList.append(PerkDetails)
        //let indexPath = IndexPath(item: rowNumber, section: 5)
        //tableView.reloadRows(at: [indexPath], with: .top)
        //self.tblvwCampaign.reloadSections([5], with: .automatic)
        self.tblvwCampaign.reloadData()
    }
}

//MARK:- TopicListControllerDalegate
extension CreateCampaignViewController: TopicListControllerDalegate
{
    func fetchTopicDetails(topic: SubTopicList)
    {
        self.categoryName = topic.name
        self.categoryType = topic.name
        campTopic = categoryName
        selectedTopic = topic
        
        self.tblvwCampaign.reloadData()
    }
}
//MARK:- UITextFieldDelegate
extension CreateCampaignViewController: UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        //print("TextField did end editing method called")
        if !(textField.text?.isEmpty)! // check textfield contains value or not
        {
            if textField.tag == 1
            {
                campName = textField.text!
            }
            else if textField.tag == 2
            {
                campTagName = textField.text!
            }
            
            
            else if textField.tag == 4
            {
                campTopic = textField.text!
            }
            else if textField.tag == 5
            {
                campExpDate = textField.text!
            }
            else if textField.tag == 6
            {
                campLocation = textField.text!
            }
            else if textField.tag == 9
            {
                campYoutubeURL = textField.text!
            }
            else if textField.tag == 10
            {
                campAskPrice = textField.text!
            }
        }
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder();
        return true;
    }
}
//MARK:- UITextViewDelegate
extension CreateCampaignViewController: UITextViewDelegate
{
    public func textViewDidEndEditing(_ textView: UITextView)
    {
        if !(textView.text?.isEmpty)! // check textView contains value or not
        {
            if textView.tag == 3
            {
                campDesc = textView.text!
            }
        }
    }
}

//MARK :- CountryPickerViewControllerDelegate
extension CreateCampaignViewController: CountryPickerViewControllerDelegate {
    func countryPickerViewController(_ countryPickerViewController: CountryPickerViewController, didSelectCountry country: CountryNew)
    {
        print("countryPickerViewControllerDidCancel: \(countryPickerViewController)")
        
        dismiss(animated: true, completion: {
            self.campLocation = country.name
            
            self.tblvwCampaign.reloadData()
        })
        
        
    }
    
    func countryPickerViewControllerDidCancel(_ countryPickerViewController: CountryPickerViewController) {
        print("countryPickerViewControllerDidCancel: \(countryPickerViewController)")
        
        dismiss(animated: true, completion: nil)
    }
    
    func countryPickerViewController(_ countryPickerViewController: CountryPickerViewController, didSelectCountry country: Country) {
        print("countryPickerViewController: \(countryPickerViewController) didSelectCountry: \(country)")
        
        dismiss(animated: true, completion: nil)
    }
}

