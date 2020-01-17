//
//  UnaNetworkManager.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 17.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

class UnaNetworkManager: UnaNetworkable {
    
    public static let shared = UnaNetworkManager()
    
    private let errorParser: UnaNetworkErrorParser
    private init() {
        errorParser = UnaNetworkErrorParser()
    }
    
    var provider = MoyaProvider<UnaAPI>()
    
    func login(email: String, password: String, completion: @escaping (AccessToken?, Error?) -> ()) {
        provider.request(.login(email, password), errorParser: errorParser, objectModel: AccessToken.self, success: { (response) in
            completion(response, nil)
        }) { (error) in
            completion(nil, error)
        }
    }
    
}
