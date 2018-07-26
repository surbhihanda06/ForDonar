//
//  UrlUtil.swift
//  ForDonors
//
//  Created by Viet Doan on 4/21/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation

class UrlUtil {
    
    static func getBaseURL() -> String {
        return BASE_URL
    }
    
    static func getApiURL() -> String {
        return API_URL
    }
    
    static func getUserImage(image:String) -> String {
        return S3_URL + S3_BUCKET + USER_IMAGE_DIR + image
    }
    static func getCampaignImage(image:String) -> String {
        return S3_URL + S3_BUCKET + CAMPAIGN_IMAGE_DIR + image
    }
    static func getCampaignVideo(video:String) -> String {
        return S3_URL + S3_BUCKET + CAMPAIGN_VIDEO_DIR + video
    }
    static func getPerkImage(image:String) -> String {
        return S3_URL + S3_BUCKET + PERK_IMAGE_DIR + image
    }
}

