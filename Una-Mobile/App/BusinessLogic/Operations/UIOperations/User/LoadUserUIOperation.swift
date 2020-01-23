//
//  LoadUserUIOperation.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import CoreData

enum LoadUserUIOperationResult {
    case success(User)
    case notFound
    case failure(Error)
}

class LoadUserUIOperation: BaseUIOperation {
    
    private let userEmail: String
    private let context: NSManagedObjectContext
    
    private let dbQueue: OperationQueue
    private let backendQueue: OperationQueue
    
    let loadFromDatabase: LoadUserDatabaseOperation
    let loadFromBackend: LoadUserBackendOperation
    var saveToDatabase: SaveUserDatabaseOperation?
    
    private(set) var result: LoadUserUIOperationResult? { didSet { finish() } }
    private var user: User?
    
    init(
        userEmail: String,
        context: NSManagedObjectContext,
        backendQueue: OperationQueue,
        dbQueue: OperationQueue
        ) {
        self.userEmail = userEmail
        self.context = context
        self.dbQueue = dbQueue
        self.backendQueue = backendQueue
        
        loadFromDatabase = LoadUserDatabaseOperation(context: context, userEmail: userEmail)
        loadFromBackend = LoadUserBackendOperation(userEmail: userEmail)
        
        super.init()
        
        startLoadFromDB()
        startLoadFromBackend()
    }
    
    private func startLoadFromDB() {
        let loadFromDBCompletion = BlockOperation(block: self.loadFromDatabaseCompletion)
        loadFromDBCompletion.addDependency(loadFromDatabase)
        commonQueue.addOperation(loadFromDBCompletion)
        dbQueue.addOperation(loadFromDatabase)
        self.addDependency(loadFromDBCompletion)
    }
    
    private func startLoadFromBackend() {
        let loadFromBackendCompletion = BlockOperation(block: self.loadFromBackendCompletion)
        loadFromBackendCompletion.addDependency(loadFromBackend)
        commonQueue.addOperation(loadFromBackendCompletion)
        backendQueue.addOperation(loadFromBackend)
        self.addDependency(loadFromBackendCompletion)
    }
    
    private func loadFromDatabaseCompletion() {
        guard let result = loadFromDatabase.result else { fatalError() }
        switch result {
        case .success(let user):
            self.user = user
        case .failure(let error):
            self.result = .failure(error)
        case .notFound:
            self.result = .notFound
        }
    }
    
    private func loadFromBackendCompletion() {
        guard let result = loadFromBackend.result else { fatalError() }
        switch result {
        case .failure(let error):
            self.result = .failure(error)
        case .notFound:
            self.result = .notFound
        case .success(let authUser, let userProfile):
            startSaveToDB(authUser: authUser, userProfile: userProfile)
        }
    }
    
    private func startSaveToDB(authUser: UnaAuthUser, userProfile: UnaUserProfile) {
        let saveToDatabase = SaveUserDatabaseOperation(context: context, authUser: authUser, userProfile: userProfile)
        self.saveToDatabase = saveToDatabase
        let saveToDatabaseCompletion = BlockOperation(block: self.saveToDababaseCompletion)
        saveToDatabaseCompletion.addDependency(saveToDatabase)
        commonQueue.addOperation(saveToDatabaseCompletion)
        dbQueue.addOperation(saveToDatabase)
        self.addDependency(saveToDatabaseCompletion)
    }
    
    private func saveToDababaseCompletion() {
        guard let result = saveToDatabase?.result else { fatalError() }
        switch result {
        case .success(let user):
            self.user = user
        case .failure(let error):
            self.result = .failure(error)
        }
    }
    
    override func main() {
        guard !self.isFinished,
            loadFromDatabase.isFinished,
            loadFromBackend.isFinished,
            saveToDatabase?.isFinished ?? true,
            let user = user else { return }
        self.result = .success(user)
    }
    
    override func cancel() {
        super.cancel()
        loadFromDatabase.cancel()
        loadFromBackend.cancel()
        saveToDatabase?.cancel()
    }

}

