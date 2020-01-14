//
//  UnaRequestRESTFactory.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 11.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Alamofire

final class UnaRequestRESTFactory {
    
    let sessionQueue = DispatchQueue.global(qos: .utility)
    
    func makeErrorParser() -> AbstractErrorParser {
        return UnaErrorParser()
    }
    
    lazy var commonSessionManager: SessionManager = {
        var configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        let manager = SessionManager(configuration: configuration)
        return manager
    }()
    
}
