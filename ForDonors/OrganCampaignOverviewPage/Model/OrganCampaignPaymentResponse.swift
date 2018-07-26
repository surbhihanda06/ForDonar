//
//  OrganCampaignPaymentResponse.swift
//  ForDonors
//
//  Created by NITS_Mac5 on 28/06/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class OrganCampaignPaymentResponse: Mappable
{
    var result: String? = ""
    var id = Int()
    var paymentFeeId = Int()
    var countryId = Int()
    var listingFee = Int()
    var subscriptionFee = Int()
    var status: String? = ""
    
    public required init?(map: Map)
    {
        
    }
    
    public func mapping(map: Map)
    {
        result <- map["result"]
        id <- map["data.id"]
        paymentFeeId <- map["data.paymentFeeId"]
        countryId <- map["data.countryId"]
        listingFee <- map["data.listingFee"]
        subscriptionFee <- map["data.subscriptionFee"]
        status <- map["status"]
    }
}
