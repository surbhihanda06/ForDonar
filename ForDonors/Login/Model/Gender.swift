//
//  Gender.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 09/03/18.
//  Copyright © 2018 NATIT Solved Pvt Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

class Gender: Mappable
{
    var id: Int? = 0
    var gendername: String? = ""
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    public func mapping(map: Map)
    {
        id <- map["id"]
        gendername <- map["gendername"]
    }
    
    public required init?(id: Int, gendername: String)
    {
        self.id = id
        self.gendername = gendername
    }
}
