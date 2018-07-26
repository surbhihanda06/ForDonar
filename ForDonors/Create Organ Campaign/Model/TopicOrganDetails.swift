//
//  TopicOrganDetails.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 24/05/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class TopicOrganDetails: Mappable
{
    var name: String? = ""
    var id: Int = 0
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    
    
    
    public func mapping(map: Map)
    {
        name <- map["name"]
        id <- map["id"]
    }
}
