//
//  CampaignDetails.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 29/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
import ObjectMapper

class CampaignDetails: Mappable,Hashable
{
    var hashValue: Int { return self.id }
    var id: Int = 0
    var first_name: String? = ""
    var last_name: String? = ""
    var email: String? = ""
    var profile_img: String? = ""
    var cat_type: String? = ""
    var campaign_type: String? = ""
    var campaign_name: String? = ""
    var description: String? = ""
    var goal_amount: Int! = 0
    var raisedAmount: Int!
    var location: String? = ""
    var tag_line: String? = ""
    var cat_name: String? = ""
    var image: NSMutableArray = NSMutableArray()
    var collaborators_user = [CollaboratorDetails]()
    var perks = [Perks]()
    var bloodgroup: String? = ""
    var organ: String? = ""
    var camp_media: Int = 0
    var date: Int = 0
    var userId: Int = 0
    var isLike = Bool()
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map)
    {
        
    }
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    public required init(first_name: String, last_name: String, email: String, profile_img: String, cat_type: String, campaign_type: String, campaign_name: String, description: String, goal_amount: Int, location: String, tag_line: String, cat_name: String,image: NSMutableArray, collaborators_user : [CollaboratorDetails], perks :[Perks], bloodgroup: String, organ: String, camp_media: Int,date: String)
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
    }
    
    public func mapping(map: Map)
    {
        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        email <- map["email"]
        profile_img <- map["profile_img"]
        cat_type <- map["cat_type"]
        campaign_type <- map["campaignType"]
        campaign_name <- map["campaignName"]
        description <- map["campaignDescription"]
        goal_amount <- map["goalAmount"]
        raisedAmount <- map["raisedAmount"]
        location <- map["country"]
        tag_line <- map["tag_line"]
        cat_name <- map["cat_name"]
        image <- map["images"]
        collaborators_user <- map["collaborators_user"]
        perks <- map["perks"]
        bloodgroup <- map["bloodgroup"]
        organ <- map["organ"]
        camp_media <- map["camp_media"]
        date <- map["expirationDate"]
        userId <- map["user.id"]
        isLike <- map["isLike"]
    }
}
func == (lhs: CampaignDetails, rhs: CampaignDetails) -> Bool {
    return lhs.id == rhs.id
}


