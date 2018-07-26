//
//  MakePutRequest.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 30/04/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import Alamofire
import Foundation
import ObjectMapper

class MakePutRequest: APIRequest {
    
    public var path: String {
        return APIName
    }
    
    public var method: HTTPMethod {
        return .put
    }
    
    
    public var parameters: [String: Any] {
        return parameterList
    }
    
    public var isAuthorized: Bool {
        return false
    }
    
    public var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    private let parameterList: [String: Any]
    private let APIName: String
    
    
    init(parameterList: [String: Any], APIName: String) {
        self.parameterList = parameterList
        self.APIName = APIName
    }
}
