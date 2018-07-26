//
//  ContributeDetails.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 25/06/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class ContributeDetails: Mappable
{
    var offer: Int = 0
    var contributionId: Int = 0
    var createdDate: String? = ""
    var alias: String? = ""
    var invoice: String? = ""
    var id: String? = ""
    var userId: Int = 0
    var amount: Int = 0
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    
    
    public func mapping(map: Map)
    {
        offer <- map["offer"]
        contributionId <- map["contributionId"]
        createdDate <- map["createdDate"]
        alias <- map["alias"]
        invoice <- map["invoice"]
        id <- map["id"]
        userId <- map["userId"]
        amount <- map["invoice.amount"]
    }
}

