//
//  APIRequest.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 23/02/18.
//  Copyright © 2018 NATIT Solved Pvt Ltd. All rights reserved.
//

import Alamofire

public protocol APIRequest {
    
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var isAuthorized: Bool { get }
    var parameters: [String: Any] { get }
    var encoding: ParameterEncoding { get }
    
}

extension APIRequest {
    
    public var baseURL: String {
        return API_URL
    }
    
    public var path: String {
        return ""
    }
    
    public var method: HTTPMethod {
        return .get
    }
    
    public var parameters: [String: Any] {
        return [:]
    }
    
    public var isAuthorized: Bool {
        return true
    }
    
    public var encoding: ParameterEncoding {
        return URLEncoding.default
    }
    
}
