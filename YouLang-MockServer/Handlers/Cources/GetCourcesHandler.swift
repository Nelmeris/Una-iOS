//
//  GetCourcesHandler.swift
//  PerfectTemplate
//
//  Created by Artem Kufaev on 24/05/2019.
//

import Foundation
import PerfectHTTP

class GetCourcesHandler: AbstractHandler {
    var request: HTTPRequest
    var response: HTTPResponse
    
    required init(request: HTTPRequest, response: HTTPResponse) {
        self.request = request
        self.response = response
    }
}

extension GetCourcesHandler {
    
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
        let json: [[String: Any]] = [
            [
                "title": "Местоимения",
                "learned_count": 10,
                "lessons_count": 10,
                "level": "A1"
            ],
            [
                "title": "Предлоги",
                "learned_count": 5,
                "lessons_count": 15,
                "level": "A2"
            ],
            [
                "title": "Падежи",
                "learned_count": 0,
                "lessons_count": 10,
                "level": "B1"
            ],
            [
                "title": "Времена",
                "learned_count": 9,
                "lessons_count": 20,
                "level": "B2"
            ],
            [
                "title": "Пассивный залог",
                "learned_count": 3,
                "lessons_count": 8,
                "level": "C1"
            ],
            [
                "title": "Склонения",
                "learned_count": 5,
                "lessons_count": 6,
                "level": "C2"
            ],
        ]
        
        do {
            try response.setBody(json: json)
        } catch {
            print(error)
        }
        response.completed()
    }
    
}
