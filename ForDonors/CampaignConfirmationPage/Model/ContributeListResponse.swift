//
//  ContributeListResponse.swift
//  ForDonors
//
//  Created by NITS_Mac5 on 05/07/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class ContributeListResponse: Mappable
{
    var last: Bool?
    var totalElements: Int?
    var totalPages: Int?
    var numberOfElements: Int?
    var first: Bool?
    var size: Int?
    var number: Int?
    var content: [ContentListResponse]?
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    
    public func mapping(map: Map)
    {
        self.last <- map["last"]
        self.totalElements <- map["totalElements"]
        self.totalPages <- map["totalPages"]
        self.numberOfElements <- map["numberOfElements"]
        self.first <- map["first"]
        self.size <- map["size"]
        self.number <- map["number"]
        self.content <- map["data.content"]
    }
}
