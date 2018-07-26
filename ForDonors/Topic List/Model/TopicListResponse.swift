//
//  TopicListResponse.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 28/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class TopicListResponse: Mappable
{
    var status: String? = ""
    var result: String? = ""
    var message: String? = ""
    var topicList: TopicListDetails!
    
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    public func mapping(map: Map)
    {
        result <- map["result"]
        topicList <- map["data"]
        status <- map["status"]
        message <- map["message"]
    }
}
