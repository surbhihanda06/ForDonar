//
//  TwitterAPI.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 15/03/18.
//  Copyright © 2018 NATIT Solved Pvt Ltd. All rights reserved.
//

import Foundation
import TwitterKit

class TwitterAPI
{
    /// To receive facebook logged in user details
    ///
    /// - Parameter dataReceived: To get user data
    static func twitterLogIn(dataReceived: (([String: Any])->Void)?)
    {
        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                print("signed in as \(session?.userName ?? "")");
                let userName = session?.userName
                let userID = session?.userID
                let authToken = session?.authToken
                let authTokenSecret = session?.authTokenSecret
                
                let dictToSend = [
                    "userName": userName,
                    "userID": userID,
                    "authToken": authToken,
                    "authTokenSecret": authTokenSecret
                    ]
                if let callback = dataReceived {
                    callback(dictToSend as Any as! [String : Any])
                }
                
            } else {
                //print("error: \(error?.localizedDescription ?? "No error desk")");
                
                Alert.disPlayAlertMessage(titleMessage: "Cannot Proceed", alertMsg: error?.localizedDescription ?? "No error desciption")
            }
        })
    }
    static func twitterLogOut()
    {
        let store = TWTRTwitter.sharedInstance().sessionStore
        if let userID = store.session()?.userID {
            store.logOutUserID(userID)
        }
    }

}
