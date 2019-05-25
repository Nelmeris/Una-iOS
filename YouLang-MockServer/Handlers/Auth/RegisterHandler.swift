//
//  RegisterHandler.swift
//  PerfectTemplate
//
//  Created by Artem Kufaev on 27/04/2019.
//

import Foundation
import PerfectHTTP

class RegisterHandler: AbstractHandler {
    var request: HTTPRequest
    var response: HTTPResponse

    required init(request: HTTPRequest, response: HTTPResponse) {
        self.request = request
        self.response = response
    }
}

extension RegisterHandler {
    
    func dataValidation() -> Bool {
        guard request.param(name: "first_name") != nil &&
            request.param(name: "last_name") != nil &&
            request.param(name: "email") != nil &&
            request.param(name: "password") != nil
            else {
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
            "access_token": "1hr1hfqpnfdlkfnlw1po43810podl",
            "user_message": "Регистрация прошла успешно!"
        ]

        do {
            try response.setBody(json: json)
        } catch {
            print(error)
        }
        response.completed()
    }
    
}
