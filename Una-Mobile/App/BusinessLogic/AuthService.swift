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
    
    var group = DispatchGroup()
    
    func getUser(completion: @escaping (User?) -> ()) {
        guard let email = AuthService.shared.userEmail else {
            completion(nil)
            return
        }
        let context = BaseCoreDataService.persistentContainer.viewContext
        let db = UserCoreDataService(context: context)
        DispatchQueue.global().async {
            do {
                if let user = try db.loadUsers(email: email).first {
                    DispatchQueue.main.async {
                        completion(user)
                    }
                }
                self.group.wait()
                self.group.enter()
                try UnaDBService.shared.getUser(with: email) { user in
                    guard let user = user else { fatalError() }
                    do {
                        try UnaDBService.shared.getUserProfile(with: user.id) { profile in
                            self.group.leave()
                            guard let profile = profile else { fatalError() }
                            do {
                                let dbUser = try db.saveUser(authUser: user, profile: profile) { error in
                                    if let error = error {
                                        print(error)
                                    }
                                }
                                DispatchQueue.main.async {
                                    completion(dbUser)
                                }
                            } catch {
                                print(error)
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            } catch {
               print(error)
               completion(nil)
           }
        }
    }
    
    func saveUserChanges(_ user: User, completion: @escaping () -> ()) {
        let unaAuthUser = UnaAuthUser(from: user)
        let unaUserProfile = UnaUserProfile(from: user)
        let context = BaseCoreDataService.persistentContainer.viewContext
        let db = UserCoreDataService(context: context)
        DispatchQueue.global().async {
            db.saveContext { error in
                DispatchQueue.main.async {
                    completion()
                }
                if let error = error {
                    print(error)
                }
            }
            do {
                self.group.wait()
                self.group.enter()
                try UnaDBService.shared.putUserAuth(with: unaAuthUser) {
                    self.group.leave()
                    do {
                        try UnaDBService.shared.putUserProfile(with: unaUserProfile) { }
                    } catch {
                        print(error)
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
}
