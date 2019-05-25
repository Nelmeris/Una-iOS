//
//  ErrorHandler.swift
//  PerfectTemplate
//
//  Created by Artem Kufaev on 27/04/2019.
//

import Foundation
import PerfectHTTP

class ErrorHandler: AbstractHandler {
    var request: HTTPRequest
    var response: HTTPResponse

    required init(request: HTTPRequest, response: HTTPResponse) {
        self.request = request
        self.response = response
    }
}

extension ErrorHandler {
    
    func process() {
        response.setHeader(.contentType, value: "application/json")
        let json: [String: Any] = [
            "result": 0,
            "error_message": "Incorrect request"
        ]

        do {
            try response.setBody(json: json)
        } catch {
            print(error)
        }
        response.completed()
    }
    
}
