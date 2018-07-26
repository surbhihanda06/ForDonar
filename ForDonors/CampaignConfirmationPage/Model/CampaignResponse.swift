//
//  CampaignResponse.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 20/04/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class CampaignResponse: Mappable
{
    var result: String? = ""
    var data: CampaignDetailsResponse!
    var status: String? = ""
    var message: String? = ""
    
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    
    public func mapping(map: Map)
    {
        self.result <- map["result"]
        self.data <- map["data"]
        self.status <- map["status"]
        self.message <- map["message"]
    }
}
