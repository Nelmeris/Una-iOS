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
    private let usernameKey = "username"
    
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
            guard Keychain.save(email, forKey: self.usernameKey),
                Keychain.save(token.access, forKey: self.accessTokenKey),
                Keychain.save(token.refresh, forKey: self.accessTokenRefreshKey) else { fatalError() }
            completion(true, nil)
        }
    }
    
    func logout() {
        _ = Keychain.delete(usernameKey)
        _ = Keychain.delete(accessTokenKey)
        _ = Keychain.delete(accessTokenRefreshKey)
    }
    
    var token: String? {
        Keychain.load(accessTokenKey)
    }
    
    var refresh: String? {
        Keychain.load(accessTokenRefreshKey)
    }
    
    var username: String? {
        Keychain.load(usernameKey)
    }
    
    private var userCache: UnaAuthUser?
    private var userProfileCache: UnaUserProfile?
    
    func getUser(completion: @escaping ((UnaAuthUser, UnaUserProfile)?) -> ()) {
        if let user = userCache,
            let profile = userProfileCache {
            completion((user, profile))
            return
        }
        guard let username = AuthService.shared.username else {
            completion(nil)
            return
        }
        do {
            try UnaDBService.shared.getUser(with: username) { user in
                guard let user = user else { fatalError() }
                self.userCache = user
                do {
                    try UnaDBService.shared.getUserProfile(with: user.id) { profile in
                        guard let profile = profile else { fatalError() }
                        self.userProfileCache = profile
                        completion((user, profile))
                    }
                } catch {
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
}
