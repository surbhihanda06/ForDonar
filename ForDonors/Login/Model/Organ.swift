//
//  Organ.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 09/03/18.
//  Copyright © 2018 NATIT Solved Pvt Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

class Organ: Mappable
{
    var id: Int? = 0
    var organ_name: String? = ""
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    public func mapping(map: Map)
    {
        id <- map["id"]
        organ_name <- map["organ_name"]
    }
    
    public required init?(id: Int, organ_name: String)
    {
        self.id = id
        self.organ_name = organ_name
    }
}
