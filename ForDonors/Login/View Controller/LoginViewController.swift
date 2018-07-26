//
//  LoginViewController.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 24/02/18.
//  Copyright © 2018 NATIT Solved Pvt Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import GoogleSignIn
import Crashlytics
import SwiftInstagram

class LoginViewController: UIViewController {

    @IBOutlet var tfView: UIView!
    @IBOutlet var vwEmail: UIView!
    @IBOutlet var vwPassword: UIView!
    @IBOutlet var tfEmail: UITextField!
    @IBOutlet var tfPassword: UITextField!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var vwMain: UIView!
    
    @IBOutlet var vwTransparent: UIView!
    @IBOutlet var vwForgotPassword: UIView!
    @IBOutlet var tfForgotEmail: UITextField!
    @IBOutlet var btnForgotOK: UIButton!
    @IBOutlet var btnForgotCancel: UIButton!
    @IBOutlet var btnRegister: UIButton!
    
    var strUsername = ""
    var strEmail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        vwEmail.layer.borderColor = UIColor.white.cgColor
        vwEmail.layer.borderWidth = 1.0
        vwEmail.clipsToBounds = true
        
        vwPassword.layer.borderColor = UIColor.white.cgColor
        vwPassword.layer.borderWidth = 1.0
        vwPassword.clipsToBounds = true

        
        btnRegister.layer.cornerRadius = 10.0
        btnRegister.layer.borderColor = UIColor.white.cgColor
        btnRegister.layer.borderWidth = 1.0
        btnRegister.clipsToBounds = true
        
        //Lato-Medium
        //MyriadPro-Regular
        
        tfEmail.attributedPlaceholder = NSAttributedString(string:"Username or Email address",
                                                           attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])
        tfEmail.font = UIFont.init(name: "Lato-Medium", size: 15)
        
        tfPassword.attributedPlaceholder = NSAttributedString(string:"Password",
                                                              attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])
        tfPassword.font = UIFont.init(name: "Lato-Medium", size: 15)
        
        btnLogin.layer.cornerRadius = 10.0
        
        vwTransparent.isHidden = true
        vwForgotPassword.isHidden = true
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        if UserDefaults.standard.value(forKey: "userId") != nil
        {
            loadHomePage()
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.statusBarStyle = .lightContent
         print("LoginViewController")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
       
        
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
            forgotPasswordCall(strMailId: tfForgotEmail.text!)
        }
        
    }
    @IBAction func btnForgotCancelPressed(_ sender: Any)
    {
        tfForgotEmail.text = ""
        tfForgotEmail.resignFirstResponder()
        vwTransparent.isHidden = true
        vwForgotPassword.isHidden = true
    }
    
    @IBAction func btnlogin(_ sender: Any)
    {
        //Crashlytics.sharedInstance().crash()
       // let moveViewController = HomeController()
//        let moveViewController = CreateCampaignViewController()
//        self.navigationController?.pushViewController(moveViewController, animated: true)
        
        
        if tfEmail.text == ""
        {
            Alert.disPlayAlertMessage(titleMessage: "Invalid username or email", alertMsg: "Please enter username or email.")
            return
        }
        else
        {
            if(!Validation.isValidEmail(str: tfEmail.text!))
            {
                strUsername = tfEmail.text!
                strEmail = ""
            }
            else
            {
                strEmail = tfEmail.text!
                strUsername = ""
            }
        }
        /*
        if(!Validation.isValidPassword(str: tfPassword.text!))
        {
            Alert.disPlayAlertMessage(titleMessage: "Invalid password", alertMsg: "Password should be min 6 charecters and max 12 charecters.")
            return
        }*/
        self.btnLogin.isUserInteractionEnabled = false
        doLogIn()
    }
    @IBAction func btnFBlogin(_ sender: Any)
    {
        Facebook.fbLogIn(dataReceived: {UserDetails in
            let strName: String!
            let strFbMailId = UserDetails ["email"] as? String ?? ""
            let fbID = UserDetails ["id"] as? String ?? ""
            let strFirstName = UserDetails ["first_name"] as? String ?? ""
            let strLastName = UserDetails ["last_name"] as? String ?? ""
            var strGender = UserDetails ["gender"] as? String ?? ""
            strGender = strGender.firstUppercased
            //let picture: NSDictionary = (UserDetails["picture"] as? NSDictionary)!
            //let data: NSDictionary = (picture["data"] as? NSDictionary)!
            let strImage = "https://graph.facebook.com/" + fbID + "/picture?width=9999"
            
            strName = (strFirstName as String) + " " + (strLastName as String)
            
            let dictToSend = [
                "fbid": fbID as String,
                "name": strName,
                "fname": strFirstName,
                "lname": strLastName,
                "email": strFbMailId as String,
                "dateOfBirth": strFirstName as String,
                "gender": strGender as String,
                "cover_pic": strImage
            ]
            
            self.loadUserExist(userDetails: dictToSend as! [String : String] , loginType: "facebook")
            
            //self.facebookUserExistCheck()
        }, vc: self)
    }
    
    @IBAction func btnGooglelogin(_ sender: Any)
    {
        GIDSignIn.sharedInstance().signIn()
        //Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: "We are on the Way!")
    }
    
    @IBAction func btnLinkedInlogin(_ sender: Any)
    {
        LinkedInAPI.linkedInLogIn(dataReceived: {UserDetails in
            
            let firstName = UserDetails["firstName"]
            let lastName = UserDetails["lastName"]
            let LinkedInId = UserDetails["id"]
            
            let dictToSend = [
                "linkedInId": LinkedInId,
                "fname": firstName,
                "lname": lastName
            ]
            LinkedInAPI.linkedInLogOut()
            self.loadUserExist(userDetails: dictToSend as! [String : String] , loginType: "linkedIn")
        })
    }
    
    @IBAction func btnTwitterlogin(_ sender: Any)
    {
        //Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: "We are on the Way!")
        TwitterAPI.twitterLogIn(dataReceived: {UserDetails in
            
            let firstName = UserDetails ["userName"] as? String ?? ""
            let twitterId = UserDetails ["userID"] as? String ?? ""
            
            let dictToSend = [
                "twitterId": twitterId,
                "fname": firstName,
                ]
            
            self.loadUserExist(userDetails: dictToSend , loginType: "twitter")
            
            TwitterAPI.twitterLogOut()
        })
    }
    
    @IBAction func btnInstagramlogin(_ sender: Any)
    {
        //Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: "Still we are making that functionality, will be avialable soon!")
        
        let newViewController = InstagramLoginVC()
        newViewController.delegate = self
        self.navigationController?.present(newViewController, animated: true, completion: nil)
        
       // Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: "We are on the Way!")
        
        /*InstagramAPI.instagramLogIn(dataReceived: {UserDetails in
            
            let instagramId = UserDetails ["id"] as? String ?? ""
            let fullName = UserDetails ["fullName"] as? String ?? ""
            let profilePicture = UserDetails ["profilePicture"] as? String ?? ""
            let dictToSend = [
                "instagramId": instagramId,
                "fname": fullName,
                "cover_pic": profilePicture
            ]
            self.loadUserExist(userDetails: dictToSend , loginType: "instagram")
            
            InstagramAPI.instagramLogOut()
        }, nvc: self.navigationController!)*/
        
        /*let api = Instagram.shared
        // Login
        api.login(from: self.navigationController! , withScopes: [.basic], success: {
            // Do your stuff here ...
            api.user("self", success: { user in
                print(user)
                let myProf:InstagramUser = user
                
                /*print(myProf.id)
                 print(myProf.username)
                 print(myProf.fullName)
                 print(myProf.bio)
                 print(myProf.profilePicture)
                 print(myProf.website)*/
                
                let dictToSend = [
                    "id": String(format:"%d",myProf.id),
                    "username": myProf.username,
                    "fullName": myProf.fullName,
                    "bio": myProf.bio,
                    "profilePicture": myProf.profilePicture.path,
                    "website": myProf.website
                ]
                
                print(dictToSend)
                
            }, failure:{ error in
                //print(error.localizedDescription)
                Alert.disPlayAlertMessage(titleMessage: "Cannot Proceed", alertMsg: error.localizedDescription)
            })
            
        }, failure: { error in
            Alert.disPlayAlertMessage(titleMessage: "Cannot Proceed", alertMsg: error.localizedDescription)
        })*/
    }
    
    @IBAction func btnRegister(_ sender: Any)
    {
        let newViewController = RegistrationViewController()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
   
    
    
    func facebookUserExistCheck()
    {
        Facebook.fbLogOut()
        loadHomePage()
        
        /*SVProgressHUD.show()
        let deviceToken = UserDefaults.standard.object(forKey: "pushNotificationID") as! String
        let deviceType = "iPhone"
        
        let dict:[String: Any] = [
            "FbId":fbID,
            "Role":"Aspirant",
            "DeviceId":deviceToken,
            "DeviceType":deviceType,
            ]
        
        let request=APIRequest.init(parameterList: dict, APIName: "FacebookLogin")
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: RegisterUser?) in
            SVProgressHUD.dismiss()
            if getMyData != nil
            {
                if getMyData?.IsSuccess == 0
                {
                    let moveViewController = FacebookLoginController()
                    moveViewController.dictToReceive = self.dictToSend
                    self.navigationController?.pushViewController(moveViewController, animated: true)
                }
                else
                {
                    UserDefaults.standard.set("1", forKey:"LoggedInByFB")
                    let user:User = (getMyData?.user)!
                    self.saveUser(user: user)
                    self.loadHomePage()
                }
                
                //Alert.disPlayAlertMessage(titleMessage: "Success", alertMsg: "You have successfully Signed up as an aspirant")
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
                }
                else
                {
                    let err = error as? DDSError
                    let msg:String = err!.description
                    Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: msg)
                }
                
            }
        })*/
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func doLogIn()
    {
        SVProgressHUD.show()
        let deviceToken = UserDefaults.standard.object(forKey: "pushNotificationID") as? String ?? ""
        let prmList:[String: Any] = ["email": strEmail,"password": tfPassword.text!,"deviceType":"iOS","deviceId":deviceToken, "username": strUsername]
        
        
        /*APIManager.sharedInstance.login(prmList: prmList, onSuccess: { (getMyData: UserAPIResponse?) in
            SVProgressHUD.dismiss()
            if let userDetails = getMyData?.data
            {
                Validation.saveUserToUserDefaults(userDetails: userDetails)
                self.loadHomePage()
            }
            else
            {
                let message = getMyData?.message ?? "Some error occured, please try again"
                Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: message)
            }
            self.view.endEditing(true)
            
        }, onFailure: { error in
            
            SVProgressHUD.dismiss()
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
            
        })*/
        
        
        let request = MakePostRequest.init(parameterList: prmList, APIName: "/auth/login")
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: UserAPIResponse?) in
            self.btnLogin.isUserInteractionEnabled = true
            SVProgressHUD.dismiss()
            if let response = getMyData
            {
                if let userDetails = response.data
                {
                    print(userDetails.isVerified)
                    print(userDetails.isBanking)
                    Validation.saveUserToUserDefaults(userDetails: userDetails)
                    self.loadHomePage()
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
    
    func checkValidSocialId(strSocialId: String,userDetails: [String:String],loginType: String)
    {
        SVProgressHUD.show()
        let parameterList:[String: Any] = [:]
        let request=MakeGetRequest.init(parameterList: parameterList, APIName: String(format:"/auth/social?appId=%@",strSocialId))
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: SocialCheckResponse?) in
            SVProgressHUD.dismiss()
            if let myData = getMyData
            {
                if myData.data == false
                {
                    let moveViewController = RegistrationViewController()
                    moveViewController.userDetails = userDetails
                    moveViewController.signUpBy = loginType
                    self.navigationController?.pushViewController(moveViewController, animated: true)
                }
                else
                {
                    Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: "User already exist, please try to login with username/email and password")
                }
                
            }
            
            else
            {
                
                if let err = error as? URLError, err.code == .notConnectedToInternet
                {
                    // no internet connection
                    //print(err)
                    if let vc = UIApplication.topViewController()
                    {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            Validation.showTransparentWindow(sender: vc, strMsg: "No Internet Connection!")
                        }
                    }
                }
                else
                {
                    let err = error as? DDSError
                    let msg:String = err!.description
                    Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: msg)
                }
                
                
                
                
            }
        })
    }
    func forgotPasswordCall(strMailId: String)
    {
        SVProgressHUD.show()
        let parameterList:[String: Any] = [:]
        let request=MakePostRequest.init(parameterList: parameterList, APIName: String(format:"/auth/forgetpswd?email=%@",strMailId))
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: ForgotPasswordResponse?) in
            SVProgressHUD.dismiss()
            if getMyData != nil
            {
                if getMyData?.status == "200" //&& getMyData?.data != nil
                {
                    self.tfForgotEmail.text = ""
                    self.tfForgotEmail.resignFirstResponder()
                    self.vwTransparent.isHidden = true
                    self.vwForgotPassword.isHidden = true
                    Alert.disPlayAlertMessage(titleMessage: "Sorry!", alertMsg: (getMyData?.message)!)
                }
                else
                {
                    Alert.disPlayAlertMessage(titleMessage: "Sorry!", alertMsg: (getMyData?.message)!)
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
                    let err = error as? DDSError
                     let msg:String = err!.description
                     Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: msg)
                }
                
                
                
                
            }
        })
    }
    func loadHomePage()
    {
        //let moveViewController = ProfileViewController()
        //self.navigationController?.pushViewController(moveViewController, animated: true)

        
        let vc =  HomeController()
        self.navigationController?.pushViewController(vc, animated: true)
        vc.fromSignUp = false
        /*let moveViewController = HomeController()
        self.navigationController?.pushViewController(moveViewController, animated: true)*/
    }
    
    func loadUserExist(userDetails: [String:String],loginType: String)
    {
        var socialId = ""
        if loginType == "twitter"
        {
            socialId = userDetails["twitterId"]!
        }
        else if loginType == "instagram"
        {
            socialId = userDetails["instagramId"]!
        }
        else if loginType == "linkedIn"
        {
            socialId = userDetails["linkedInId"]!
        }
        else if loginType == "googleplus"
        {
            socialId = userDetails["googleId"]!
        }
        else if loginType == "facebook"
        {
            socialId = userDetails["fbid"]!
        }
        self.checkValidSocialId(strSocialId: socialId, userDetails: userDetails, loginType: loginType)
    }

}
extension LoginViewController:UITextFieldDelegate
{
    // MARK: - UITextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if (textField==tfPassword ) {
            
            scrollView.contentSize = CGSize(width: vwMain.frame.size.width, height: vwMain.frame.size.height+100)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (textField==tfPassword ) {
            
            scrollView.contentSize = CGSize(width: vwMain.frame.size.width, height: vwMain.frame.size.height)
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
        
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder();
        return true;
    }
}
extension LoginViewController:GIDSignInDelegate
{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            //let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
            
            let dictToSend = [
                "googleId": userId,
                "authId": idToken,
                "fname": givenName,
                "lname": familyName,
                "email": email
            ]
            
            self.loadUserExist(userDetails: dictToSend as! [String : String] , loginType: "googleplus")
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}
extension LoginViewController:GIDSignInUIDelegate
{
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        //myActivityIndicator.stopAnimating()
        SVProgressHUD.dismiss()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
}
//Instagram Login Vc Delegate
extension LoginViewController:InstagramLoginVCDelegate
{
    func instagramUser(instagramUser: [String:Any])
    {
        let instagramId = instagramUser ["id"] as? String ?? ""
        let fullName = instagramUser ["fullName"] as? String ?? ""
        let profilePicture = instagramUser ["profilePicture"] as? String ?? ""
        let dictToSend = [
            "instagramId": instagramId,
            "fname": fullName,
            "cover_pic": profilePicture
        ]
        self.loadUserExist(userDetails: dictToSend , loginType: "instagram")
    }
}
