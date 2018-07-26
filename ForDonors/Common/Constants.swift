//
//  Constants.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 23/02/18.
//  Copyright © 2018 NATIT Solved Pvt Ltd. All rights reserved.
//

import Foundation

let BASE_URL =  "http://fordonor.us-west-2.elasticbeanstalk.com"//"http://192.168.1.61:8080"
let API_URL = BASE_URL + "/api"

let S3_URL = "https://s3-us-west-2.amazonaws.com"
let S3_BUCKET = "/fordonor"

let USER_DIR = "/user"
let USER_IMAGE_DIR = USER_DIR + "/images/"
let USER_VIDEO_DIR = USER_DIR + "/videos/"

let CAMPAIGN_DIR = "/campaign"
let CAMPAIGN_IMAGE_DIR = CAMPAIGN_DIR + "/images/"
let CAMPAIGN_VIDEO_DIR = CAMPAIGN_DIR + "/videos/"

let PERK_DIR = CAMPAIGN_DIR + "/perk"
let PERK_IMAGE_DIR = PERK_DIR + "/images/"
let PERK_VIDEO_DIR = PERK_DIR + "/videos/"

let PER_PAGE_CONTENT = 3
func PAGE_NUMBER (total: Int) -> Int
{
    let page = total / PER_PAGE_CONTENT
    return page
}

var selectedLocale = "en-US"
var selectedCountry = "US"

func HEADERS() ->[String:String]
{
    var selectedUserID : String = ""
    let selectedCountry = UserDefaults.standard.object(forKey: "AppleLanguages") as? String ?? "US"
    selectedLocale = UserDefaults.standard.object(forKey: "AppleLanguages") as? String ?? "en-US"
    if UserDefaults.standard.value(forKey: "userId") != nil
    {
        selectedUserID = String(describing: UserDefaults.standard.object(forKey: "userId")!)
    }
    //let selectedUserID = UserDefaults.standard.object(forKey: "userId")! as? String ?? ""
    //selectedUserID = String(describing: UserDefaults.standard.object(forKey: "userId")!) ?? ""
    let headerValue = ["Accept-Language": selectedLocale, "Content-Type":"application/json","UserCountry":selectedCountry,"UserId" : selectedUserID]
    return headerValue 
}

let BORDER_COLOR:String = "8D44B3"


var YEARS_TILL_NOW : [String] {
    var years = [String]()
    let currentYear = Calendar.current.component(.year, from: Date())
    for i in (currentYear-40..<currentYear+5).reversed() {
        years.append("\(i)")
    }
    return years
}
let PHONE_VALID_DIGIT = 10

let dateOnlyFormat = "MM/dd/yyyy"

let No_Image = "NoImage"
let Default_Image = "defaultImage"

func fileNameWithExtnsn(extnsn: String) -> String
{
    let randNum = arc4random() % (999999999 - 100000000) + 999999999;
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMddHHmmssSSS"
    let dateString = formatter.string(from: Date())
    let name = "ForDonor_" + dateString + "_\(randNum)" + "." + extnsn
    return name
}



