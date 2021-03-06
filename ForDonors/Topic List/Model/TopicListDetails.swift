//
//  TopicListDetails.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 28/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class TopicListDetails: Mappable
{
    var id: Int = 0
    var parentId: Int = 0
    var name: String = ""
    var subTopic = [SubTopicList]()
    
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    public func mapping(map: Map)
    {
        id <- map["id"]
        name <- map["name"]
        parentId <- map["parentId"]
        subTopic <- map["children"]
    }
}
