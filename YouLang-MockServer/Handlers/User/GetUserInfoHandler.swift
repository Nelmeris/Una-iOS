//
//  GetUserInfoHandler.swift
//  PerfectTemplate
//
//  Created by Artem Kufaev on 24/05/2019.
//

import Foundation
import PerfectHTTP

class GetUserInfoHandler: AbstractHandler {
    var request: HTTPRequest
    var response: HTTPResponse
    
    required init(request: HTTPRequest, response: HTTPResponse) {
        self.request = request
        self.response = response
    }
}

extension GetUserInfoHandler {
    
    func dataValidation() -> Bool {
        guard request.param(name: "access_token") != nil else {
            ErrorHandler(request: request, response: response).process()
            return false
        }
        return true
    }
    
    func process() {
        response.setHeader(.contentType, value: "application/json")
        guard dataValidation() else { return }
        let json: [String: Any] = [
            "result": 1,
            "first_name": "Artem",
            "last_name": "Kufaev",
            "is_admin": true,
            "created_at": "2019-05-24T11:54:38+0000",
            "updated_at": "2019-05-24T11:54:38+0000"
        ]
        
        do {
            try response.setBody(json: json)
        } catch {
            print(error)
        }
        response.completed()
    }
    
}
