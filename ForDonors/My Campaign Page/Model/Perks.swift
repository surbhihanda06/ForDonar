//
//  Perks.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 26/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class Perks: Mappable
{
    var title: String? = ""
    var description: String? = ""
    var price: String? = ""
    var shippingPrice: String? = ""
    var date: String? = ""
    var image: UIImage = UIImage()
    var items: NSMutableArray = NSMutableArray()
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    
    init(title: String, description: String, price: String, date: String, image: UIImage, items: NSMutableArray, shippingPrice: String) {
        self.title = title
        self.description = description
        self.price = price
        self.date = date
        self.image = image
        self.items = items
        self.shippingPrice = shippingPrice
    }
    
    public func mapping(map: Map)
    {
        title <- map["title"]
        description <- map["description"]
        price <- map["price"]
    }
}
