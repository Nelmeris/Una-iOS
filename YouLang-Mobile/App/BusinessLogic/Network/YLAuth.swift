//
//  YLAuth.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 24/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Alamofire

extension YLService: YLAuthRequestFactory {
    
    func login(email: String, password: String, completionHandler: @escaping (DataResponse<YLLoginResponse>) -> Void) {
        let requestModel = LoginRequest(baseUrl: baseUrl, email: email, password: password)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func logout(accessToken: String, completionHandler: @escaping (DataResponse<YLLogoutResponse>) -> Void) {
        let requestModel = LogoutRequest(baseUrl: baseUrl, accessToken: accessToken)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func register(firstName: String, lastName: String, email: String, password: String, completionHandler: @escaping (DataResponse<YLRegisterResponse>) -> Void) {
        let requestModel = RegisterRequest(baseUrl: baseUrl, firstName: firstName, lastName: lastName, email: email, password: password)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
}

extension YLService {
    
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
