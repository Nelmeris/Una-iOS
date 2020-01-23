//
//  AuthService.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 17.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import Keychain

final class AuthManager {
    
    static let shared = AuthManager()
    private init() {  }
    
    private let accessTokenKey = "access_token"
    private let accessTokenRefreshKey = "access_token_refresh"
    private let userEmailKey = "user_email"
    
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
            guard Keychain.save(email, forKey: self.userEmailKey),
                Keychain.save(token.access, forKey: self.accessTokenKey),
                Keychain.save(token.refresh, forKey: self.accessTokenRefreshKey) else { fatalError() }
            completion(true, nil)
        }
    }
    
    func logout() {
        _ = Keychain.delete(userEmailKey)
        _ = Keychain.delete(accessTokenKey)
        _ = Keychain.delete(accessTokenRefreshKey)
        goToAuth()
    }
    
    private func goToAuth() {
        let storyboardName = "Authorization"
        let viewControllerId = "Auth"
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: viewControllerId)
        let navControl = UINavigationController(rootViewController: controller)
        ApplicationRouter.shared.setAsRoot(navControl)
    }
    
    var token: String? {
        Keychain.load(accessTokenKey)
    }
    
    var refresh: String? {
        Keychain.load(accessTokenRefreshKey)
    }
    
    var userEmail: String? {
        Keychain.load(userEmailKey)
    }
    
}
