//
//  YLRequestFactory.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 24/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Alamofire

class YLRequestFactory {
    func makeErrorParser() -> AbstractErrorParser {
        return YLErrorParser()
    }
    
    lazy var commonSessionManager: SessionManager = {
        var configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        let manager = SessionManager(configuration: configuration)
        return manager
    }()
    
    let sessionQueue = DispatchQueue.global(qos: .utility)
    
    func makeAuthRequestFatory() -> YLAuthRequestFactory {
        let errorParser = makeErrorParser()
        return YLAuth(errorParser: errorParser, sessionManager: commonSessionManager, queue: sessionQueue)
    }
    
    func makeUserRequestFactory() -> YLUserRequestFactory {
        let errorParser = makeErrorParser()
        return YLUser(errorParser: errorParser, sessionManager: commonSessionManager, queue: sessionQueue)
    }
    
    func makeCourceRequestFactory() -> YLCourceRequestFactory {
        let errorParser = makeErrorParser()
        return YLCource(errorParser: errorParser, sessionManager: commonSessionManager, queue: sessionQueue)
    }
}
