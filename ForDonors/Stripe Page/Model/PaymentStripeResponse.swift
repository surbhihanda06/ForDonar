//
//  PaymentStripeResponse.swift
//  DigitalDentalStaff
//
//  Created by NITS Mac2 on 13/07/17.
//  Copyright © 2017 NITS Mac2. All rights reserved.
//

import Foundation
import ObjectMapper


class PaymentStripeResponse: Mappable
{
    var strMessage: String?
    var strTxnId: String?
    
    public required init?(map: Map)
    {
        
    }
    
    public func mapping(map: Map)
    {
        strMessage <- map["msg"]
        strTxnId <- map["user.txn_id"]
    }
}
