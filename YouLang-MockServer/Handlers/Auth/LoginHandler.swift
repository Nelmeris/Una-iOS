//
//  LoginHandler.swift
//  PerfectTemplate
//
//  Created by Artem Kufaev on 27/04/2019.
//

import Foundation
import PerfectHTTP

class LoginHandler: AbstractHandler {
    var request: HTTPRequest
    var response: HTTPResponse

    required init(request: HTTPRequest, response: HTTPResponse) {
        self.request = request
        self.response = response
    }
}

extension LoginHandler {
    
    func dataValidation() -> Bool {
        guard let email = request.param(name: "email"),
            let password = request.param(name: "password"),
            email == "test@mail.ru" && password == "12345678" else {
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
            "access_token": "1hr1hfqpnfdlkfnlw1po43810podl"
        ]

        do {
            try response.setBody(json: json)
        } catch {
            print(error)
        }
        response.completed()
    }
    
}
