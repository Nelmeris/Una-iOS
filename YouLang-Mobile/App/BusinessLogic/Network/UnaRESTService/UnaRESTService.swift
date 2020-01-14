//
//  UnaRESTService.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 11.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Alamofire

class UnaRESTService: AbstractRequestFactory {
    
    private let host = URL(string: "http://5.23.55.140/")!
    
    var errorParser: AbstractErrorParser
    var sessionManager: SessionManager
    var queue: DispatchQueue?
    
    static let shared = UnaRESTService()
    
    private init() {
        let factory = UnaRequestRESTFactory()
        self.errorParser = factory.makeErrorParser()
        self.sessionManager = factory.commonSessionManager
        self.queue = factory.sessionQueue
    }
    
}
