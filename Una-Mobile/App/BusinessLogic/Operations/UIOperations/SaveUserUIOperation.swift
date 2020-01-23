//
//  SaveUserUIOperation.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import CoreData

enum SaveUserUIOperationResult {
    case success
    case failure(Error)
}

class SaveUserUIOperation: BaseUIOperation {
    
    private let user: User
    private let context: NSManagedObjectContext
    
    private let dbQueue: OperationQueue
    private let backendQueue: OperationQueue
    
    let saveToDatabase: SaveUserDataBaseOperation
    let saveToBackend: SaveUserBackendOperation
    
    private(set) var result: SaveUserUIOperationResult? { didSet { finish() } }
    
    init(
        user: User,
        context: NSManagedObjectContext,
        backendQueue: OperationQueue,
        dbQueue: OperationQueue
        ) {
        self.user = user
        self.context = context
        self.dbQueue = dbQueue
        self.backendQueue = backendQueue
        
        let authUser = UnaAuthUser(from: user)
        let userProfile = UnaUserProfile(from: user)
        saveToDatabase = SaveUserDataBaseOperation(context: context, user: user)
        saveToBackend = SaveUserBackendOperation(authUser: authUser, userProfile: userProfile)
        
        super.init()
        
        let saveToDBCompletion = BlockOperation(block: self.saveToDataBaseCompletion)
        saveToDBCompletion.addDependency(saveToDatabase)
        commonQueue.addOperation(saveToDBCompletion)
        dbQueue.addOperation(saveToDatabase)
        
        let saveToBackendCompletion = BlockOperation(block: self.saveToBackendCompletion)
        saveToBackendCompletion.addDependency(saveToBackend)
        commonQueue.addOperation(saveToBackendCompletion)
        backendQueue.addOperation(saveToBackend)
        
        self.addDependency(saveToDBCompletion)
        self.addDependency(saveToBackendCompletion)
    }
    
    private func saveToDataBaseCompletion() {
        guard let result = saveToDatabase.result else { fatalError() }
        switch result {
        case .failure(let error):
            self.result = .failure(error)
        default: break
        }
    }
    
    private func saveToBackendCompletion() {
        guard let result = saveToBackend.result else { fatalError() }
        switch result {
        case .failure(let error):
            self.result = .failure(error)
        default: break
        }
    }
    
    override func main() {
        guard saveToDatabase.isFinished,
            saveToBackend.isFinished else { fatalError() }
        self.result = .success
    }
    
    override func cancel() {
        super.cancel()
        saveToBackend.cancel()
        saveToDatabase.cancel()
    }

}
