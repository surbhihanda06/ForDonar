//
//  Collaborators.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 30/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class Collaborators: Mappable
{
    var id: Int = 0
    var first_name: String? = ""
    var last_name: String? = ""
    var email: String? = ""
    var profile_img: String? = ""
    
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    
    
    
    public func mapping(map: Map)
    {
        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        email <- map["email"]
        profile_img <- map["profile_img"]
    }
}
