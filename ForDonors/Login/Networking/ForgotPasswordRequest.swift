//
//  ForgotPasswordRequest.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 24/02/18.
//  Copyright © 2018 NATIT Solved Pvt Ltd. All rights reserved.
//

import Alamofire
import Foundation
import ObjectMapper

class ForgotPasswordRequest: APIRequest {
    
    public var path: String {
        return "users/forgotpasswordApi"
    }
    
    public var method: HTTPMethod {
        return .post
    }
    
    public var parameters: [String: Any] {
        return ["email": email]
    }
    
    public var isAuthorized: Bool {
        return false
    }
    
    public var encoding: ParameterEncoding {
        
        return JSONEncoding.default
    }
    
    private let email: String
    
    
    
    init(email: String) {
        
        self.email = email
    }
    
}
