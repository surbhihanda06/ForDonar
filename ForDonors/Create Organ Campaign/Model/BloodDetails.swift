//
//  BloodDetails.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 30/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class BloodDetails: Mappable
{
    var id: Int!
    var bloodgroup_name: String? = ""
    
    
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    
    
    
    public func mapping(map: Map)
    {
        id <- map["id"]
        bloodgroup_name <- map["bloodgroup_name"]
    }
}
