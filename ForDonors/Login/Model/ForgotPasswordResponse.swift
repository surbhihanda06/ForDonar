//
//  ForgotPasswordResponse.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 06/04/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class ForgotPasswordResponse: Mappable
{
    var result: String? = ""
    var data: String? = ""
    var message: String? = ""
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
        message <- map["message"]
        status <- map["status"]
    }
}