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
    
    var group = DispatchGroup()
    
    func getUser(completion: @escaping (User?, Error?) -> ()) {
        guard let email = AuthManager.shared.userEmail else {
            completion(nil, nil)
            logout()
            return
        }
        
        let context = BaseCoreDataService.persistentContainer.viewContext
        let backendQueue = BaseBackendOperation.queue
        let dbQueue = BaseDataBaseOperation.queue
        
        let loadUserOperation = LoadUserUIOperation(userEmail: email, context: context, backendQueue: backendQueue, dbQueue: dbQueue)
        loadUserOperation.loadFromDatabase.completionBlock = {
            guard let result = loadUserOperation.loadFromDatabase.result else { fatalError() }
            switch result {
            case .success(let user):
                completion(user, nil)
            case .notFound: break
            case .failure(let error):
                completion(nil, error)
            }
        }
        loadUserOperation.completionBlock = {
            guard let result = loadUserOperation.result else { fatalError() }
            switch result {
            case .success(let user):
                completion(user, nil)
            case .notFound: break
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func saveUserChanges(_ user: User, completion: @escaping (Error?) -> ()) {
        let context = BaseCoreDataService.persistentContainer.viewContext
        let backendQueue = BaseBackendOperation.queue
        let dbQueue = BaseDataBaseOperation.queue
        
        let saveUserUIOperation = SaveUserUIOperation(user: user, context: context, backendQueue: backendQueue, dbQueue: dbQueue)
        saveUserUIOperation.saveToDatabase.completionBlock = {
            guard let result = saveUserUIOperation.saveToDatabase.result else { fatalError() }
            switch result {
            case .success:
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
        saveUserUIOperation.completionBlock = {
            guard let result = saveUserUIOperation.result else { fatalError() }
            switch result {
            case .success:
                completion(nil)
            case .failure(let error):
                completion(error)
            }
            
        }
        BaseUIOperation.queue.addOperation(saveUserUIOperation)
    }
    
}
