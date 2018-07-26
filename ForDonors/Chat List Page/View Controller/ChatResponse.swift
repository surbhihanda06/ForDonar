//
//  ChatResponse.swift
//  ForDonors
//
//  Created by NITS_Mac5 on 28/06/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class ChatResponse: Mappable
{
    var idReceiver: String? = ""
    var idReceivername: String? = ""
    var idSender: String? = ""
    var idSendername: String? = ""
    var text: String? = ""
    var timestamp: Double?
    var campaignName: String? = ""
    
    public required init?(map: Map)
    {
        
    }
    
    public required init()
    {
        
    }
    
    public func mapping(map: Map)
    {
        idReceiver <- map["idReceiver"]
        idReceivername <- map["idReceivername"]
        idSender <- map["idSender"]
        idSendername <- map["idSendername"]
        text <- map["text"]
        timestamp <- map["timestamp"]
        campaignName <- map["campaignName"]
    }
}
