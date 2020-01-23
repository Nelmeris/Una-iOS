//
//  UnaAPI.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 17.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Moya

enum UnaAPI {
    case login(String, String)
}

extension UnaAPI : TargetType {
    
    var baseURL: URL {
        return URL(string: "http://5.23.55.140/api/")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "token/"
        }
    }
    
    var method: Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .login(let email, let password):
            return .requestParameters(parameters: ["username": email, "password": password], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json; charset=UTF-8"]
    }
    
}
