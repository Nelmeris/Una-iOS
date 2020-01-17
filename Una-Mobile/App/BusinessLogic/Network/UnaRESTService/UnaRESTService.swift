//
//  UnaRESTService.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 11.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Moya

enum UnaRESTService {
    case login(email: String, password: String)
    case getLessons
}

extension UnaRESTService: TargetType {
    
    var baseURL: URL {
        switch self {
        case .login(email: _, password: _):
            return URL(string: "http://5.23.55.140/api-auth/")!
        case .getLessons:
            return URL(string: "http://5.23.55.140/api/")!
        }
    }
    
    var path: String {
        switch self {
        case .login(email: _, password: _):
            return "login"
        case .getLessons:
            return "lessons/"
        }
    }
    
    var method: Method {
        switch self {
        case .login(email: _, password: _):
            return .post
        case .getLessons:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .login(email: let email, password: let password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: URLEncoding.queryString)
        case .getLessons:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }

}
