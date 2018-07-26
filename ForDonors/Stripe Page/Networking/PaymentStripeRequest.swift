//
//  PaymentStripeRequest.swift
//  DigitalDentalStaff
//
//  Created by NITS Mac2 on 13/07/17.
//  Copyright © 2017 NITS Mac2. All rights reserved.
//

import Foundation
import Alamofire

class PaymentStripeRequest: APIRequest
{
    public var path: String {
        //http://192.168.1.111/DigitalDental/webservice/users/ConfirmPayment
        
        return "ConfirmPayment"
    }
    
    public var method: HTTPMethod {
        return .post
    }
    //{"user_id":"1","plan_id":"7","membership_id":"3","token":"tok_1AeOTS4q9Uk8Ya32SHfLqnB4"}
    
    public var parameters: [String: Any] {
        return ["user_id": userId, "membership_id": membershipId, "token": tokenId, "plan_id": planId]
    }
    
    public var isAuthorized: Bool {
        return false
    }
    
    public var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    private let userId: String
    private let planId: String
    private let membershipId: String
    private let tokenId: String
    
    init(user_id: String, memberShipID: String, tokenID: String, planID: String) {
        self.userId = user_id
        self.planId = planID
        self.membershipId = memberShipID
        self.tokenId = tokenID
    }
}
