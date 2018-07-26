//
//  Validation.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 23/02/18.
//  Copyright © 2018 NATIT Solved Pvt Ltd. All rights reserved.
//

import Foundation
import SafariServices
import AVFoundation
import ObjectMapper
class Validation
{
    
    static func isValidName(str:String) -> Bool
    {
        if str.count == 0 || str.count > 128
        {
            return false
        }
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ")
        if str.rangeOfCharacter(from: characterset.inverted) != nil {
            return false
        }
        return true
    }
    static func isValidPhoneNumber(str:String) -> Bool
    {
        if str.count <= 0 || str.count > PHONE_VALID_DIGIT
        {
            return false
        }
        let characterset = CharacterSet(charactersIn: "1234567890")
        if str.rangeOfCharacter(from: characterset.inverted) != nil {
            return false
        }
        return true
    }
    
    static func isValidEmail(str:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-_]+\\.[A-Za-z]{2,20}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: str)
        return result
    }
    
    static func isValidPassword(str:String) -> Bool
    {
        if str.count < 6 ||  str.count > 12
        {
            return false
        }
        
       /* let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        guard texttest.evaluate(with: str) else { return false }
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        guard texttest1.evaluate(with: str) else { return false }
        
        let specialCharacterRegEx  = ".*[!&^%$#@()/_*+-]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        guard texttest2.evaluate(with: str) else { return false }*/
        
        return true
    }
    
    
    
    static func saveToUsrDef<T>(obj: AnyObject, objType:T.Type, key:String)
    {
        if let obj = obj as? T
        {
            let userDefaults = UserDefaults.standard
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject:obj)
            userDefaults.set(encodedData, forKey: key)
            userDefaults.synchronize()
        }
        
    }
    static func fetchFromUsrDef(key:String) -> Any
    {
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.object(forKey: key) as! Data
        let decodedObj = NSKeyedUnarchiver.unarchiveObject(with: decoded)
        return decodedObj as Any
    }
    static func fetchCurrentLocale() -> String
    {
        let locale = "en-US"
        return locale
    }
    
    static func randomNumber() -> String
    {
        let MAX : UInt32 = 999999
        let MIN : UInt32 = 100000
        let result: UInt32 = arc4random_uniform(MAX) + MIN
        let random_number =  result > MAX ? result - MIN : result
        print ("random = ", random_number);
        return "\(random_number)"
    }
    
    static func timerValue(_ timeToEnd: String) -> String {
        
        var resultDay :Int!
        var remainHour :Int!
        var Quotient :Int!
        var reminder :Int!
        
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        let timeUntilEnd = Int((df.date(from: timeToEnd)?.timeIntervalSinceNow)!)
        if timeUntilEnd <= 0 {
            return " Post Expired"
        }
        else {
            Quotient = timeUntilEnd/3600   //hour
            reminder = (timeUntilEnd)%3600
            if Quotient > 24
            {
                resultDay = Quotient/24   //day
                remainHour = Quotient%24
                let seconds1: Int = reminder % 60
                let minutes1: Int = (reminder / 60) % 60
                return String(format: "%02ld", Int(resultDay))
            }
            else
            {
                let seconds1: Int = timeUntilEnd % 60
                let minutes1: Int = (timeUntilEnd / 60) % 60
                let hours1: Int = timeUntilEnd / 3600
                return String(format: "%02ld:%02ld:%02ld", Int(hours1), Int(minutes1), Int(seconds1))
                
            }
            
        }
    }
    
    static func showTransparentWindow(sender:UIViewController, strMsg: String)
    {
        if let vc = UIApplication.topViewController()
        {
            if vc.isMember(of: TransparentVC.self)
            {
                let myVC:TransparentVC = (vc as? TransparentVC)!
                myVC.reAllocateTimer(strMsg:strMsg , strType: "1", strUserId: "")
            }
            else
            {
                let vc = TransparentVC(nibName:"TransparentVC",bundle:nil)
                vc.modalPresentationStyle = .overCurrentContext
                vc.type = "1"
                vc.message = strMsg
                sender.present(vc, animated: false, completion: nil)
            }
        }
        
    }
    
    static func playSound(filename: String) -> AVAudioPlayer
    {
        let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: filename, ofType: "wav")!)
        var audioPlayer = AVAudioPlayer()
        
        audioPlayer = try! AVAudioPlayer.init(contentsOf: sound as URL)
        audioPlayer.prepareToPlay()
        
        audioPlayer.play()
        audioPlayer.numberOfLoops = -1
        Validation.setSessionPlayerOn()
        return audioPlayer
    }
    
    static func stopSound(audioPlayer: AVAudioPlayer)
    {
        audioPlayer.stop()
        Validation.setSessionPlayerOff()
    }
    
    static func setSessionPlayerOn()
    {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategorySoloAmbient)
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        } catch _ {
        }
    }
    
    static func setSessionPlayerOff()
    {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
        }
        catch _ {
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch _ {
        }
    }
    static func getLocalDateFromGMTDiffFormat(gmtDate: String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
        let gmt = NSTimeZone(abbreviation: "GMT") //NSTimeZone(abbreviation:"System")
        dateFormatter.timeZone = gmt as TimeZone!
        let gmtTimeStamp: Date = dateFormatter.date(from: gmtDate) ?? Date()
        return gmtTimeStamp
    }
    
    static func getLocalDateFromGMT(gmtDate: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let gmt = NSTimeZone(abbreviation: "GMT") //NSTimeZone(abbreviation:"System")
        dateFormatter.timeZone = gmt as TimeZone!
        let gmtTimeStamp: Date = dateFormatter.date(from: gmtDate) ?? Date()
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm:ss a"//"yyyy-MM-dd HH:mm:ss" //Jan 30, 2018 12:32:34 PM
        dateFormatter.timeZone = gmt as TimeZone!
        let localTimeStamp: String = dateFormatter.string(from: gmtTimeStamp)
        return localTimeStamp
    }
    static func getLocalDayFromGMT(gmtDate: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let gmt = NSTimeZone(abbreviation: "GMT") //NSTimeZone(abbreviation:"System")
        dateFormatter.timeZone = gmt as TimeZone!
        let gmtTimeStamp: Date = dateFormatter.date(from: gmtDate) ?? Date()
        dateFormatter.dateFormat = "dd"//"yyyy-MM-dd HH:mm:ss" //Jan 30, 2018 12:32:34 PM
        dateFormatter.timeZone = gmt as TimeZone!
        let localDate: String = dateFormatter.string(from: gmtTimeStamp)
        dateFormatter.dateFormat = "MMM"
        let localMonth: String = dateFormatter.string(from: gmtTimeStamp)
        let localTimeStamp: String = localDate + getDayOfMonthSuffix(strDate: localDate) + " " + localMonth
        
        return localTimeStamp
    }
    static func getDayOfMonthSuffix(strDate: String) -> String
    {
        let n:Int = strDate.toInt(defaultValue: 1)
        if n >= 11 && n <= 13
        {
            return "th"
        }
        switch (n % 10) {
        case 1:  return "st"
        case 2:  return "nd"
        case 3:  return "rd"
        default: return "th"
        }
    }
    static func presentSafariVC(strLink: String)
    {
        let svc = SFSafariViewController(url: URL(string: strLink)!)
        if #available(iOS 10.0, *)
        {
            svc.preferredBarTintColor = "ED64FA".hexColor
            svc.preferredControlTintColor = .white
        }
        else
        {
            // Fallback on earlier versions
        }
        if let controller = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController {
            controller.present(svc, animated: true, completion: nil)
        }
        else
        {
            UIApplication.shared.delegate?.window!!.rootViewController?.present(svc, animated: true, completion: nil)
        }
    }
    
    static func generateFileName(strExtention: String) -> String
    {
        let randNum = arc4random() % (999999999 - 100000000) + 999999999; //create the random number.
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmssSSS"
        let dateString = formatter.string(from: Date())
        let name = "ForDonor_" + dateString + "_\(randNum)" + "." + strExtention
        return name
    }
    
    static func saveUserToUserDefaults(userDetails:User)
    {
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(userDetails.id, forKey:
            "userId")
        userDefaults.set(userDetails.firstname, forKey:
            "FName")
        userDefaults.set(userDetails.lastname, forKey:
            "LName")
        userDefaults.set(userDetails.email, forKey:
            "email")
        userDefaults.set(userDetails.gender, forKey:
            "Gender")
        userDefaults.set(userDetails.phoneNumber, forKey:
            "phoneNumber")
        userDefaults.set(userDetails.birthDate, forKey:
            "birthDate")
        userDefaults.set(userDetails.age, forKey:
            "age")
        userDefaults.set(userDetails.profileImg, forKey:
            "profileImg")
        userDefaults.set(userDetails.locale, forKey:
            "locale")
        userDefaults.set(userDetails.isBanking, forKey: "isBanking")
        userDefaults.set(userDetails.isVerified, forKey: "isVerified")
        
        
        if let address = userDetails.address
        {
            userDefaults.set(address.address, forKey:
                "address")
            userDefaults.set(address.country, forKey:
                "country")
            userDefaults.set(address.city, forKey:
                "city")
            userDefaults.set(address.state, forKey:
                "state")
            userDefaults.set(address.zipCode, forKey:
                "zipCode")
        }
        
        if let auth = userDetails.userAuth
        {
            userDefaults.set(auth.username, forKey:
                "username")
        }
        
        
        userDefaults.synchronize()
    }
    
    //MARK:- Following saveData and fetchData is not working, we have to fix those
    static func saveData<U: Mappable>(object: U, key: String)
    {
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: object)
        userDefaults.set(encodedData, forKey: key)
        userDefaults.synchronize()
    }
    
    static func fetchData<U: Mappable>(object: U, key: String) -> U
    {
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.object(forKey: key) as! Data
        let decodedUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! U
        return decodedUser
    }
}
