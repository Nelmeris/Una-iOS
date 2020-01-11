//
//  UnaService.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 07.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import PostgresClientKit
import Alamofire

class UnaService: AbstractPostgresRequestFactory, AbstractRequestFactory {
    
    var errorParser: AbstractErrorParser
    var sessionManager: SessionManager
    var queue: DispatchQueue?
    let baseUrl = URL(string: "http://5.23.55.140/")!
    
    var configuration: ConnectionConfiguration
    
    static let shared = UnaService()
    
    private init() {
        let dbFactory = UnaRequestDBFactory()
        let restFactory = UnaRequestRESTFactory()
        configuration = dbFactory.makeConfiguration()
        errorParser = restFactory.makeErrorParser()
        queue = restFactory.sessionQueue
        sessionManager = restFactory.commonSessionManager
    }
    
}
