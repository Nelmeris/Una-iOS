//
//  YLUser.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 24/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Alamofire

extension YLService: YLUserRequestFactory {
    
    func getInfo(accessToken: String, completionHandler: @escaping (DataResponse<YLUserModel>) -> Void) {
        let requestModel = YLUserRequest(baseUrl: baseUrl, accessToken: accessToken)
        self.request(request: requestModel, completionHandler: completionHandler).session.finishTasksAndInvalidate()
    }
    
}

extension YLService {
    
    struct YLUserRequest: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "user.getInfo"
        
        let accessToken: String
        var parameters: Parameters? {
            return [
                "access_token": accessToken
            ]
        }
    }
    
}
