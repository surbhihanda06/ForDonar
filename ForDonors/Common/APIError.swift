//
//  APIError.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 23/02/18.
//  Copyright © 2018 NATIT Solved Pvt Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

/*
enum APIErrorType: Error {
    case FoundNil(String)
}
public class APIError: Mappable {
    
    var error: String?
    var success: Bool?
    
   
    
    
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map)
    {
        error <- map["msg"]
        success <- map["Ack"]
        
        print(error ?? "No Error value")
        print(success ?? "No Success value")
    }
    
    func getError() -> String? {
        return self.error
    }
    
    func getSuccess() -> Bool? {
        
        return self.success
    }*/
    
    
    
//}
protocol DentalErrorProtocol: Error {
    
    var title: String { get }
    var description: String { get }
    var code: Int { get }
}

struct DDSError: DentalErrorProtocol
{
    var title: String
    var description: String
    var code: Int
    
    init(title: String?, description: String, code: Int)
    {
        self.title = title ?? "Error"
        self.description = description
        self.code = code
    }
}

public class APIError: Mappable {
    
    var error: String = ""
    var success: Int? = 0
    
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        error <- map["message"]
        success <- map["IsSuccess"]
        
        //print(error )
        //print(success ?? "No Success value")
    }
    
    func getError() -> String?
    {
        let error:String = (self.error.count) == 0 ? "Unknown Error" : self.error
        return error
    }
    
    func getSuccess() -> String? {
        return self.success?.description
    }
    
}

