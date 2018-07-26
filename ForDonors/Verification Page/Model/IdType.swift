//
//  IdType.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 08/05/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class IdType: Mappable
{
    var type: String? = ""
    var number: String? = ""
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    
    init(type: String, number: String) {
        self.type = type
        self.number = number
    }
    
    public func mapping(map: Map)
    {
        type <- map["type"]
    }
}
