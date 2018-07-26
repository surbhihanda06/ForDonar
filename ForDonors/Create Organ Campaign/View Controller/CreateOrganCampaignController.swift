//
//  CreateOrganCampaignController.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 30/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit
import AVFoundation
import AlamofireImage
import Alamofire
import SVProgressHUD

class CreateOrganCampaignController: UIViewController, UINavigationControllerDelegate,StateListDelegate,CityDelegate,CountryListDelegate {
    
    @IBOutlet weak var lblPageTitle: UILabel!
    @IBOutlet weak var tblVwCreateOrgan: UITableView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var vwTransparent: UIView!
    @IBOutlet weak var vwUrl: UIView!
    @IBOutlet weak var vwLink: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var tfUrl: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblYouTubeTitle: UILabel!
    
    var pkrvwGender: UIPickerView = UIPickerView()
    var pkrVwOrgan: UIPickerView = UIPickerView()
    var pkrVwBlood: UIPickerView = UIPickerView()
    let pickOption = ["Male", "Female", "Other"]
    
    var topicId = ""
    var topicName = ""
    var campName: String = ""
    var campDescription: String = ""
    var gender: String = ""
    var blood: String = ""
    var organ: String = ""
    var height: String = ""
    var weight: String = ""
    var price: String = ""
    
    var campLocation = ""
    
    var selectedDate : String = ""
    
    var arrImage: NSMutableArray = NSMutableArray()
    var selctdColCellIndex = 0
    var imagePickerController = UIImagePickerController()
    
    var arrOrgans = [HealthTypeDetails]()
    var arrBlood = [BloodTypeDetails]()
    var arrCollaborators = [User]()
    
    var campaignId: Int = 0
    var fromCreateCampaign: Bool = false
    var countryID = String()
    var stateID = String()
    var cityID = String()
    var countryName = String()
    var stateName = String()
    var cityName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cellRegistration()
        getBloodList()
        getOrganList()
        getTopicList()
        pkrvwGender.delegate = self
        pkrvwGender.dataSource = self
        pkrVwOrgan.delegate = self
        pkrVwOrgan.dataSource = self
        pkrVwBlood.delegate = self
        pkrVwBlood.dataSource = self
        
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
        countryName = UserDefaults.standard.value(forKey: "country") as! String
        stateName = UserDefaults.standard.value(forKey: "state") as! String
        cityName = UserDefaults.standard.value(forKey: "city") as! String
        campLocation = countryName
    }
    
    func getStateDetails(stateId: String, stateName: String)
    {
        self.stateID = stateId
        self.stateName = stateName
        self.cityName = ""
        self.tblVwCreateOrgan.reloadData()
    }
    
    func cityDetails(cityId: String, cityName: String)
    {
        self.cityID = cityId
        self.cityName = cityName
        self.tblVwCreateOrgan.reloadData()
    }
    
    func getCountryDetails(countryId: String, countryName: String, countrySortname: String)
    {
        self.countryID = countryId
        self.countryName = countryName
        campLocation = self.countryName
        self.cityName = ""
        self.stateName = ""
        self.tblVwCreateOrgan.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        vwMain.isHidden = true
        
        lblPageTitle.text = "Create Campaign: Organ".localized
        btnNext.setTitle("Next".localized, for: .normal)
        btnOk.setTitle("Ok".localized, for: .normal)
        btnCancel.setTitle("Cancel".localized, for: .normal)
        lblYouTubeTitle.text = "".localized
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cellRegistration()
    {
        tblVwCreateOrgan.register(UINib(nibName: "AddImageWithoutImageListCell", bundle: Bundle.main), forCellReuseIdentifier: "AddImageWithoutImageListCell")
        
        tblVwCreateOrgan.register(UINib(nibName: "AddImageCell", bundle: Bundle.main), forCellReuseIdentifier: "AddImageCell")
        
        tblVwCreateOrgan.register(UINib(nibName: "CampaignNameTableCell", bundle: Bundle.main), forCellReuseIdentifier: "CampaignNameTableCell")
        
        tblVwCreateOrgan.register(UINib(nibName: "DescriptionCell", bundle: Bundle.main), forCellReuseIdentifier: "DescriptionCell")
        
        tblVwCreateOrgan.register(UINib(nibName: "SelectOrganTopicCell", bundle: Bundle.main), forCellReuseIdentifier: "SelectOrganTopicCell")
        
        tblVwCreateOrgan.register(UINib(nibName: "AskingCell", bundle: Bundle.main), forCellReuseIdentifier: "AskingCell")
        
        tblVwCreateOrgan.register(UINib(nibName: "SelectOrganCell", bundle: Bundle.main), forCellReuseIdentifier: "SelectOrganCell")
        
        tblVwCreateOrgan.register(UINib(nibName: "SelectGenderCell", bundle: Bundle.main), forCellReuseIdentifier: "SelectGenderCell")
        
        tblVwCreateOrgan.register(UINib(nibName: "SelectBloodTypeCell", bundle: Bundle.main), forCellReuseIdentifier: "SelectBloodTypeCell")
        
        tblVwCreateOrgan.register(UINib(nibName: "HeightCell", bundle: Bundle.main), forCellReuseIdentifier: "HeightCell")
        
        tblVwCreateOrgan.register(UINib(nibName: "SelectWeightCell", bundle: Bundle.main), forCellReuseIdentifier: "SelectWeightCell")
        
        tblVwCreateOrgan.register(UINib(nibName: "OfferPostExpensesCell", bundle: Bundle.main), forCellReuseIdentifier: "OfferPostExpensesCell")
        
        tblVwCreateOrgan.register(UINib(nibName: "CollaboratorContainerCell", bundle: Bundle.main), forCellReuseIdentifier: "CollaboratorContainerCell")
        
        tblVwCreateOrgan.register(UINib(nibName: "OrganExpireDateCell", bundle: Bundle.main), forCellReuseIdentifier: "OrganExpireDateCell")
        
        tblVwCreateOrgan.register(UINib(nibName: "OrganLocationCell", bundle: Bundle.main), forCellReuseIdentifier: "OrganLocationCell")
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
            self.tblVwCreateOrgan.reloadData()
            if let collectionView = self.tblVwCreateOrgan.viewWithTag(1000) as? UICollectionView
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
                    self.tblVwCreateOrgan.reloadData()
                    let collectionView = self.tblVwCreateOrgan.viewWithTag(1000) as! UICollectionView
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
    
    @objc func AddCollaborator(sender: UIButton!) {
        vwMain.isHidden = true
        vwUrl.isHidden = true
        
        let moveViewController = CollaboratorListController()
        moveViewController.delegate = self
        moveViewController.selectedCollaborators = arrCollaborators
        self.navigationController?.pushViewController(moveViewController, animated: true)
        
        
    }
    
    // MARK: - Service Call
    func getOrganList()
    {
        SVProgressHUD.show()
        let prmList:[String: Any] = [:]
        let request = MakeGetRequest.init(parameterList: prmList, APIName: "/healthtype/list")
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: HealthTypeResponse?) in
            SVProgressHUD.dismiss()
            if getMyData != nil
            {
                self.arrOrgans = (getMyData?.healthList)!
                self.pkrVwOrgan.reloadAllComponents()
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
                        Alert.disPlayAlertMessage(titleMessage: "Sorry!", alertMsg: msg)
                    }
                }
            }
        })
    }
    
    func getBloodList()
    {
        SVProgressHUD.show()
        let prmList:[String: Any] = [:]
        let request = MakeGetRequest.init(parameterList: prmList, APIName: "/bloodtype/list")
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: BloodTypeResponse?) in
            SVProgressHUD.dismiss()
            if getMyData != nil
            {
                self.arrBlood = (getMyData?.allBlood)!
                self.pkrVwBlood.reloadAllComponents()
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
                        Alert.disPlayAlertMessage(titleMessage: "Sorry!", alertMsg: msg)
                    }
                }
            }
        })
    }
    
    func getTopicList()
    {
        SVProgressHUD.show()
        let prmList:[String: Any] = [:]
        let apiName = String(format:"/topic/53601")
        let request = MakeGetRequest.init(parameterList: prmList, APIName: apiName)
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: TopicOrganResponse?) in
            SVProgressHUD.dismiss()
            if let response = getMyData
            {
                self.topicId = String(response.id)
                self.topicName = response.name!
                let rowNumber: Int = 4
                let indexPath = IndexPath(item: rowNumber, section: 0)
                self.tblVwCreateOrgan.reloadRows(at: [indexPath], with: .automatic)
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
    
    // MARK: - Action
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
        self.showImagePicker(type: "chooseVideo")
    }
    func showImagePicker(type:String)
    {
        imagePickerController.mediaTypes = [kUTTypeMovie as String]
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    func showImagePickerForImage(type:String)
    {
        imagePickerController.mediaTypes = [kUTTypeImage as String]
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    @IBAction func btnBackPressed(_ sender: Any)
    {
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
        
        if campDescription.isEmpty
        {
            Alert.disPlayAlertMessage(titleMessage: "Campaign Description", alertMsg: "Please enter campaign description!")
            return
        }
        
        if organ.isEmpty
        {
            Alert.disPlayAlertMessage(titleMessage: "select Organ", alertMsg: "Please select a Organ!")
            return
        }
        
        if gender.isEmpty
        {
            Alert.disPlayAlertMessage(titleMessage: "Gender", alertMsg: "Please select gender!")
            return
        }
        
        if blood.isEmpty
        {
            Alert.disPlayAlertMessage(titleMessage: "Blood", alertMsg: "Please select blood!")
            return
        }
        
        if height.isEmpty
        {
            Alert.disPlayAlertMessage(titleMessage: "Height", alertMsg: "Please enter height!")
            return
        }
        if weight.isEmpty
        {
            Alert.disPlayAlertMessage(titleMessage: "Weight", alertMsg: "Please enter Weight!")
            return
        }
        if price.isEmpty
        {
            Alert.disPlayAlertMessage(titleMessage: "Offer Surgery Expenses(PSE)", alertMsg: "Please enter price!")
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
        
        var prmList:[String: Any] = ["campaignName":campName, "campaignDescription":campDescription,    "campaignType":"2","healthRequest.weight": weight,"healthRequest.height": height,"healthRequest.bloodType": blood,"healthRequest.gender": Gender,"healthRequest.pre": price,"healthRequest.healthType.name":organ,"user.id": String(format:"%d",userId), "user.firstname": FName, "user.lastname": LName, "user.email": email,"user.phoneNumber":phoneNumber,"user.gender":Gender,"user.birthDate":birthDate,"topic.id":topicId,"topic.name":topicName,"topic.parentId":"53281","expirationDate":strDate,"country":campLocation,"campaign.countryId":Int(countryID)!,"campaign.cityId":Int(cityID)!]
        
        //,"user.address.address":address,"user.address.city":city,"user.address.state":state,"user.address.country":country,"user.address.zipCode":zipCode
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
        
        let apiName = "/campaign/add"
        let request = MakePostRequest.init(parameterList: prmList, APIName: apiName)
        RequestExecutor.uploadRequest(request, completion:{ (error: Error?, getMyData: CampaignResponse?) in
            self.handleData(error: error, getMyData: getMyData)
        })
        
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
//                let moveViewController = ConfirmationController()
//                self.campaignId = campDetails.id
//                moveViewController.campaignId = campDetails.id//String(format:"%d",campDetails.id)
//                moveViewController.fromHomeOrUpload = "Upload"
//                self.navigationController?.pushViewController(moveViewController, animated: true)
//                moveViewController.fromOrgan = true
                let moveViewController = OrganCampaignOverviewController()
               moveViewController.parentViewcontroller = "CreateOrganCampaignController"
                moveViewController.countryID = self.countryID
                self.navigationController?.pushViewController(moveViewController, animated: true)
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
    @objc func gallaryClick(sender: UIButton!)
    {
        attachmentActionSheetForImage()
    }
    @objc func VideoClick(sender: UIButton!) {
        
        self.attachmentActionSheet()
        //getVideoOption()
        
        //startCameraFromViewController(viewController: self, withDelegate: self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
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
                self.tblVwCreateOrgan.reloadData()
                let collectionView = self.tblVwCreateOrgan.viewWithTag(1000) as! UICollectionView
                collectionView.reloadData()
            }
        }
        else
        {
            Alert.disPlayAlertMessage(titleMessage: "Sorry!", alertMsg: "Please add URL.")
        }
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        vwMain.isHidden = true
    }
    
}
//MARK:- CollaboratorListControllerDalegate
extension CreateOrganCampaignController: CollaboratorListControllerDalegate
{
    func fetchCollaboratorList(selectedCollaborator: [User])
    {
        self.arrCollaborators = selectedCollaborator
        DispatchQueue.main.async {
            //let indexPath = IndexPath(item: 0, section: 0)
            //self.tblvwCampaign.reloadRows(at: [indexPath], with: .fade)
            self.tblVwCreateOrgan.reloadData()
            let collectionView = self.tblVwCreateOrgan.viewWithTag(1001) as! UICollectionView
            collectionView.reloadData()
        }
    }
}
// MARK: - UIImagePickerControllerDelegate

extension CreateOrganCampaignController: UIImagePickerControllerDelegate
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
extension CreateOrganCampaignController: UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 16
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
            
            return 65
        }
        else if indexPath.row==2
        {
            
            return 140
        }
        else if indexPath.row==3
        {
            
            return 70
        }
        else if indexPath.row==4
        {
            
            
            return 83
        }
        else if indexPath.row==5
        {
            
            
            return 70
        }
        else if indexPath.row==6
        {
            
            return 70
        }
        else if indexPath.row==7
        {
            
            return 70
        }
        else if indexPath.row==8
        {
            
            return 70
        }
        else if indexPath.row==9
        {
            
            return 70
        }
        else if indexPath.row==10
        {
            
            return 83
        }
        else if indexPath.row==11
        {
            
            return 83
        }
        else if indexPath.row==12
        {
            
            return 83
        }
        else if indexPath.row==13
        {
            
            return 83
        }
        else if indexPath.row==14
        {
            
            return 90
        }
        else
        {
            
            return 140
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            let  cell = tableView.dequeueReusableCell(withIdentifier: "CampaignNameTableCell", for: indexPath) as! CampaignNameTableCell
            cell.lblTitle.text = "Campaign Name".localized
            cell.selectionStyle = .none
            cell.tfCampaignName.tag = indexPath.row
            cell.tfCampaignName.delegate = self
            return cell
        }
        else if indexPath.row==2
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as! DescriptionCell
            cell.lblTitle.text = "Description".localized
            cell.tvDescription.tag = indexPath.row
            cell.tvDescription.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==3
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "AskingCell", for: indexPath) as! AskingCell
            cell.lblTitle.text = "Asking".localized
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==4
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectOrganTopicCell") as! SelectOrganTopicCell
            cell.lblTitle.text = "Topic Organ".localized
            //cell.btnTopic?.addTarget(self, action: #selector(self.topicPressed), for: UIControlEvents.touchUpInside)
            cell.btnTopic.tag = indexPath.row
            cell.tfTopic.tag = indexPath.row
            cell.tfTopic.delegate = self
            cell.tfTopic.text = topicName
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==5
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "SelectOrganCell", for: indexPath) as! SelectOrganCell
            cell.lblTitle.text = "Select Organ".localized
            cell.tfOrgan.inputView = pkrVwOrgan
            cell.tfOrgan.text = organ
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==6
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "SelectGenderCell", for: indexPath) as! SelectGenderCell
            cell.lblTitle.text = "Gender".localized
            cell.tfGender.inputView = pkrvwGender
            cell.tfGender.text = gender
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==7
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "SelectBloodTypeCell", for: indexPath) as! SelectBloodTypeCell
            cell.lblTitle.text = "Blood Type".localized
            cell.tfBloodType.inputView = pkrVwBlood
            cell.tfBloodType.text = blood
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==8
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "HeightCell", for: indexPath) as! HeightCell
            cell.lblTitle.text = "Height".localized
            cell.tfHeight.tag = indexPath.row
            cell.tfHeight.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==9
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "SelectWeightCell", for: indexPath) as! SelectWeightCell
            cell.lblTitle.text = "Weight".localized
            cell.tfWeight.tag = indexPath.row
            cell.tfWeight.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==10
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "OrganExpireDateCell", for: indexPath) as! OrganExpireDateCell
            cell.lblTitle.text = "Expire Date".localized
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
            cell.tfExpireDate.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(dateDoneButtonClicked(_:)))
            
            cell.tfExpireDate.inputView = datePickerView
            cell.tfExpireDate.text = selectedDate
            cell.tfExpireDate.tag = indexPath.row
            cell.tfExpireDate.delegate = self
            cell.selectionStyle = .none
            return cell
        }
//        else if indexPath.row==11
//        {
//            let  cell = tableView.dequeueReusableCell(withIdentifier: "OrganLocationCell", for: indexPath) as! OrganLocationCell
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
        //country
        else if indexPath.row==11
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "OrganLocationCell", for: indexPath) as! OrganLocationCell
            cell.lblTitle.text = "Country".localized
            cell.tfLocation.tag = indexPath.row
            cell.tfLocation.delegate = self
            //cell.tfLocation.text = campLocation
            cell.tfLocation.text = countryName
            cell.btnLocation?.addTarget(self, action: #selector(self.countryPressed), for: UIControlEvents.touchUpInside)
            cell.btnLocation.tag = indexPath.row
            cell.selectionStyle = .none
            return cell
        }
        //State
        else if indexPath.row==12
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "OrganLocationCell", for: indexPath) as! OrganLocationCell
            cell.lblTitle.text = "State".localized
            cell.tfLocation.tag = indexPath.row
            cell.tfLocation.delegate = self
            cell.tfLocation.text = stateName
            cell.btnLocation?.addTarget(self, action: #selector(self.statePressed), for: UIControlEvents.touchUpInside)
            cell.btnLocation.tag = indexPath.row
            cell.selectionStyle = .none
            return cell
        }
        //City
        else if indexPath.row==13
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "OrganLocationCell", for: indexPath) as! OrganLocationCell
            cell.lblTitle.text = "City".localized
            cell.tfLocation.tag = indexPath.row
            cell.tfLocation.delegate = self
            cell.tfLocation.text = cityName
            cell.btnLocation?.addTarget(self, action: #selector(self.cityPressed), for: UIControlEvents.touchUpInside)
            cell.btnLocation.tag = indexPath.row
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==14
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "OfferPostExpensesCell", for: indexPath) as! OfferPostExpensesCell
            cell.lblTitle.text = "Offer Surgery Expenses (PSE)".localized
            cell.tfPrice.tag = indexPath.row
            cell.tfPrice.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else
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
    }
}
extension CreateOrganCampaignController: UITextFieldDelegate
{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !(textField.text?.isEmpty)! // check textfield contains value or not
        {
            if textField.tag == 1
            {
                campName = textField.text!
            }
            else if textField.tag == 8
            {
                height = textField.text!
            }
            else if textField.tag == 9
            {
                weight = textField.text!
            }
            else if textField.tag == 14
            {
                price = textField.text!
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    @objc func expireDateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateOnlyFormat
        selectedDate = dateFormatter.string(from: sender.date)
        
        let indexPath = NSIndexPath(row: 10, section: 0)
        self.tblVwCreateOrgan.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
    }
    
    @objc func dateDoneButtonClicked(_ sender: UITextField) {
        //your code when clicked on done
        if selectedDate.isEmpty
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateOnlyFormat
            selectedDate = dateFormatter.string(from: Date())
        }
        self.tblVwCreateOrgan.reloadData()
        
    }
    
    @objc func countryPressed(sender: UIButton!)
    {
        if sender.tag == 11
        {
            let moveViewController = CountryListController()
            self.present(moveViewController, animated: true, completion: nil)
            moveViewController.delegate = self
        }
    }
    
    @objc func statePressed(sender: UIButton!)
    {
        if sender.tag == 12
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
        if sender.tag == 13
        {
            let viewController = CityController()
            viewController.delegate = self
            viewController.stateId = self.stateID
            let navigationController = UINavigationController(rootViewController: viewController)
            present(navigationController, animated: true, completion: nil)
        }
    }
//    @objc func locationPressed(sender: UIButton!)
//    {
//        let viewController = CountryPickerViewController()
//        viewController.delegate = self
//        let navigationController = UINavigationController(rootViewController: viewController)
//        present(navigationController, animated: true, completion: nil)
//    }
}

//MARK:- UITextViewDelegate
extension CreateOrganCampaignController: UITextViewDelegate
{
    public func textViewDidEndEditing(_ textView: UITextView)
    {
        if !(textView.text?.isEmpty)! // check textView contains value or not
        {
            if textView.tag == 2
            {
                campDescription = textView.text!
            }
        }
    }
}
//MARK:- UICollectionViewDelegate

extension CreateOrganCampaignController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
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
        self.tblVwCreateOrgan.reloadData()
    }
    
    @objc func deleteImageOrVideo(sender: UIButton!)
    {
        if arrImage.count >= sender.tag
        {
            arrImage.removeObject(at: sender.tag)
            selctdColCellIndex = selctdColCellIndex - 1 <= 0 ? 0 : selctdColCellIndex - 1
            DispatchQueue.main.async {
                self.tblVwCreateOrgan.reloadData()
                let collectionView = self.tblVwCreateOrgan.viewWithTag(1000) as! UICollectionView
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
                self.tblVwCreateOrgan.reloadData()
                let collectionView = self.tblVwCreateOrgan.viewWithTag(1001) as! UICollectionView
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

extension CreateOrganCampaignController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView == pkrvwGender
        {
            return pickOption.count
        }
        else if pickerView == pkrVwBlood
        {
            return arrBlood.count
        }
        else
        {
            return arrOrgans.count
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pkrvwGender
        {
            return pickOption[row]
        }
        else if pickerView == pkrVwBlood
        {
            let details = arrBlood[row]
            return details.name
        }
        else
        {
            let details = arrOrgans[row]
            return details.name
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //self.tfGender.text = pickOption[row]
        if pickerView == pkrvwGender
        {
            gender = pickOption[row]
            let rowNumber: Int = 6
            let indexPath = IndexPath(item: rowNumber, section: 0)
            self.tblVwCreateOrgan.reloadRows(at: [indexPath], with: .automatic)
        }
        else if pickerView == pkrVwBlood
        {
            let details = arrBlood[row]
            blood = details.name!
            let rowNumber: Int = 7
            let indexPath = IndexPath(item: rowNumber, section: 0)
            self.tblVwCreateOrgan.reloadRows(at: [indexPath], with: .automatic)
        }
        else
        {
            let details = arrOrgans[row]
            organ = details.name!
            let rowNumber: Int = 5
            let indexPath = IndexPath(item: rowNumber, section: 0)
            self.tblVwCreateOrgan.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
//MARK :- CountryPickerViewControllerDelegate
extension CreateOrganCampaignController: CountryPickerViewControllerDelegate {
    func countryPickerViewController(_ countryPickerViewController: CountryPickerViewController, didSelectCountry country: CountryNew)
    {
        print("countryPickerViewControllerDidCancel: \(countryPickerViewController)")
        
        dismiss(animated: true, completion: {
            self.campLocation = country.name
            self.tblVwCreateOrgan.reloadData()
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

