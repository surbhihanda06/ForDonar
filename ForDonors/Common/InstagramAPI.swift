//
//  InstagramAPI.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 14/03/18.
//  Copyright © 2018 NATIT Solved Pvt Ltd. All rights reserved.
//

import Foundation
import SwiftInstagram

class InstagramAPI
{
    /// To receive facebook logged in user details
    ///
    /// - Parameter dataReceived: To get user data
    static func instagramLogIn(dataReceived: (([String: Any])->Void)?, nvc:UINavigationController)
    {
        let api = Instagram.shared
        // Login
        api.login(from: nvc , withScopes: [.basic], success: {
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
                
                if let callback = dataReceived {
                    callback(dictToSend as Any as! [String : Any])
                }
                
            }, failure:{ error in
                print(error.localizedDescription)
                Alert.disPlayAlertMessage(titleMessage: "Cannot Proceed", alertMsg: error.localizedDescription)
            })
            
        }, failure: { error in
            print(error.localizedDescription)
            Alert.disPlayAlertMessage(titleMessage: "Cannot Proceed", alertMsg: error.localizedDescription)
        })
    }
    static func instagramLogOut()
    {
        let api = Instagram.shared
        let bAuth = api.isAuthenticated
        if(bAuth)
        {
            // Logout
            api.logout()
        }
    }

}
