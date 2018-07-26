//
//  CollaboratorDetails.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 29/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class CollaboratorDetails: Mappable
{
    var id: Int = 0
    var email: String? = ""
    var user_img: String? = ""
    var user_name: String? = ""
    var campaign_name: String? = ""
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    public func mapping(map: Map)
    {
        email <- map["email"]
        user_img <- map["user_img"]
        user_name <- map["user_name"]
    }
    public required init(id: Int, email: String, user_img: String, user_name: String, campaign_name: String)
    {
        self.id = id
        self.email = email
        self.user_img = user_img
        self.user_name = user_name
        self.campaign_name = campaign_name
    }
}
