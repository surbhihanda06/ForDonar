//
//  CommentDetails.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 08/06/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class CommentDetails: Mappable
{
    var id: String? = ""
    //var createdDate: String? = ""
    var createdDate: Double?
    var message: String? = ""
    
    var posterFirstName: String? = ""
    var posterLastName: String? = ""
    var posterImage: String? = ""
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    public func mapping(map: Map)
    {
        id <- map["id"]
        createdDate <- map["createdDate"]
        message <- map["message"]
        
        posterFirstName <- map["user.firstname"]
        posterLastName <- map["user.lastname"]
        posterImage <- map["user.profileImg"]
    }
}
