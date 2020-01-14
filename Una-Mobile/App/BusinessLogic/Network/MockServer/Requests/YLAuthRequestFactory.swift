//
//  YLAuthRequestFactory.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 24/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Alamofire

protocol YLAuthRequestFactory {
    func login(email: String, password: String, completionHandler: @escaping (DataResponse<YLLoginResponse>) -> Void)
    func logout(accessToken: String, completionHandler: @escaping (DataResponse<YLLogoutResponse>) -> Void)
    func register(firstName: String, lastName: String, email: String, password: String, completionHandler: @escaping (DataResponse<YLRegisterResponse>) -> Void)
}
