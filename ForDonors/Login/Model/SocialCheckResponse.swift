//
//  SocialCheckResponse.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 13/04/18.
//  Copyright © 2018 NATIT Solved Pvt Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

class SocialCheckResponse: Mappable
{
    var result: String? = ""
    var data: Bool = true
    var status: String? = ""
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    public func mapping(map: Map)
    {
        result <- map["result"]
        data <- map["data"]
        status <- map["status"]
    }
}
