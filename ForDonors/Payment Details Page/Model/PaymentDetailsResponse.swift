//
//  PaymentDetailsResponse.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 13/06/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class PaymentDetailsResponse: Mappable
{
    var status: String? = ""
    var data: PaymentDetails!
    var message: String? = ""
    
    //{"name":"Medical & Emergencies","id":53281,"parentId":0}
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    public func mapping(map: Map)
    {
        status <- map["status"]
        data <- map["data"]
        message <- map["msg"]
    }
}
