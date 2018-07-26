//
//  Roles.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 09/03/18.
//  Copyright © 2018 NATIT Solved Pvt Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

class Roles: Mappable
{
    var id: Int? = 0
    var role_name: String? = ""
    var is_active: Bool = false
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    public func mapping(map: Map)
    {
        id <- map["id"]
        role_name <- map["role_name"]
        is_active <- map["is_active"]
    }
    
    public required init?(id: Int, role_name: String, is_active: Bool)
    {
        self.id = id
        self.role_name = role_name
        self.is_active = is_active
    }
}
