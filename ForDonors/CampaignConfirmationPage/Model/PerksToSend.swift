//
//  PerksToSend.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 31/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class PerksToSend: Mappable
{
    var campaign_name: String? = ""
    var description: String? = ""
    var estimated_delivery_date: String? = ""
    var id: Int = 0
    var perks_image: String? = ""
    var price: Int = 0
    var shipping: Int = 0
    var title: String? = ""
    var items: NSMutableArray = NSMutableArray()
    
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    
    init(campaign_name: String, description: String, estimated_delivery_date: String, id: Int, perks_image: String, price: Int, title: String) {
        self.campaign_name = campaign_name
        self.description = description
        self.estimated_delivery_date = estimated_delivery_date
        self.id = id
        self.perks_image = perks_image
        self.price = price
        self.title = title
    }
    
    public func mapping(map: Map)
    {
        self.campaign_name <- map["campaign_name"]
        self.description <- map["description"]
        self.estimated_delivery_date <- map["estimatedDeliveryDate"]
        self.id <- map["id"]
        self.perks_image <- map["perks_image"]
        self.price <- map["price"]
        self.shipping <- map["shipping"]
        self.title <- map["title"]
        self.items <- map["items"]
    }
}
