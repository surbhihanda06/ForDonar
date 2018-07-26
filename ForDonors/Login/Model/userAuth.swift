//
//  userAuth.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 23/04/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class userAuth: Mappable
{
    var id: Int? = 0
    var username: String? = ""
    var userId: Int? = 0
    var email: String? = ""
    var loggedIn: Bool? = false
    var lastLoggedIn: String? = ""
    var lastAttemptLoggedIn: String? = ""
    var noAttempt: Int? = 0
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    
    public required init?(map: Map)
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    public func mapping(map: Map)
    {
        id <- map["id"]
        username <- map["username"]
        userId <- map["userId"]
        email <- map["email"]
        loggedIn <- map["loggedIn"]
        lastLoggedIn <- map["lastLoggedIn"]
        lastAttemptLoggedIn <- map["lastAttemptLoggedIn"]
        noAttempt <- map["noAttempt"]
    }
}
