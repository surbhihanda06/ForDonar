//
//  Verification.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 08/05/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class Verification: Mappable //, Hashable
{
//    var hashValue: Int
//    static func ==(lhs: Verification, rhs: Verification) -> Bool {
//    }
    
    var idselfie: Any!
    var idfront: Any!
    var idback: Any!
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    
    init(idselfie: Any, idfront: Any, idback: Any) {
        self.idselfie = idselfie
        self.idfront = idfront
        self.idback = idback
    }
    
    public func mapping(map: Map)
    {
        idselfie <- map["idselfie"]
        idfront <- map["idfront"]
        idback <- map["idback"]
    }
}
