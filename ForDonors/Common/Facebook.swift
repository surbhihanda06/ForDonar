//
//  Facebook.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 23/02/18.
//  Copyright © 2018 NATIT Solved Pvt Ltd. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class Facebook
{
    /// To receive facebook logged in user details
    ///
    /// - Parameter dataReceived: To get user data
    static func fbLogIn(dataReceived: (([String: Any])->Void)?, vc:UIViewController)
    {
        let login = FBSDKLoginManager()
        let systemVersion:String = UIDevice.current.systemVersion
        if systemVersion.floatValue <= 9.0
        {
            login.loginBehavior = FBSDKLoginBehavior.systemAccount
        }
        else
        {
            login.loginBehavior = FBSDKLoginBehavior.web
        }
        
        login.logIn(withReadPermissions: ["public_profile","email", "user_birthday"], from: vc, handler: { (result, error) -> Void in
            
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                
                if(fbloginresult.isCancelled)
                {
                    //Alert.disPlayAlertMessage(titleMessage: "Cannot Proceed", alertMsg: "There are some unknown error occurred logging in with facebook. Please try again")
                }
                else if(fbloginresult.grantedPermissions.contains("email")) {
                    let strAccessToken = FBSDKAccessToken.current().tokenString as NSString
                    if((FBSDKAccessToken.current()) != nil){
                        _ = FBSDKAccessToken.current().tokenString as NSString
                        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, gender, picture, birthday, location"]).start(completionHandler: { (connection, result, error) -> Void in
                            if (error == nil)
                            {
                                var UserDetails: [String: Any] = result as! [String: Any]
                                print(UserDetails)
                                UserDetails["accessToken"] = strAccessToken as String
                                if let callback = dataReceived {
                                    callback(UserDetails)
                                }
                            }
                            else
                            {
                                Alert.disPlayAlertMessage(titleMessage: "Cannot Proceed", alertMsg: "There are some unknown error occurred logging in with facebook. Please try again")
                            }
                        })
                    }
                }
            }
        })
    }
    static func fbLogOut()
    {
        let manager = FBSDKLoginManager()
        manager.logOut()
    }

}
