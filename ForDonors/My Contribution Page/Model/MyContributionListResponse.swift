//
//  MyContributionListResponse.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 19/06/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class MyContributionListResponse: Mappable
{
    var allList = [MyContributionDetails]()
    var last: Bool = false
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    public func mapping(map: Map)
    {
        allList <- map["data.content"]
        last <- map["data.last"]
        
    }
}
