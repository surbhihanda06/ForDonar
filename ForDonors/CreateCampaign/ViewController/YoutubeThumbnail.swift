//
//  YoutubeThumbnail.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 27/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Foundation
enum ThumbnailQuailty : String {
    case Zero = "0.jpg"
    case One = "1.jpg"
    case Two = "2.jpg"
    case Three = "3.jpg"
    
    case Default = "default.jpg"
    case Medium = "mqdefault.jpg"
    case High = "hqdefault.jpg"
    case Standard = "sddefault.jpg"
    case Max = "maxresdefault.jpg"
    
    /// All values sorted by image size (1,2,3 are the same size)
    static let allValues = [Default, One, Two, Three,  Medium, High, Zero, Standard, High]
}

func thumbnailURLString(videoID:String, quailty: ThumbnailQuailty = .Default) -> String {
    //return "http://img.youtube.com/vi/\(videoID)/\(quailty.rawValue)"
    return "http://i1.ytimg.com/vi/\(videoID)/\(quailty.rawValue)"
}
