//
//  MakeGetRequest.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 09/03/18.
//  Copyright © 2018 NATIT Solved Pvt Ltd. All rights reserved.
//

import Alamofire
import Foundation
import ObjectMapper

class MakeGetRequest: APIRequest {
    
    public var path: String {
        return APIName
    }
    
    public var method: HTTPMethod {
        return .get
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
