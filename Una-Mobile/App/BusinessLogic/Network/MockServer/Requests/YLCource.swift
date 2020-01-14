//
//  YLCource.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 24/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Alamofire

extension YLService: YLCourceRequestFactory {
    
    func getCources(accessToken: String, completionHandler: @escaping (DataResponse<[YLCourceModel]>) -> Void) {
        let requestModel = GetCourcesRequest(baseUrl: baseUrl, accessToken: accessToken)
        self.request(request: requestModel, completionHandler: completionHandler).session.finishTasksAndInvalidate()
    }
    
}

extension YLService {
    
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
