//
//  User.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 09/03/18.
//  Copyright © 2018 NATIT Solved Pvt Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable
{
    var id: Int = 0
    var isDonor: Bool = false
    var username: String? = ""
    var firstname: String? = ""
    var lastname: String? = ""
    var email: String? = ""
    var gender: String? = ""
    var birthDate: String? = ""
    var age: Int = 0
    var organ: [Organ]!
    var phoneNumber: String? = ""
    var profileImg = ""
    var socialAccounts = [SocialDetails]()
    var address: AddressDetails!
    var deviceType: String? = ""
    var deviceId: String? = ""
    var isActive: String? = ""
    var createdDate: String? = ""
    var locale: String? = ""
    var userAuth: userAuth!
    var isBanking: Bool = false
    var isVerified: Bool = false
    
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    public func mapping(map: Map)
    {
        id <- map["id"]
        isDonor <- map["isDonor"]
        username <- map["username"]
        firstname <- map["firstname"]
        lastname <- map["lastname"]
        email <- map["email"]
        gender <- map["gender"]
        birthDate <- map["birthDate"]
        age <- map["age"]
        organ <- map["organ"]
        phoneNumber <- map["phoneNumber"]
        profileImg <- map["profileImg"]
        socialAccounts <- map["socialAccounts"]
        address <- map["address"]
        deviceType <- map["deviceType"]
        deviceId <- map["deviceId"]
        isActive <- map["isActive"]
        createdDate <- map["createdDate"]
        locale <- map["locale"]
        userAuth <- map["userAuth"]
        isBanking <- map["isBanking"]
        isVerified <- map["verified"]
    }
}
