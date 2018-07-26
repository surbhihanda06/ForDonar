//
//  VerificationController.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 02/05/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import SVProgressHUD

class VerificationController: UIViewController {
    
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var lblPageTitle: UILabel!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var tblVwVerification: UITableView!
    
    let borderColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
    
    var imagePickerController = UIImagePickerController()
    
    var firstName = ""
    var lastName = ""
    var gender = ""
    var selectedCountry = ""
    var passportNumber = ""
    var licenseNumber = ""
    var userImage = ""
    var userImageFile: NSURL = NSURL()
    var passportCoverImage = UIImage()
    var passportPhoto = UIImage()
    var selfie = UIImage()
    var licenseFrontImage = UIImage()
    var licenseBackImage = UIImage()
    
    var arrPassportImage = [NSURL]()
    var arrLicenseImage = [NSURL]()
    
    var fromPage = ""
    
    var selectedPath: Int = 0
    
    var arrDocumentType = [IdType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellRegistration()
        
        let prefs = UserDefaults.standard
        print(prefs.string(forKey: "city") ?? "")
        firstName = prefs.string(forKey: "FName") ?? ""
        lastName = prefs.string(forKey: "LName") ?? ""
        selectedCountry = prefs.string(forKey: "country") ?? ""
        gender = prefs.string(forKey: "Gender") ?? ""
        userImage = prefs.string(forKey: "profileImg") ?? ""
        
        let imgVwuser = UIImageView()
        let getImage = UrlUtil.getUserImage(image: userImage)
        imgVwuser.sd_setImage(with: URL(string: getImage), placeholderImage: UIImage(named: Default_Image))
        self.setImageAndVideo(file: imgVwuser.image as Any, type: "profileImg")
        
        let url: NSURL = NSURL()
        arrPassportImage.insert(url, at: 0)
        arrPassportImage.insert(url, at: 1)
        arrPassportImage.insert(url, at: 2)
        arrLicenseImage.insert(url, at: 0)
        arrLicenseImage.insert(url, at: 1)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblPageTitle.text = "Verification".localized
        btnSkip.setTitle("Skip".localized, for: .normal)
        if fromPage == "SignUp"
        {
            btnSkip.isHidden = false
            vwBack.isHidden = true
        }
        else
        {
            btnSkip.isHidden = true
            vwBack.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cellRegistration()   {
        
        self.tblVwVerification.register(UINib(nibName: "ImageVerificationCell", bundle: Bundle.main), forCellReuseIdentifier: "ImageVerificationCell")
        
        self.tblVwVerification.register(UINib(nibName: "PassportNumberCell", bundle: Bundle.main), forCellReuseIdentifier: "PassportNumberCell")
        
        self.tblVwVerification.register(UINib(nibName: "PassportCoverCell", bundle: Bundle.main), forCellReuseIdentifier: "PassportCoverCell")
        
        self.tblVwVerification.register(UINib(nibName: "PassportPhotoPageCell", bundle: Bundle.main), forCellReuseIdentifier: "PassportPhotoPageCell")
        
        self.tblVwVerification.register(UINib(nibName: "SelfiePhotoCell", bundle: Bundle.main), forCellReuseIdentifier: "SelfiePhotoCell")
        
        self.tblVwVerification.register(UINib(nibName: "FirstNameCell", bundle: Bundle.main), forCellReuseIdentifier: "FirstNameCell")
        
        self.tblVwVerification.register(UINib(nibName: "LastNameCell", bundle: Bundle.main), forCellReuseIdentifier: "LastNameCell")
        
        self.tblVwVerification.register(UINib(nibName: "GenderCell", bundle: Bundle.main), forCellReuseIdentifier: "GenderCell")
        
        self.tblVwVerification.register(UINib(nibName: "CountryVerificationCell", bundle: Bundle.main), forCellReuseIdentifier: "CountryVerificationCell")
        
        self.tblVwVerification.register(UINib(nibName: "PrimaryIdentificationTitleCell", bundle: Bundle.main), forCellReuseIdentifier: "PrimaryIdentificationTitleCell")
        
        self.tblVwVerification.register(UINib(nibName: "UserCardCell", bundle: Bundle.main), forCellReuseIdentifier: "UserCardCell")
        
        self.tblVwVerification.register(UINib(nibName: "UserCardTextCell", bundle: Bundle.main), forCellReuseIdentifier: "UserCardTextCell")
        
        self.tblVwVerification.register(UINib(nibName: "SecondaryIdentificationTitleCell", bundle: Bundle.main), forCellReuseIdentifier: "SecondaryIdentificationTitleCell")
        
        self.tblVwVerification.register(UINib(nibName: "LicenseNumberCell", bundle: Bundle.main), forCellReuseIdentifier: "LicenseNumberCell")
        
        self.tblVwVerification.register(UINib(nibName: "LicenseFrontCell", bundle: Bundle.main), forCellReuseIdentifier: "LicenseFrontCell")
        
        self.tblVwVerification.register(UINib(nibName: "LicenseBackCell", bundle: Bundle.main), forCellReuseIdentifier: "LicenseBackCell")
        
        self.tblVwVerification.register(UINib(nibName: "SkipVerificationCell", bundle: Bundle.main), forCellReuseIdentifier: "SkipVerificationCell")
        
        self.tblVwVerification.register(UINib(nibName: "NextButtonCell", bundle: Bundle.main), forCellReuseIdentifier: "NextButtonCell")
        
        self.tblVwVerification.delegate=self
        self.tblVwVerification.dataSource=self
        
    }

    // MARK: - Action
    @IBAction func btnSkipPressed(_ sender: Any)
    {
        /*
        if let pvc = self.presentingViewController
        {
            self.dismiss(animated: true, completion: {
                let vc = BecomeADonorViewController()
                pvc.present(vc, animated: false, completion: nil)
            })
        }
        */
        dismissController()
    }
    
    func dismissController()
    {
        if let pvc = self.presentingViewController as? UINavigationController
        {
            self.dismiss(animated: false, completion: {
                
                var inLoop = false
                for vc in pvc.viewControllers
                {
                    if vc.isKind(of: HomeController.self)
                    {
                        inLoop = true
                        pvc.popToViewController(vc, animated: true)
                        break
                    }
                }
                if !inLoop
                {
                    let homevc = HomeController()
                    pvc.navigationController?.pushViewController(homevc, animated: true)
                }
            })
        }
    }
    
    @IBAction func btnBackPressed(_ sender: Any)
    {
        if let pvc = self.presentingViewController
        {
            self.dismiss(animated: true, completion: {
                let vc = PopUpController()
                vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                pvc.present(vc, animated: false, completion: nil)
            })
        }
    }
    
    @objc func CameraClick(sender: UIButton!)
    {
        attachmentActionSheetForImage()
    }
    @objc func countryClick(sender: UIButton!)
    {
        let moveViewController = CountryListController()
        self.present(moveViewController, animated: true, completion: nil)
        moveViewController.delegate = self
    }
    @objc func passportPhotoClick(sender: UIButton!)
    {
        selectedPath = sender.tag
        attachmentActionSheetForImage()
    }
    @objc func passportCoverClick(sender: UIButton!)
    {
        selectedPath = sender.tag
        attachmentActionSheetForImage()
    }
    @objc func selfieClick(sender: UIButton!)
    {
        selectedPath = sender.tag
        attachmentActionSheetForImage()
    }
    @objc func licenseFrontClick(sender: UIButton!)
    {
        selectedPath = sender.tag
        attachmentActionSheetForImage()
    }
    @objc func licenseBackClick(sender: UIButton!)
    {
        selectedPath = sender.tag
        attachmentActionSheetForImage()
    }
    @IBAction func btnNextPressed(_ sender: Any)
    {
        let isBankAdded: Bool = (UserDefaults.standard.bool(forKey: "isBanking"))
        let isVerified: Bool = (UserDefaults.standard.bool(forKey: "isVerified"))
        //http://fordonor.us-west-2.elasticbeanstalk.com/api/user/verification/update
        
        arrDocumentType.insert(IdType.init(type: "0", number: passportNumber), at: 0)
        arrDocumentType.insert(IdType.init(type: "1", number: licenseNumber), at: 1)
        
        
        if firstName.isEmpty
        {
            Alert.disPlayAlertMessage(titleMessage: "First name", alertMsg: "Please enter first name.")
        }
        else if lastName.isEmpty
        {
            Alert.disPlayAlertMessage(titleMessage: "Last name", alertMsg: "Please enter last name.")
        }
        else if gender.isEmpty
        {
            Alert.disPlayAlertMessage(titleMessage: "Gender", alertMsg: "Please enter gender.")
        }
        else if selectedCountry.isEmpty
        {
            Alert.disPlayAlertMessage(titleMessage: "Country", alertMsg: "Please add country.")
        }
        else if arrPassportImage.count < 3
        {
            Alert.disPlayAlertMessage(titleMessage: "Passport Image", alertMsg: "Please add all the passport photo.")
        }
        else if arrLicenseImage.count < 2
        {
            Alert.disPlayAlertMessage(titleMessage: "Driving license", alertMsg: "Please add your driving license photo.")
        }
        else
        {
            SVProgressHUD.show()
             let userId = UserDefaults.standard.object(forKey: "userId") as? Int ?? 0
            var prmList:[String: Any] = ["id":String(format:"%d",userId),"firstname": firstName,"lastname": lastName,"gender": gender,"userVerifications[0].country": selectedCountry,"passportFiles": arrPassportImage,"drivingLicenseFiles":arrLicenseImage,"profileImage":userImageFile]
            for i in 0..<self.arrDocumentType.count
            {
                let documents = self.arrDocumentType[i]
                
                var key = String(format:"userVerifications[%d].idType",i)
                var value = documents.type
                prmList[key] = value
                
                key = String(format:"userVerifications[%d].idNumber",i)
                value = documents.number
                prmList[key] = value
            }
            let request = MakePostRequest.init(parameterList: prmList, APIName: "/user/verification/update")
            RequestExecutor.uploadRequest(request, completion:{ (error: Error?, getMyData: UserAPIResponse?) in
                
                SVProgressHUD.dismiss()
                if let response = getMyData
                {
                    if let userDetails = response.data
                    {
                        Validation.saveUserToUserDefaults(userDetails: userDetails)
                        UserDefaults.standard.set(true, forKey: "isVerified")
                        UserDefaults.standard.set(UserDefaults.standard.value(forKey: "isBanking"), forKey: "isBanking")
                        UserDefaults.standard.synchronize()
                        
//                        if let pvc = self.presentingViewController
//                        {
//                            self.dismiss(animated: true, completion: {
//                                let vc = BecomeADonorViewController()
//                                pvc.present(vc, animated: true, completion: nil)
//                            })
//                        }
                        if let pvc = self.presentingViewController
                        {
                            self.dismiss(animated: true, completion: {
                                if UserDefaults.standard.value(forKey: "isBanking") as? Bool == true && UserDefaults.standard.value(forKey: "isVerified") as? Bool == true
                                {
                                    
                                }
                                else
                                {
                                    let vc = PopUpController()
                                    vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                    pvc.present(vc, animated: false, completion: nil)
                                }
                            })
                        }
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
            })
            
        }
        
    }
    private func attachmentActionSheetForImage()
    {
        self.showImagePickerForImage(type: "choosePhoto")
    }
    func showImagePickerForImage(type:String)
    {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        if type == "takePhoto"
        {
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
        }
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    func setViewBorder(vw: UIView)
    {
        vw.layer.borderColor = borderColor.cgColor
        vw.layer.borderWidth = 1.0
        vw.clipsToBounds = true
    }
    func setImageAndVideo(file: Any, type: String)
    {
        let value = file as? UIImage
        let filePath: NSURL = self.saveImageToDocumentDir(image: value!) as NSURL
        
        if type == "passportCoverImage"
        {
            self.arrPassportImage.remove(at: 0)
            self.arrPassportImage.insert(filePath, at: 0)
        }
        else if type == "passportPhoto"
        {
            self.arrPassportImage.remove(at: 1)
            self.arrPassportImage.insert(filePath, at: 1)
        }
        else if type == "selfie"
        {
            self.arrPassportImage.remove(at: 2)
            self.arrPassportImage.insert(filePath, at: 2)
            //self.arrPassportImage.insert(filePath, at: 2)
        }
        else if type == "licenseFrontImage"
        {
            self.arrLicenseImage.remove(at: 0)
            self.arrLicenseImage.insert(filePath, at: 0)
        }
        else if type == "licenseBackImage"
        {
            self.arrLicenseImage.remove(at: 1)
            self.arrLicenseImage.insert(filePath, at: 1)
        }
        else if type == "profileImg"
        {
            userImageFile = filePath
        }
        //self.arrPassportImage.add(dictMedia)
        DispatchQueue.main.async {
            //let indexPath = IndexPath(item: 0, section: 0)
            //self.tblvwCampaign.reloadRows(at: [indexPath], with: .fade)
            self.tblVwVerification.reloadData()
            
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
}
extension VerificationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageView = UIImageView()
        imageView.image = selectedImage
        print("selectedPath:", selectedPath)
        if selectedPath == 7
        {
            passportCoverImage = selectedImage
            self.setImageAndVideo(file: selectedImage, type: "passportCoverImage")
        }
        else if selectedPath == 8
        {
            passportPhoto = selectedImage
            self.setImageAndVideo(file: selectedImage, type: "passportPhoto")
        }
        else if selectedPath == 9
        {
            selfie = selectedImage
            self.setImageAndVideo(file: selectedImage, type: "selfie")
        }
        else if selectedPath == 14
        {
            licenseFrontImage = selectedImage
            self.setImageAndVideo(file: selectedImage, type: "licenseFrontImage")
        }
        else if selectedPath == 15
        {
            licenseBackImage = selectedImage
            self.setImageAndVideo(file: selectedImage, type: "licenseBackImage")
        }
        self.tblVwVerification.reloadData()
        //imageUpload(file: selectedImage)
        dismiss(animated: true, completion: nil)
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

extension VerificationController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 18
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row==0
        {
            return 150
        }
        else if indexPath.row==1
        {
            return 65
        }
        else if indexPath.row==2
        {
            return 65
        }
        else if indexPath.row==3
        {
            return 65 //140
        }
        else if indexPath.row==4
        {
            return 65
        }
        else if indexPath.row==5
        {
            return 65
        }
        else if indexPath.row==6
        {
            return 140
        }
        else if indexPath.row==7
        {
            return 226
        }
        else if indexPath.row==8
        {
            return 226
        }
        else if indexPath.row==9
        {
            return 226
        }
        else if indexPath.row==10
        {
            return 130
        }
        else if indexPath.row==11
        {
            return 100
        }
        else if indexPath.row==12
        {
            return 50
        }
        else if indexPath.row==13
        {
            return 140
        }
        else if indexPath.row==14
        {
            return 226
        }
        else if indexPath.row==15
        {
            return 226
        }
        else if indexPath.row==16
        {
            return 100
        }
        else
        {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row==0
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "ImageVerificationCell", for: indexPath) as! ImageVerificationCell
            cell.selectionStyle = .none
            cell.imgVwImage.layer.cornerRadius = cell.imgVwImage.frame.size.height / 2
            cell.imgVwImage.layer.masksToBounds = true
            
            cell.vwImage.layer.cornerRadius = cell.vwImage.frame.size.height / 2
            cell.vwImage.layer.masksToBounds = true
            cell.vwImage.layer.borderWidth = 1
            cell.vwImage.layer.borderColor = UIColor.lightGray.cgColor
            
            let getImage = UrlUtil.getUserImage(image: userImage)
            cell.imgVwImage.sd_setImage(with: URL(string: getImage), placeholderImage: UIImage(named: Default_Image))
            
            cell.btnCamera?.addTarget(self, action: #selector(self.CameraClick), for: UIControlEvents.touchUpInside)
            cell.btnCamera.tag = indexPath.row
            
            return cell
        }
        else if indexPath.row==1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FirstNameCell") as! FirstNameCell
            self.setViewBorder(vw: cell.vwBg)
            cell.tfFirstName.text = firstName
            cell.tfFirstName.tag = indexPath.row
            cell.tfFirstName.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LastNameCell") as! LastNameCell
            self.setViewBorder(vw: cell.vwBg)
            cell.tfLastName.text = lastName
            cell.tfLastName.tag = indexPath.row
            cell.tfLastName.delegate = self
            cell.selectionStyle = .none
            return cell
        }
            
        else if indexPath.row==3
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GenderCell") as! GenderCell
            self.setViewBorder(vw: cell.vwBg)
            cell.tfGender.text = gender
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==4
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CountryVerificationCell") as! CountryVerificationCell
            self.setViewBorder(vw: cell.vwCountry)
            cell.btnCountry?.addTarget(self, action: #selector(self.countryClick), for: UIControlEvents.touchUpInside)
            cell.btnCountry.tag = indexPath.row
            cell.tfCountry.text = selectedCountry
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==5
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PrimaryIdentificationTitleCell") as! PrimaryIdentificationTitleCell
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==6
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PassportNumberCell") as! PassportNumberCell
            self.setViewBorder(vw: cell.vwNumber)
            //cell.tfNumber.text = passportNumber
            cell.tfNumber.tag = indexPath.row
            cell.tfNumber.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==7
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PassportCoverCell") as! PassportCoverCell
            cell.btnCamera?.addTarget(self, action: #selector(self.passportCoverClick), for: UIControlEvents.touchUpInside)
            cell.imgVwImage.image = passportCoverImage
            cell.btnCamera.tag = indexPath.row
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==8
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PassportPhotoPageCell") as! PassportPhotoPageCell
            cell.btnCamera?.addTarget(self, action: #selector(self.passportPhotoClick), for: UIControlEvents.touchUpInside)
            cell.imgVwImage.image = passportPhoto
            cell.btnCamera.tag = indexPath.row
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==9
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelfiePhotoCell") as! SelfiePhotoCell
            cell.btnCamera?.addTarget(self, action: #selector(self.selfieClick), for: UIControlEvents.touchUpInside)
            cell.btnCamera.tag = indexPath.row
            cell.imgVwImage.image = selfie
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==10
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCardCell") as! UserCardCell
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==11
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCardTextCell") as! UserCardTextCell
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==12
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SecondaryIdentificationTitleCell") as! SecondaryIdentificationTitleCell
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==13
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LicenseNumberCell") as! LicenseNumberCell
            self.setViewBorder(vw: cell.vwBg)
            //cell.tfLicenseNumber.text = licenseNumber
            cell.tfLicenseNumber.tag = indexPath.row
            cell.tfLicenseNumber.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==14
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LicenseFrontCell") as! LicenseFrontCell
            cell.btnLicenseFront?.addTarget(self, action: #selector(self.licenseFrontClick), for: UIControlEvents.touchUpInside)
            cell.btnLicenseFront.tag = indexPath.row
            cell.imgVwLicenseFront.image = licenseFrontImage
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==15
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LicenseBackCell") as! LicenseBackCell
            cell.btnLicenseBack?.addTarget(self, action: #selector(self.licenseBackClick), for: UIControlEvents.touchUpInside)
            cell.btnLicenseBack.tag = indexPath.row
            cell.imgVwLicenseBack.image = licenseBackImage
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==16
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SkipVerificationCell") as! SkipVerificationCell
            cell.selectionStyle = .none
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NextButtonCell") as! NextButtonCell
            cell.btnNext?.addTarget(self, action: #selector(self.btnNextPressed(_:)), for: UIControlEvents.touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
    }
}
extension VerificationController: UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        //print("TextField did end editing method called")
        if !(textField.text?.isEmpty)! // check textfield contains value or not
        {
            if textField.tag == 1
            {
                firstName = textField.text!
            }
            else if textField.tag == 2
            {
                lastName = textField.text!
            }
            else if textField.tag == 4
            {
                gender = textField.text!
            }
            else if textField.tag == 5
            {
                selectedCountry = textField.text!
            }
            else if textField.tag == 6
            {
                passportNumber = textField.text!
            }
            else if textField.tag == 13
            {
                licenseNumber = textField.text!
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder();
        return true;
    }
}
//Mark :- Country List fetch
extension VerificationController: CountryPickerViewControllerDelegate {
    func countryPickerViewController(_ countryPickerViewController: CountryPickerViewController, didSelectCountry country: CountryNew)
    {
        dismiss(animated: true, completion: nil)
        selectedCountry = country.name
    }
    
    func countryPickerViewControllerDidCancel(_ countryPickerViewController: CountryPickerViewController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func countryPickerViewController(_ countryPickerViewController: CountryPickerViewController, didSelectCountry country: Country)
    {
        dismiss(animated: true, completion: nil)
    }
}
// MARK:- Country List Delegate
extension VerificationController:CountryListDelegate
{
    func getCountryDetails(countryId: String, countryName: String,countrySortname: String)
    {
        selectedCountry = countryName
        self.tblVwVerification.reloadData()
    }
}
