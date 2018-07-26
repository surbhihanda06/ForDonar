//
//  Alert.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 23/02/18.
//  Copyright © 2018 NATIT Solved Pvt Ltd. All rights reserved.
//

import Foundation
import UIKit
class Alert
{
    internal static var alertMessageController:UIAlertController!
    
    /// To display alert message
    ///
    /// - Parameters:
    ///   - titleMessage: Used to show title
    ///   - alertMsg: Used to show message
    internal static func disPlayAlertMessage(titleMessage:String, alertMsg:String)
    {
        Alert.alertMessageController = UIAlertController(title: titleMessage, message:
            alertMsg, preferredStyle: UIAlertControllerStyle.alert)
        
        Alert.alertMessageController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        /*if (UIApplication.shared.keyWindow?.rootViewController?.presentedViewController) != nil {
            //controller.present(Alert.alertMessageController, animated: true, completion: nil)
            UIApplication.shared.delegate?.window!!.rootViewController?.present(Alert.alertMessageController, animated: true, completion: nil)
        }
        else{
            UIApplication.shared.delegate?.window!!.rootViewController?.present(Alert.alertMessageController, animated: true, completion: nil)
        }*/
        
        if let controller = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController {
            controller.present(Alert.alertMessageController, animated: true, completion: nil)
        }
        else
        {
            UIApplication.shared.delegate?.window!!.rootViewController?.present(Alert.alertMessageController, animated: true, completion: nil)
        }
        return
    }
    
    
    /// To display an alert view with title and message
    ///
    /// - Parameters:
    ///   - titleMessage: Used to show the title
    ///   - alertMsg: Used to show the message
    ///   - dataReceived: Data which is received
    
    
    
    internal static func disPlayAlertMessage(titleMessage:String, alertMsg:String, dataReceived: ((String)->Void)?)
    {
        Alert.alertMessageController = UIAlertController(title: titleMessage, message:
            alertMsg, preferredStyle: UIAlertControllerStyle.alert)
        
        
        let saveAction = UIAlertAction(title: "Ok", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = Alert.alertMessageController.textFields![0] as UITextField
            
            if let callback = dataReceived {
                callback(firstTextField.text!)
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        Alert.alertMessageController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter your mail id"
        }
        
        Alert.alertMessageController.addAction(saveAction)
        Alert.alertMessageController.addAction(cancelAction)
        
        if let controller = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController {
            controller.present(Alert.alertMessageController, animated: true, completion: nil)
        }
        else{
            UIApplication.shared.delegate?.window!!.rootViewController?.present(Alert.alertMessageController, animated: true, completion: nil)
        }
        return
    }
}
