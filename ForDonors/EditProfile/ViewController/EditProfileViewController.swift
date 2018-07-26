//
//  EditProfileViewController.swift
//  ForDonors
//
//  Created by NITS_Mac4 on 15/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import SVProgressHUD

class EditProfileViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var lblPageTitle: UILabel!
    @IBOutlet weak var lblSocialConnection: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var specialiseVw: UIView!
    @IBOutlet weak var fnameVw: UIView!
    @IBOutlet weak var phnVw: UIView!
    @IBOutlet weak var ageVw: UIView!
    @IBOutlet weak var lnameVw: UIView!
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var vwCountry: UIView!
    @IBOutlet weak var vwState: UIView!
    @IBOutlet weak var vwCity: UIView!
    @IBOutlet weak var vwZip: UIView!
    @IBOutlet weak var vwStreet: UIView!
    
    @IBOutlet weak var phnNoLbl: UITextField!
    @IBOutlet weak var ageLbl: UITextField!
    @IBOutlet weak var specializationLbl: UITextField!
    @IBOutlet weak var fnameLbl: UITextField!
    @IBOutlet weak var lnameLbl: UITextField!
    @IBOutlet weak var userImagevw: UIImageView!
    @IBOutlet weak var connectntTypTblVw: UITableView!
    @IBOutlet weak var removeDonarBtn: UIButton!
    @IBOutlet weak var locationLbl: UITextField!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfAge: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfCountry: UITextField!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var tfZipCode: UITextField!
    
    var userdetails :NSDictionary = NSDictionary()
    
     let imagePicker = UIImagePickerController()
    
    var fbId: String!
    var gplusId: String!
    var tweeterId: String!
    var linkdinId: String!
    var instagramId: String!
    
    var strCountryId: String = ""
    var strStateId: String = ""
    
   // let conntnType: [String] = ["Connected Via Facebook", "Not Connected Via Twitter", "Not Connected Via Linkedin", "Not Connected Via Instagram"]
    
     let conntnType: [String] = ["Facebook", "Twitter", "Linkedin",  "Instagram", "google Plus"]
    let ImageArr: [String] = ["facebook-1", "twitter-logo", "linkedin-1", "instagram-1", "google-plus"]
     var arrConnectd: [Bool] = [false, false, false, false,false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate=self
        connectntTypTblVw.delegate=self
        connectntTypTblVw.dataSource=self
        connectntTypTblVw.register(UINib(nibName: "ConnectionTypeCell", bundle: Bundle.main), forCellReuseIdentifier: "ConnectionTypeCell")
        userImagevw.layer.cornerRadius = userImagevw.frame.size.height/2
        userImagevw.clipsToBounds = true
        self.setCornerRadious()
        
        let prefs = UserDefaults.standard
        print(prefs.string(forKey: "city") ?? "")
        self.tfFirstName.text = prefs.string(forKey: "FName") ?? ""
        self.tfLastName.text = prefs.string(forKey: "LName") ?? ""
        self.tfPhone.text = prefs.string(forKey: "phoneNumber") ?? ""
        self.tfEmail.text = prefs.string(forKey: "email") ?? ""
        self.tfAddress.text = prefs.string(forKey: "address") ?? ""
        self.tfZipCode.text = prefs.string(forKey: "zipCode") ?? ""
        let city = prefs.string(forKey: "city") ?? ""
        self.tfCity.text = city
        self.tfState.text = prefs.string(forKey: "state") ?? ""
        self.tfCountry.text = prefs.string(forKey: "country") ?? ""
        
        let userImage = prefs.string(forKey: "profileImg") ?? ""
        if userImage != ""
        {
            let getImage = UrlUtil.getUserImage(image: userImage)
            
            userImagevw.sd_setImage(with: URL(string: getImage), placeholderImage: UIImage(named: Default_Image))
        }
        
    }
    func setCornerRadious()
    {
        fnameVw.layer.cornerRadius = 8.0
        lnameVw.layer.cornerRadius = 8.0
        //specialiseVw.layer.cornerRadius = 8.0
        phnVw.layer.cornerRadius = 8.0
        //ageVw.layer.cornerRadius = 8.0
        removeDonarBtn.layer.cornerRadius = 8.0
        
        vwEmail.layer.cornerRadius = 8.0
        vwCountry.layer.cornerRadius = 8.0
        vwState.layer.cornerRadius = 8.0
        vwCity.layer.cornerRadius = 8.0
        vwStreet.layer.cornerRadius = 8.0
        vwZip.layer.cornerRadius = 8.0
    }
    override func viewWillAppear(_ animated: Bool) {
        lblPageTitle.text = "Profile".localized
        lblSocialConnection.text = "Social Connection".localized
        removeDonarBtn.setTitle("Remove DonorPro".localized, for: .normal)
        btnSave.setTitle("Save".localized, for: .normal)
         //self.fetchUserInfo()
       
        
       
       
//        if (getMyData?.imageUrlstr != nil)
//        {
//            self.userImgVw.sd_setImage(with: URL(string: (getMyData?.imageUrlstr!)! ), placeholderImage: UIImage(named: Default_Image))
//        }
    }
    
    func fetchUserInfo()
    {
        /*
        SVProgressHUD.show()
        let userId = UserDefaults.standard.object(forKey: "userId") as? Int ?? 0
        let prmList:[String: Any] = [:]
        let apiName = "user/showprofile?id=" + String(format:"%d",userId)
        let request = MakePostRequest.init(parameterList: prmList, APIName: apiName)
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: User?) in
            SVProgressHUD.dismiss()
            if getMyData != nil
            {
                print("facebok id is",getMyData?.fb_id ?? "")
                self.fbId = getMyData?.fb_id ?? ""
                if (getMyData?.fb_id != nil  && self.fbId != "")
                {
                    self.arrConnectd[0] = true
                }
                else{
                    self.arrConnectd[0] = false
                }
                
                print("twitter id is",getMyData?.twitter_id ?? "")
                self.tweeterId = getMyData?.twitter_id ?? ""
                if (getMyData?.twitter_id != nil  && self.tweeterId != "")
                {
                    self.arrConnectd[1] = true
                }
                else{
                    self.arrConnectd[1] = false
                }
                
                print("instagram id is",getMyData?.instagram_id ?? "")
                self.instagramId = getMyData?.instagram_id ?? ""
                if (getMyData?.instagram_id != nil && self.instagramId != "")
                {
                    self.arrConnectd[3] = true
                }
                else{
                    self.arrConnectd[3] = false
                }
                
                print("linkedin id is",getMyData?.linkedin_id ?? "")
                 self.linkdinId = getMyData?.linkedin_id ?? ""
                if (getMyData?.linkedin_id != nil && self.linkdinId != "")
                {
                    self.arrConnectd[2] = true
                }
                else{
                    self.arrConnectd[2] = false
                }
                
                print("google id is",getMyData?.google_id ?? "")
                 self.gplusId = getMyData?.google_id ?? ""
                if (getMyData?.google_id != nil && self.gplusId != "")
                {
                    self.arrConnectd[4] = true
                }
                else{
                    self.arrConnectd[4] = false
                }
                

                self.connectntTypTblVw.reloadData()
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
        })*/
    }
    
    // MARK: backBtnAction
    
    @IBAction func btnCountryPressed(_ sender: Any)
    {
        let moveViewController = CountryListController()
        self.present(moveViewController, animated: true, completion: nil)
        moveViewController.delegate = self
    }
    @IBAction func btnStatePressed(_ sender: Any)
    {
        if tfCountry.text != nil
        {
            let moveViewController = StateController()
            self.present(moveViewController, animated: true, completion: nil)
            moveViewController.delegate = self
            moveViewController.countryId = strCountryId
        }
        else
        {
            Alert.disPlayAlertMessage(titleMessage: "Sorry!", alertMsg: "Please select any country.")
        }
    }
    @IBAction func btnCityPressed(_ sender: Any)
    {
        if tfState.text != nil
        {
            let moveViewController = CityController()
            moveViewController.delegate = self
            moveViewController.stateId = strStateId
            self.present(moveViewController, animated: true, completion: nil)
            
        }
        else
        {
            Alert.disPlayAlertMessage(titleMessage: "Sorry!", alertMsg: "Please select any state.")
        }
    }
    @IBAction func backBtnAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func removeDonarAction(_ sender: Any) {
        
        
    }
    @IBAction func saveBtnAction(_ sender: Any) {
        let userId = UserDefaults.standard.object(forKey: "userId") ?? ""
        let userBirthDate = UserDefaults.standard.object(forKey: "birthDate") ?? ""
        let userAge = UserDefaults.standard.object(forKey: "age") ?? ""
        let userGender = UserDefaults.standard.object(forKey: "Gender") ?? ""
        
        //let userAddress: [String: Any] = [:]
        
        SVProgressHUD.show()
        let deviceToken = UserDefaults.standard.object(forKey: "pushNotificationID") as? String ?? ""
        let prmList:[String: Any] = ["active":true,"address.address": tfAddress.text ?? "",
                                     "address.addressLine2": "",
                                     "address.city": tfCity.text ?? "",
                                     "address.country": tfCountry.text ?? "",
                                     "address.id": 0,
                                     "address.state": tfState.text ?? "",
                                     "address.userId": userId,
                                     "address.zipCode": tfZipCode.text ?? "","age": userAge,"birthDate": userBirthDate,"createdDate": "","deviceId": deviceToken,"deviceType": "iOS","email": tfEmail.text ?? "","firstname": tfFirstName.text ?? "", "gender":userGender, "id":userId, "isDonor":false, "lastname": tfLastName.text ?? "", "locale": "en", "phoneNumber": tfPhone.text ?? "","userFiles": userImagevw.image ?? ""]
        
        let request = MakePostRequest.init(parameterList: prmList, APIName: "/user/\(userId)/edit?")
        RequestExecutor.uploadRequest(request, completion:{ (error: Error?, getMyData: UserAPIResponse?) in
            
           // self.btnRegister.isUserInteractionEnabled = true
            SVProgressHUD.dismiss()
            if let response = getMyData
            {
                if let userDetails = response.data
                {
                    _ = self.navigationController?.popViewController(animated: true)
                    Validation.saveUserToUserDefaults(userDetails: userDetails)
                    Alert.disPlayAlertMessage(titleMessage: "Success", alertMsg: "Profile updated.")
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
    
    func loadHomePage()
    {
        let moveViewController = HomeController()
        self.navigationController?.pushViewController(moveViewController, animated: true)
    }
    func editProfileImage(pickedimage :UIImage)
    {
        SVProgressHUD.show()
        let userId = UserDefaults.standard.object(forKey: "userId") as? Int ?? 0
        
        let prmList:[String: Any] = ["userid":String(format:"%d",userId),"inputFile":pickedimage]
        let request = MakePostRequest.init(parameterList: prmList, APIName:"/user/uploadProfileImg")
        RequestExecutor.uploadRequest(request, completion:{ (error: Error?, getMyData: User?) in
            SVProgressHUD.dismiss()
            if getMyData != nil
            {
               // Alert.disPlayAlertMessage(titleMessage: "Success", alertMsg: "Profile updated.")
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
    

    
    
    // MARK: TableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConnectionTypeCell", for: indexPath) as! ConnectionTypeCell
       // cell.connectionTypeName.text=self.conntnType[indexPath.row]
      //  cell.connectionLogo?.image=UIImage.init(named: ImageArr[indexPath.row])
//        if arrConnectd[indexPath.row]
//        {
//            cell.connectionTypeName.textColor = UIColor.black
//            cell.switchLogo?.isOn = true
//        }
//        else{
//            cell.connectionTypeName.textColor = UIColor.lightGray
//            cell.switchLogo?.isOn = false
//        }
        
        if arrConnectd[indexPath.row]
        {
            cell.connectionTypeName.text = "Connected Via " +  self.conntnType[indexPath.row]
            cell.connectionTypeName.textColor = UIColor.black
            cell.switchLogo?.isOn = true
            cell.connectionLogo?.image = cell.connectionLogo?.image?.withRenderingMode(.alwaysTemplate)
            cell.connectionLogo?.tintColor =  UIColor (red: 0/255.0, green: 166/255.0, blue: 222/255.0, alpha: 1.0)
            cell.connectionLogo?.image=UIImage.init(named: ImageArr[indexPath.row])
        }
        else{
            cell.connectionTypeName.textColor = UIColor.lightGray
            cell.switchLogo?.isOn = false
            cell.connectionTypeName.text = "Not Connected Via " +  self.conntnType[indexPath.row]
            cell.connectionLogo?.image=UIImage.init(named: ImageArr[indexPath.row])
            cell.connectionTypeName.text =  self.conntnType[indexPath.row]
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    @IBAction func editImageAction(_ sender: Any) {
        self.showActionSheet()
        
    }
    // MARK: showActionSheet
    func showActionSheet() {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Take photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .camera
            self.imagePicker.delegate=self
            self.present(self.imagePicker, animated: true, completion: nil)
            
        })
        let libraryAction = UIAlertAction(title: "Choose existing photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if UIDevice.current.userInterfaceIdiom == .pad {
                self.imagePicker.allowsEditing = true
            } else {
                self.imagePicker.allowsEditing = true
            }
            
            //self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.delegate=self
            self.imagePicker.modalPresentationStyle = .fullScreen
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.imagePicker, animated: true, completion: nil)
            
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(libraryAction)
        optionMenu.addAction(cancelAction)
        
        optionMenu.popoverPresentationController?.sourceView = self.view
        optionMenu.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImage : UIImage!
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            selectedImage = img
        }
        else if let img = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            selectedImage = img
            
        }
        let imageData = UIImageJPEGRepresentation(selectedImage, 0.5)!//UIImagePNGRepresentation(selectedImage)
        userImagevw.image = selectedImage
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        //self.editProfileImage(pickedimage: selectedImage)
        
        
        
}
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK:- textfield delegates
extension EditProfileViewController: UITextFieldDelegate
{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditProfileViewController: CountryPickerViewControllerDelegate {
    func countryPickerViewController(_ countryPickerViewController: CountryPickerViewController, didSelectCountry country: CountryNew)
    {
        dismiss(animated: true, completion: nil)
        tfCountry.text = country.name
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
extension EditProfileViewController:CountryListDelegate
{
    func getCountryDetails(countryId: String, countryName: String,countrySortname: String)
    {
        self.tfCountry.text = countryName
        strCountryId = countryId
        self.tfState.text = ""
        self.tfCity.text = ""
    }
}

// MARK:- City List Delegate
extension EditProfileViewController:CityDelegate
{
    func cityDetails(cityId: String, cityName: String)
    {
        self.tfCity.text = cityName
    }
    
}
// MARK:- State List Delegate
extension EditProfileViewController:StateListDelegate
{
    func getStateDetails(stateId: String, stateName: String)
    {
        self.tfState.text = stateName
        self.strStateId = stateId
        self.tfCity.text = ""
    }
}
