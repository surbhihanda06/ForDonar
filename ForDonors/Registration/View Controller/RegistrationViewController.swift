//
//  RegistrationViewController.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 26/02/18.
//  Copyright © 2018 NATIT Solved Pvt Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD

class RegistrationViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet var tfView: UIView!
    @IBOutlet weak var vwImage: UIView!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet var vwFirstName: UIView!
    @IBOutlet var tfFirstName: UITextField!
    @IBOutlet var vwLastName: UIView!
    @IBOutlet var tfLastName: UITextField!
    @IBOutlet var vwUserName: UIView!
    @IBOutlet var tfUsername: UITextField!
    @IBOutlet var vwEmail: UIView!
    @IBOutlet var tfEmail: UITextField!
    @IBOutlet var vwPhone: UIView!
    @IBOutlet var vwCountry: UIView!
    @IBOutlet var tfCountry: UITextField!
    @IBOutlet var vwStreet: UIView!
    @IBOutlet var tfStreet: UITextField!
    @IBOutlet var vwCity: UIView!
    @IBOutlet var tfCity: UITextField!
    @IBOutlet var vwState: UIView!
    @IBOutlet var tfState: UITextField!
    @IBOutlet weak var vwAccountType: UIView!
    @IBOutlet weak var tfAccountType: UITextField!
    @IBOutlet var vwPostal: UIView!
    @IBOutlet var tfPostal: UITextField!
    @IBOutlet var vwPassword: UIView!
    @IBOutlet var tfPassword: UITextField!
    @IBOutlet var vwDateOfBirth: UIView!
    @IBOutlet var tfDateOfBirth: UITextField!
    @IBOutlet var vwGender: UIView!
    @IBOutlet var tfGender: UITextField!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var vwMain: UIView!
    @IBOutlet weak var imgVwCheck: UIImageView!
    @IBOutlet weak var vwCheck: UIView!
    
    @IBOutlet var vwTransparent: UIView!
    @IBOutlet var vwForgotPassword: UIView!
    @IBOutlet var tfForgotEmail: UITextField!
    @IBOutlet var btnForgotOK: UIButton!
    @IBOutlet var btnForgotCancel: UIButton!
    @IBOutlet var btnRegister: UIButton!
    
    @IBOutlet weak var tfPhone: NKVPhonePickerTextField!
    var pkrvw: UIPickerView = UIPickerView()
    let pickOption = ["Male", "Female", "Other"]
    var pkrvwAccountType: UIPickerView = UIPickerView()
    let pickOptionAccountType: [[String: Any]] = [["type":"individual", "id":1],["type":"organization", "id":2]]
    var selectedUserType: Int = 0
    var signUpBy:String = "normal"
    var userDetails: [String:String]!
    
    let imagePicker = UIImagePickerController()
    
    var countries = [CountryDetails]()
    var phone: String = ""
    
    var isValidUser: Bool = false
    var tmrUsrValidChk = Timer()
    var strCountryId: String = ""
    var strStateId: String = ""
    
    let borderColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imgVwUser.layer.masksToBounds = true
        imgVwUser.layer.cornerRadius = imgVwUser.frame.size.height / 2
        
        vwImage.layer.masksToBounds = true
        vwImage.layer.cornerRadius = vwImage.frame.size.height / 2
        vwImage.layer.borderWidth = 1
        vwImage.layer.borderColor = UIColor.lightGray.cgColor
        
        vwCheck.layer.masksToBounds = true
        vwCheck.layer.cornerRadius = 2
        
        self.setViewBorder(vw: vwFirstName)
        self.setViewBorder(vw: vwLastName)
        self.setViewBorder(vw: vwUserName)
        self.setViewBorder(vw: vwEmail)
        self.setViewBorder(vw: vwPhone)
        self.setViewBorder(vw: vwGender)
        self.setViewBorder(vw: vwDateOfBirth)
        self.setViewBorder(vw: vwCountry)
        self.setViewBorder(vw: vwGender)
        self.setViewBorder(vw: vwDateOfBirth)
        self.setViewBorder(vw: vwCountry)
        self.setViewBorder(vw: vwStreet)
        self.setViewBorder(vw: vwCity)
        self.setViewBorder(vw: vwState)
        self.setViewBorder(vw: vwPostal)
        self.setViewBorder(vw: vwPassword)
        self.setViewBorder(vw: vwAccountType)

        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            tfCountry.text = countryName(countryCode: countryCode)
        }
        countryList()
        pkrvw.delegate = self
        pkrvwAccountType.delegate = self
        tfGender.inputView = pkrvw
        tfAccountType.inputView = pkrvwAccountType
        
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        tfDateOfBirth.inputView = datePickerView
        datePickerView.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        datePickerView.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        if UserDefaults.standard.value(forKey: "userId") != nil
        {
            loadHomePage()
        }
        
        if signUpBy == "twitter"
        {
            tfFirstName.text = userDetails["fname"]
            let image = userDetails["cover_pic"] ?? ""
            imgVwUser.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: Default_Image))
        }
        else if signUpBy == "instagram"
        {
            tfFirstName.text = userDetails["fname"]
            let image = userDetails["cover_pic"] ?? ""
            imgVwUser.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: Default_Image))
        }
        else if signUpBy == "linkedIn"
        {
            tfFirstName.text = userDetails["fname"]
            tfLastName.text = userDetails["lname"]
            let image = userDetails["cover_pic"] ?? ""
            imgVwUser.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: Default_Image))
        }
        else if signUpBy == "googleplus"
        {
            tfFirstName.text = userDetails["fname"]
            tfLastName.text = userDetails["lname"]
            tfEmail.text = userDetails["email"]
            let image = userDetails["cover_pic"] ?? ""
            imgVwUser.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: Default_Image))
        }
        else if signUpBy == "facebook"
        {
            tfFirstName.text = userDetails["fname"]
            tfLastName.text = userDetails["lname"]
            tfEmail.text = userDetails["email"]
            let image = userDetails["cover_pic"] ?? ""
            imgVwUser.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: Default_Image))
            
        }
        else
        {
            
        }
        
        
        // Mark :-  Country code fetch Aritri
        tfPhone.phonePickerDelegate = self
        tfPhone.favoriteCountriesLocaleIdentifiers = ["RU", "ER", "JM"]
        
        let swiftLocale: Locale = Locale.current
        let swiftCountry: String? = swiftLocale.regionCode
        
        // Setting initial custom country
        let country = Country.country(for: NKVSource(countryCode: swiftCountry!))
        tfPhone.country = country
        
        // Setting custom format pattern for some countries
        tfPhone.customPhoneFormats = ["RU" : "# ### ### ## ##",
                                           "IN": "## #### #########"]
        
        // For keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    //Mark :- Country List fetch ARITRI
    
    func countryName(countryCode: String) -> String? {
        let current = Locale(identifier: "en_US")
        return current.localizedString(forRegionCode: countryCode) ?? nil
    }
    
    func setViewBorder(vw: UIView)
    {
        vw.layer.borderColor = borderColor.cgColor
        vw.layer.borderWidth = 1.0
        vw.clipsToBounds = true
    }
    
    @objc func genderDoneClick()
    {
        //your code when clicked on done
        
        let row = pkrvw.selectedRow(inComponent: 0) == -1 ? 0 : pkrvw.selectedRow(inComponent: 0)
        self.tfGender.text = pickOption[row]
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
    
    @IBAction func selectCountryBtn(_ sender: Any) {
        let moveViewController = CountryListController()
        self.present(moveViewController, animated: true, completion: nil)
        moveViewController.delegate = self
        
        
        /*
        let viewController = CountryPickerViewController()
        viewController.delegate = self as? CountryPickerViewControllerDelegate

        print("The current country is \(viewController.currentCountry)")

        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
 */
    }
    //
    
    // MARK: - Keyboard handling
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    //
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.statusBarStyle = .lightContent
         print("LoginViewController")
        //tfGender.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(genderDoneClick))
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

    // MARK: - Action
    
    @IBAction func btnBackPressed(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnForgotPwd(_ sender: Any)
    {
        vwTransparent.superview?.bringSubview(toFront: vwTransparent)
        vwForgotPassword.superview?.bringSubview(toFront: vwForgotPassword)
        vwTransparent.isHidden = false
        vwForgotPassword.isHidden = false
    }
    @IBAction func btnForgotOKPressed(_ sender: Any)
    {
        if(!Validation.isValidEmail(str: tfForgotEmail.text!))
        {
            Alert.disPlayAlertMessage(titleMessage: "Invalid email", alertMsg: "Please try with valid email.")
        }
        else
        {
            checkValidEmail()
        }
        
    }
    @IBAction func btnAgreementPressed(_ sender: UIButton)
    {
        if sender.tag == 0
        {
            sender.tag = 1
            imgVwCheck.image = UIImage(named: "tick")
        }
        else
        {
            sender.tag = 0
            imgVwCheck.image = UIImage(named: "")
        }
    }
    @IBAction func btnForgotCancelPressed(_ sender: Any)
    {
        tfForgotEmail.text = ""
        tfForgotEmail.resignFirstResponder()
        vwTransparent.isHidden = true
        vwForgotPassword.isHidden = true
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateOnlyFormat
//        let now = Date()
//        let birthday: Date = sender.date
//        let calendar = Calendar.current
        
        //let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        //let age = ageComponents.year!
        //tfDateOfBirth.text = String(age)
        tfDateOfBirth.text = dateFormatter.string(from: sender.date)
    }
    @IBAction func btnImagePressed(_ sender: Any)
    {
        self.showActionSheet()
    }
    
    func startTimer()
    {
        //guard tmrUsrValidChk == nil else { return }
        if tmrUsrValidChk.isValid
        {
            tmrUsrValidChk.invalidate()
        }
        tmrUsrValidChk = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireUserCheckingService), userInfo: nil, repeats: false)
    }
    
    func stopTimer() {
        //guard tmrUsrValidChk != nil else { return }
        tmrUsrValidChk.invalidate()
    }
    
    @objc func fireUserCheckingService() {
        self.userNameCheck()
    }
    
    @IBAction func btnRegister(_ sender: Any)
    {
        phone = (tfPhone.phoneNumber)!
        let code = (tfPhone.code)!
        phone = phone.replacingOccurrences(of: code, with: "", options: NSString.CompareOptions.literal, range: nil)
        print(phone)
        if(!Validation.isValidName(str: tfFirstName.text!))
        {
            Alert.disPlayAlertMessage(titleMessage: "Invalid first name", alertMsg: "Please try with valid first name.")
        }
        else if(!Validation.isValidName(str: tfLastName.text!))
        {
            Alert.disPlayAlertMessage(titleMessage: "Invalid last name", alertMsg: "Please try with valid last name.")
        }
        else if tfUsername.text == ""
        {
            Alert.disPlayAlertMessage(titleMessage: "Username", alertMsg: "Please enter username.")
        }
        else if !isValidUser
        {
            Alert.disPlayAlertMessage(titleMessage: "Invalid Username", alertMsg: "Please try with different username.")
        }
        else if(!Validation.isValidEmail(str: tfEmail.text!))
        {
            Alert.disPlayAlertMessage(titleMessage: "Invalid email", alertMsg: "Please try with valid email.")
        }
        else if phone == ""
        {
            Alert.disPlayAlertMessage(titleMessage: "Phone Number", alertMsg: "Please enter Phone number.")
        }
        else if tfDateOfBirth.text == ""
        {
            Alert.disPlayAlertMessage(titleMessage: "Date of Birth", alertMsg: "Please enter Date of Birth.")
        }
        else if tfGender.text == ""
        {
            Alert.disPlayAlertMessage(titleMessage: "Gender", alertMsg: "Please enter gender.")
        }
        else if(!Validation.isValidPassword(str: tfPassword.text!))
        {
            Alert.disPlayAlertMessage(titleMessage: "Invalid password", alertMsg: "Password should be min 6 charecters and max 12 charecters.")
        }
        else if(selectedUserType == 0)
        {
            Alert.disPlayAlertMessage(titleMessage: "Account Type", alertMsg: "Please select the account type.")
        }
        else if (self.imgVwCheck.image == nil){
            Alert.disPlayAlertMessage(titleMessage: "Sorry!", alertMsg: "Please accept all terms & conditions.")
        }
        else
        {
            self.btnRegister.isUserInteractionEnabled = false
            doRegister()
        }
        
    }
    
    func userNameCheck()
    {
        let tempUserName:String = tfUsername.text ?? ""
        if tempUserName.count == 0
        {
            return
        }
        SVProgressHUD.show()
        let prmList:[String: Any] = [:]
        let apiname = "/auth/username/check?username=" + tempUserName
        let request = MakeGetRequest.init(parameterList: prmList, APIName: apiname)
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: UserNameCheckResponse?) in
            SVProgressHUD.dismiss()
            if getMyData != nil
            {
                if getMyData?.data == false
                {
                    self.btnRegister.isUserInteractionEnabled = true
                    self.isValidUser = true
                    
                    self.vwUserName.layer.borderColor = self.borderColor.cgColor
                    self.vwUserName.layer.borderWidth = 1.0
                    self.vwUserName.clipsToBounds = true
                }
                
                
                //self.view.endEditing(true)
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
    
    func doRegister()
    {
        SVProgressHUD.show()
        //let deviceToken = UserDefaults.standard.object(forKey: "pushNotificationID") as? String ?? ""
        var socialId = ""
        
        if signUpBy == "twitter"
        {
            socialId = userDetails["twitterId"]!
        }
        else if signUpBy == "instagram"
        {
            socialId = userDetails["instagramId"]!
        }
        else if signUpBy == "linkedIn"
        {
            socialId = userDetails["linkedInId"]!
        }
        else if signUpBy == "googleplus"
        {
            socialId = userDetails["googleId"]!
        }
        else if signUpBy == "facebook"
        {
            socialId = userDetails["fbid"]!
        }
        /*let dicSocial:[[String: Any]] = [["appId": socialId,
                                       "authToken": "",
                                       "type": signUpBy]]
        
        let dicUserAuth:[String: Any] = ["email": tfEmail.text!,
                                         "userAuth.password": tfPassword.text!,
                                         "userAuth.username": tfUsername.text!]
        
        let dicAddress:[String: Any] = ["active": false,
                                        "address.address": tfStreet.text!,
                                        "address.city": tfCity.text!,
                                        "address.country": tfCountry.text!,
                                        "address.state": tfState.text!,
                                        "address.zipCode": tfPostal.text!]
        
        let strDateOfBirth = tfDateOfBirth.text!
        let prmList1:[String: Any] = ["active": true,"address":dicAddress,"birthDate":strDateOfBirth,"deviceId":"","deviceType":"ios","email": tfEmail.text!,"firstname":tfFirstName.text!,"lastname":tfLastName.text!,"phoneNumber": tfPhone.text!,"profileImg": "","socialAccounts": dicSocial,"gender":tfGender.text!,"userAuth": dicUserAuth,"username": tfUsername.text!]*/
        
        tfPhone.phoneNumber
        
        let prmList:[String: Any] = ["firstname":tfFirstName.text!, "lastname":tfLastName.text!, "email": tfEmail.text!, "phoneNumber": tfPhone.text!, "gender":tfGender.text!, "birthDate":tfDateOfBirth.text!,"address.address": tfStreet.text!, "address.city": tfCity.text!, "address.country": tfCountry.text!, "address.state": tfState.text!,  "address.zipCode": tfPostal.text!, "userAuth.username": tfUsername.text!, "userAuth.password": tfPassword.text!,"type": selectedUserType,"file": imgVwUser.image ?? ""]
        
        let request = MakePostRequest.init(parameterList: prmList, APIName: "/user/add")
        RequestExecutor.uploadRequest(request, completion:{ (error: Error?, getMyData: UserAPIResponse?) in
            
            self.btnRegister.isUserInteractionEnabled = true
            SVProgressHUD.dismiss()
            if let response = getMyData
            {
                if let userDetails = response.data
                {
                    Validation.saveUserToUserDefaults(userDetails: userDetails)
                    //let vc =  HomeController()
                    //self.navigationController?.pushViewController(vc, animated: false)
                    //vc.fromSignUp = true
                    
                    let vc = VerificationController()
                    self.present(vc, animated: false, completion: nil)
                    vc.fromPage = "SignUp"
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
    
    func checkValidEmail()
    {
        /*SVProgressHUD.show()
        let parameterList:[String: Any] = ["Id": tfForgotEmail.text!]
        let request=MailCheckRequest.init(parameterList: parameterList, APIName: "MailExistOrNotForForgotPassword")
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: MailExistReply?) in
            SVProgressHUD.dismiss()
            if getMyData != nil
            {
                let newViewController = ForgotPassOTPVC()
                newViewController.email = self.tfForgotEmail.text!
                self.navigationController?.pushViewController(newViewController, animated: true)
                
                self.tfForgotEmail.resignFirstResponder()
                self.tfForgotEmail.text = ""
                self.vwTransparent.isHidden = true
                self.vwForgotPassword.isHidden = true
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
                    let err = error as? DDSError
                    let msg:String = err!.description
                    Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: msg)
                }
                
                
                
                
            }
        })*/
    }
    func loadHomePage()
    {
        let moveViewController = HomeController()
        self.navigationController?.pushViewController(moveViewController, animated: true)
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
        imgVwUser.image = selectedImage
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
    
    func countryList()
    {
        //let deviceToken = UserDefaults.standard.object(forKey: "pushNotificationID") as? String ?? ""
        let prmList:[String: Any] = [:]
        let request = MakeGetRequest.init(parameterList: prmList, APIName: "/country")
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: CountryAPIResponse?) in
            if getMyData != nil
            {
                if getMyData?.status == "200" && getMyData?.data != nil
                {
                    self.countries = (getMyData?.data)!
                    for index in 0..<self.countries.count
                    {
                        let details = self.countries[index]
                        let countryName = details.name
                        if self.tfCountry.text != ""
                        {
                            if self.tfCountry.text == countryName
                            {
                                self.strCountryId = String(format:"%d",details.countryId)
                            }
                        }
                    }
                }
                else
                {
                    
                }
                
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
                        
                    }
                    
                }
            }
        })
    }
    
}

//Mark :- Country List fetch
extension RegistrationViewController: CountryPickerViewControllerDelegate {
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
// MARK: - PickerView Datasource and Delegates
extension RegistrationViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView == pkrvw
        {
            return pickOption.count
        }
        else
        {
            return pickOptionAccountType.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView == pkrvw
        {
            return pickOption[row]
        }
        else
        {
            let details = pickOptionAccountType[row]
            return details["type"] as? String
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == pkrvw
        {
            self.tfGender.text = pickOption[row]
        }
        else
        {
            let details = pickOptionAccountType[row]
            let title = details["type"] as? String
            self.tfAccountType.text = title
            selectedUserType = details["id"] as! Int
        }
    }
}

// MARK: - UITextField Delegates
extension RegistrationViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if (textField==tfPassword ) {
            
            scrollView.contentSize = CGSize(width: vwMain.frame.size.width, height: vwMain.frame.size.height+100)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (textField==tfPassword ) {
            
            scrollView.contentSize = CGSize(width: vwMain.frame.size.width, height: vwMain.frame.size.height)
        }
        else if (textField==tfUsername ) {
            
            userNameCheck()
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField==tfUsername )
        {
            self.isValidUser = false
            self.btnRegister.isUserInteractionEnabled = false
            self.vwUserName.layer.borderColor = UIColor.red.cgColor
            self.vwUserName.layer.borderWidth = 1.0
            self.vwUserName.clipsToBounds = true
            
            self.startTimer()
        }
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}
// MARK:- Country List Delegate
extension RegistrationViewController:CountryListDelegate
{
    func getCountryDetails(countryId: String, countryName: String, countrySortname: String)
    {
        self.tfCountry.text = countryName
        strCountryId = countryId
        self.tfState.text = ""
        self.tfCity.text = ""
    }
}
// MARK:- City List Delegate
extension RegistrationViewController:CityDelegate
{
    func cityDetails(cityId: String, cityName: String)
    {
        self.tfCity.text = cityName
    }
    
}
// MARK:- State List Delegate
extension RegistrationViewController:StateListDelegate
{
    func getStateDetails(stateId: String, stateName: String)
    {
        self.tfState.text = stateName
        self.strStateId = stateId
        self.tfCity.text = ""
    }
}

//

