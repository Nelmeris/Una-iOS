//
//  YLCource.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 24/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Alamofire

class YLCource: AbstractRequestFactory {
    let errorParser: AbstractErrorParser
    let sessionManager: SessionManager
    let queue: DispatchQueue?
    let baseUrl = URL(string: "http://127.0.0.1:8181/")!
    
    init(
        errorParser: AbstractErrorParser,
        sessionManager: SessionManager,
        queue: DispatchQueue? = DispatchQueue.global(qos: .utility)) {
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
    }
}

extension YLCource: YLCourceRequestFactory {
    
    func getCources(accessToken: String, completionHandler: @escaping (DataResponse<[YLCourceModel]>) -> Void) {
        let requestModel = GetCourcesRequest(baseUrl: baseUrl, accessToken: accessToken)
        self.request(request: requestModel, completionHandler: completionHandler).session.finishTasksAndInvalidate()
    }
    
}

extension YLCource {
    
    struct GetCourcesRequest: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "cources.get"
        
        let accessToken: String
        var parameters: Parameters? {
            return [
                "access_token": accessToken
            ]
        }
    }
    
}
