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
            let password = request.param(name: "password") else {
                ErrorHandler(request: request, response: response).process()
            return false
        }
        guard email == "admin@youlang.com" && password == "admin" else {
            ErrorHandler(request: request, response: response).process(errorMsg: "Неверная почта или пароль")
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
