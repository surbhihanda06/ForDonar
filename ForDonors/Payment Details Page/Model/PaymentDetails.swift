//
//  PaymentDetails.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 22/06/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class PaymentDetails: Mappable
{
    var id: Int = 0
    var campaignId: Int = 0
    var contributorId: Int = 0
    var alias: String = ""
    
    //{"name":"Medical & Emergencies","id":53281,"parentId":0}
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    public func mapping(map: Map)
    {
        id <- map["id"]
        campaignId <- map["campaignId"]
        contributorId <- map["contributorId"]
        alias <- map["alias"]
    }
}
