//
//  YLAuth.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 24/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Alamofire

class YLAuth: AbstractRequestFactory {
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

extension YLAuth: YLAuthRequestFactory {
    
    func login(email: String, password: String, completionHandler: @escaping (DataResponse<YLLoginResponse>) -> Void) {
        let requestModel = LoginRequest(baseUrl: baseUrl, email: email, password: password)
        self.request(request: requestModel, completionHandler: completionHandler).session.finishTasksAndInvalidate()
    }
    
    func logout(accessToken: String, completionHandler: @escaping (DataResponse<YLLogoutResponse>) -> Void) {
        let requestModel = LogoutRequest(baseUrl: baseUrl, accessToken: accessToken)
        self.request(request: requestModel, completionHandler: completionHandler).session.finishTasksAndInvalidate()
    }
    
    func register(firstName: String, lastName: String, email: String, password: String, completionHandler: @escaping (DataResponse<YLRegisterResponse>) -> Void) {
        let requestModel = RegisterRequest(baseUrl: baseUrl, firstName: firstName, lastName: lastName, email: email, password: password)
        self.request(request: requestModel, completionHandler: completionHandler).session.finishTasksAndInvalidate()
    }
    
}

extension YLAuth {
    
    struct LoginRequest: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "auth.login"
        
        let email: String
        let password: String
        var parameters: Parameters? {
            return [
                "email": email,
                "password": password
            ]
        }
    }
    
    struct RegisterRequest: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "auth.register"
        
        let firstName: String
        let lastName: String
        let email: String
        let password: String
        
        var parameters: Parameters? {
            return [
                "first_name": firstName,
                "last_name": lastName,
                "email": email,
                "password": password
            ]
        }
    }
    
    struct LogoutRequest: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "auth.logout"
        
        let accessToken: String
        var parameters: Parameters? {
            return [
                "access_token": accessToken
            ]
        }
    }
    
}
