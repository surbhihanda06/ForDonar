//
//  StateDetails.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 06/04/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class StateDetails: Mappable
{
    var id: Int = 0
    var countryId: Int = 0
    var name: String? = ""
    var stateId: Int = 0
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    public func mapping(map: Map)
    {
        id <- map["id"]
        countryId <- map["countryId"]
        name <- map["name"]
        stateId <- map["stateId"]
    }
}
