//
//  ContentListResponse.swift
//  ForDonors
//
//  Created by NITS_Mac5 on 05/07/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class ContentListResponse: Mappable
{
    var id: Int?
    var amount: Int?
    var contributorID: Int?
    
    public required init?(map: Map)
    {
        
    }
    
    public func mapping(map: Map)
    {
        self.id <- map["id"]
        self.amount <- map["invoice.amount"]
        self.contributorID <- map["contributorId"]
    }
}
