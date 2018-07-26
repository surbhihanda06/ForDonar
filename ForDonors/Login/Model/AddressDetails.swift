//
//  AddressDetails.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 05/04/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class AddressDetails: Mappable
{
    var id: Int? = 0
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
        id <- map["id"]
        address <- map["address"]
        addressLine2 <- map["addressLine2"]
        city <- map["city"]
        state <- map["state"]
        zipCode <- map["zipCode"]
        country <- map["country"]
    }
}
