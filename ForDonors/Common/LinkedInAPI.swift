//
//  LinkedInAPI.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 15/03/18.
//  Copyright © 2018 NATIT Solved Pvt Ltd. All rights reserved.
//

import Foundation
import LinkedinSwift

class LinkedInAPI
{
    /// To receive facebook logged in user details
    ///
    /// - Parameter dataReceived: To get user data
    static let linkedinHelper = LinkedinSwiftHelper(configuration:
        LinkedinSwiftConfiguration(clientId: "78nffphp42akfw", clientSecret: "XsnzMlzLAKNCY42k", state: "DLKDJF45DIWOERCM", permissions: ["r_basicprofile", "r_emailaddress"], redirectUrl: "http://localhost:3000/auth/linkedin/callback"))
    
    static func linkedInLogIn(dataReceived: (([String: Any])->Void)?)
    {
        linkedinHelper.authorizeSuccess({ (lsToken) -> Void in
        //Login success lsToken
        
        print(lsToken)
        
        self.linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~?format=json",
        requestType: LinkedinSwiftRequestGet,
        success: { (response) -> Void in
        
        //Request success response
        print(response.jsonObject)
        
        let myLinkedIndata = response.jsonObject!
        
        let firstName = myLinkedIndata["firstName"] as? String ?? ""
        let lastName = myLinkedIndata["lastName"] as? String ?? ""
        let LinkedInId = myLinkedIndata["id"] as? String ?? ""
        let headline = myLinkedIndata["headline"] as? String ?? ""
        
        let dictToSend = [
        "id": LinkedInId,
        "firstName": firstName,
        "lastName": lastName,
        "headline": headline
        ]
            if let callback = dataReceived {
                callback(dictToSend as Any as! [String : Any])
            }
            
        }) { (error) -> Void in
        
        //Encounter error
            //Alert.disPlayAlertMessage(titleMessage: "Cannot Proceed", alertMsg: error?.localizedDescription ?? "No error desciption")
        }
        
        }, error: { (error) -> Void in
        //Encounter error: error.localizedDescription
            //Alert.disPlayAlertMessage(titleMessage: "Cannot Proceed", alertMsg: error?.localizedDescription ?? "No error desciption")
        }, cancel: { () -> Void in
        //User Cancelled!
        })
        
    }
    
    //https://api.linkedin.com/uas/oauth/invalidateToken
    static func linkedInLogOut()
    {
        self.linkedinHelper.requestURL("https://api.linkedin.com/uas/oauth/invalidateToken",
                                       requestType: LinkedinSwiftRequestGet,
                                       success: { (response) -> Void in
                                        
                                        //Request success response
                                        print(response.jsonObject)
                                        
                                        /*let myLinkedIndata: [String:String] = response.jsonObject as! [String : String]
                                         
                                         let firstName = myLinkedIndata["firstName"]
                                         let lastName = myLinkedIndata["lastName"]
                                         let LinkedInId = myLinkedIndata["id"]
                                         
                                         let dictToSend = [
                                         "linkedInId": LinkedInId,
                                         "fname": firstName,
                                         "lname": lastName
                                         ]
                                         if let callback = dataReceived {
                                         callback(dictToSend as Any as! [String : Any])
                                         }*/
                                        
        }) { (error) -> Void in
            
            //[unowned self] (error) -> Void
            //print(error?.localizedDescription ?? "No error desciption")
            //Encounter error
           // Alert.disPlayAlertMessage(titleMessage: "Cannot Proceed", alertMsg: error?.localizedDescription ?? "No error desciption")
        }
        
    }

}
