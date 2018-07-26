//
//  AddBAnkAccountResponse.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 18/06/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class AddBAnkAccountResponse: Mappable
{
    var msg: String? = ""
    var data: Bool = true
    var status: String? = ""
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    public func mapping(map: Map)
    {
        msg <- map["message"]
        data <- map["data"]
        status <- map["status"]
    }
}
