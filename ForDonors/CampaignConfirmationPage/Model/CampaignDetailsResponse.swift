//
//  CampaignDetailsResponse.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 20/04/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class CampaignDetailsResponse: Mappable
{
    var campaign_name: String? = ""
    var description: String? = ""
    var createdDate: String? = ""
    var expirationDate: Int = 0
    var campaignType: String? = ""
    var firstname: String? = ""
    var lastname: String? = ""
    var profileImg: String? = ""
    var verified = Bool()
    var id: Int = 0
    var price: Int = 0
    var raisedAmount: Int = 0
    var images: NSMutableArray = NSMutableArray()
    var topicDetails: CampaignTopicDetails!
    var perks = [PerksToSend]()
    var arrCollaborators = [User]()
    var userId: Int = 0
    var country : String? = ""
    var city : String? = ""
    var noContribution: Int = 0
    var status : Int? = 0
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    
    init()
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
        
    public func mapping(map: Map)
    {
        self.campaign_name <- map["campaignName"]
        self.description <- map["campaignDescription"]
        self.id <- map["id"]
        self.price <- map["goalAmount"]
        self.raisedAmount <- map["raisedAmount"]
        self.createdDate <- map["createdDate"]
        self.expirationDate <- map["expirationDate"]
        self.campaignType <- map["campaignType"]
        self.firstname <- map["user.firstname"]
        self.lastname <- map["user.lastname"]
        self.profileImg <- map["user.profileImg"]
        self.verified <- map["verified"]
        self.images <- map["images"]
        self.topicDetails <- map["topic"]
        self.perks <- map["perks"]
        self.arrCollaborators <- map["collaborators"]
        self.userId <- map["user.id"]
        self.country <- map["country"]
        self.city <- map["city"]
        self.noContribution <- map["noContribution"]
        self.status <- map["status"]
    }
}
