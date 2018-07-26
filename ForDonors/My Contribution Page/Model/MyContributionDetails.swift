//
//  MyContributionDetails.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 19/06/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class MyContributionDetails: Mappable,Hashable
{
    var hashValue: Int { return self.contributionId }
    var offer: Int = 0
    var contributionId: Int = 0
    var createdDate: String? = ""
    var amount: String? = ""
    var campaignName: String? = ""
    var campaignType: String? = ""
    var campaignId: Int = 0
    var images: NSMutableArray = NSMutableArray()
    var userId: Int = 0
    var allContributeList = [ContributeDetails]()
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    /*
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    public required init(first_name: String, last_name: String, email: String, profile_img: String, cat_type: String, campaign_type: String, campaign_name: String, description: String, goal_amount: Int, location: String, tag_line: String, cat_name: String,image: NSMutableArray, collaborators_user : [CollaboratorDetails], perks :[Perks], bloodgroup: String, organ: String, camp_media: String,date: String)
    {
        self.first_name = first_name
        self.last_name = last_name
        self.email = email
        self.profile_img = profile_img
        self.cat_type = cat_type
        self.campaign_type = campaign_type
        self.campaign_name = campaign_name
        self.description = description
        self.goal_amount = goal_amount
        self.location = location
        self.tag_line = tag_line
        self.cat_name = cat_name
        self.image = image
        self.collaborators_user = collaborators_user
        self.perks = perks
        self.bloodgroup = bloodgroup
        self.organ = organ
        self.camp_media = camp_media
        self.date = camp_media
    }*/
    
    public func mapping(map: Map)
    {
        offer <- map["offer"]
        contributionId <- map["contributionId"]
        createdDate <- map["createdDate"]
        images <- map["campaign.images"]
        campaignName <- map["campaignName"]
        campaignType <- map["campaign.campaignType"]
        campaignId <- map["campaign.campaignId"]
        amount <- map["invoice.amount"]
        userId <- map["userId"]
        allContributeList <- map["contribution"]
    }
}
func == (lhs: MyContributionDetails, rhs: MyContributionDetails) -> Bool {
    return lhs.contributionId == rhs.contributionId
}


