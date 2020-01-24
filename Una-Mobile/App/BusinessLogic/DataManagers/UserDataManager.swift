//
//  UserDataManager.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation

final class UserDataManager: BaseDataManager {
    
    static let `default` = UserDataManager()
    
    enum GetResult {
        case success(User)
        case failure(Error)
    }
    
    func get(with email: String, completion: @escaping (GetResult) -> ()) {
        let loadOperation = LoadUserUIOperation(userEmail: email, context: context, backendQueue: backendQueue, dbQueue: dbQueue)
        loadOperation.loadFromDatabase.completionBlock = {
            guard let result = loadOperation.loadFromDatabase.result else { fatalError() }
            switch result {
            case .success(let user):
                completion(.success(user))
            case .notFound: break
            case .failure(let error):
                completion(.failure(error))
            }
        }
        loadOperation.completionBlock = {
            guard let result = loadOperation.result else { fatalError() }
            switch result {
            case .success(let user):
                completion(.success(user))
            case .notFound: fatalError("Данные авторизованного пользователя не найдены на сервере")
            case .failure(let error):
                completion(.failure(error))
            }
        }
        uiQueue.addOperation(loadOperation)
    }
    
    enum SaveResult {
        case success
        case failure(Error)
    }
    
    func save(_ user: User, completion: @escaping (SaveResult) -> ()) {
        let saveOperation = SaveUserUIOperation(user: user, context: context, backendQueue: backendQueue, dbQueue: dbQueue)
        saveOperation.saveToDatabase.completionBlock = {
            guard let result = saveOperation.saveToDatabase.result else { fatalError() }
            switch result {
            case .success:
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
        saveOperation.completionBlock = {
            guard let result = saveOperation.result else { fatalError() }
            switch result {
            case .success:
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
        uiQueue.addOperation(saveOperation)
    }
    
}
