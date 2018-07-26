//
//  SocialDetails.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 05/04/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class SocialDetails: Mappable
{
    var id: Int? = 0
    var appId: String? = ""
    var name: String? = ""
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    public func mapping(map: Map)
    {
        id <- map["id"]
        appId <- map["appId"]
        name <- map["name"]
    }
    
    public required init?(id: Int, gendername: String)
    {
        self.id = id
        self.appId = gendername
    }
}
