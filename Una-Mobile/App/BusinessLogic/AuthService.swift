//
//  AuthService.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 17.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import Keychain

final class AuthService {
    
    static let shared = AuthService()
    private init() {}
    
    private let accessTokenKey = "access_token"
    private let accessTokenRefreshKey = "access_token_refresh"
    
    func isAuth() -> Bool {
        return Keychain.load(accessTokenKey) != nil
    }
    
    func login(email: String, password: String, completion: @escaping (Bool, Error?) -> ()) {
        UnaNetworkManager.shared.login(email: email, password: password) { (token, error) in
            guard error == nil else {
                completion(false, error)
                return
            }
            guard let token = token else {
                completion(false, nil)
                return
            }
            guard Keychain.save(token.access, forKey: self.accessTokenKey),
                Keychain.save(token.refresh, forKey: self.accessTokenRefreshKey) else { fatalError() }
            completion(true, nil)
        }
    }
    
    func logout() {
        _ = Keychain.delete(accessTokenKey)
        _ = Keychain.delete(accessTokenRefreshKey)
    }
    
}
