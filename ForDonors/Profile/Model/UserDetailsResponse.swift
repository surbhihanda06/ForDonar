//
//  UserDetailsResponse.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 10/04/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class UserDetailsResponse: Mappable
{
    var id: Int = 0
    var isDonor: Bool = false
    var username: String? = ""
    var first_name: String? = ""
    var last_name: String? = ""
    var email: String? = ""
    var gender: String? = ""
    var birthDate: String? = ""
    var organ: [Organ]!
    var phnNo: String? = ""
    var profileImg: String?  = ""
    var social = [SocialDetails]()
    //var address: AddressDetails!
    
    var address: String? = ""
    var addressLine2: String? = ""
    var city: String? = ""
    var state: String? = ""
    var zipCode: String? = ""
    var country: String? = ""
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    public func mapping(map: Map)
    {
        id <- map["data.id"]
        isDonor <- map["data.isDonor"]
        username <- map["data.username"]
        first_name <- map["data.firstname"]
        last_name <- map["data.lastname"]
        email <- map["data.email"]
        gender <- map["data.gender"]
        birthDate <- map["data.birthDate"]
        organ <- map["data.organ"]
        phnNo <- map["data.phoneNumber"]
        profileImg <- map["data.profileImg"]
        social <- map["data.socialAccounts"]
        //address <- map["address"]
        
        address <- map["address.address"]
        addressLine2 <- map["address.addressLine2"]
        city <- map["address.city"]
        state <- map["address.state"]
        zipCode <- map["address.zipCode"]
        country <- map["address.country"]
    }
}
