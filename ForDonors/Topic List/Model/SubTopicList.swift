//
//  SubTopicList.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 28/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class SubTopicList: Mappable
{
    var id: Int = 0
    var parentId: Int = 0
    var name: String = ""
    var active: Bool = true
    
    //{"name":"Medical & Emergencies","id":53281,"parentId":0}
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    public func mapping(map: Map)
    {
        id <- map["id"]
        parentId <- map["parentId"]
        name <- map["name"]
        active <- map["active"]
    }
}
