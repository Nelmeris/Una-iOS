//
//  YLService.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 28/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Alamofire

class YLService: AbstractRequestFactory {
    let errorParser: AbstractErrorParser
    let sessionManager: SessionManager
    let queue: DispatchQueue?
    let baseUrl = URL(string: "http://10.0.0.2:8181/")! 
    
    static let shared = YLService()
    
    private init() {
        let factory = YLRequestFactory()
        self.errorParser = factory.makeErrorParser()
        self.sessionManager = factory.commonSessionManager
        self.queue = factory.sessionQueue
    }
}
