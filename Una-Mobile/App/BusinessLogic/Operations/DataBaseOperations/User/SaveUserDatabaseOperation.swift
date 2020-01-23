//
//  SaveUserDatabaseOperation.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import CoreData

enum SaveUserDatabaseOperationResult {
    case success(User)
    case failure(Error)
}

class SaveUserDatabaseOperation: BaseDatabaseOperation {
    
    private(set) var result: SaveUserDatabaseOperationResult? { didSet { finish() } }
    private let authUser: UnaAuthUser
    private let userProfile: UnaUserProfile
    
    init(context: NSManagedObjectContext, authUser: UnaAuthUser, userProfile: UnaUserProfile) {
        self.authUser = authUser
        self.userProfile = userProfile
        super.init(context: context)
    }
    
    override func main() {
        guard !self.isCancelled else { return }
        let dbService = UserCoreDataService(context: context)
        do {
            try dbService.save(authUser: authUser, profile: userProfile) { result in
                switch result {
                case .success(let user):
                    self.result = .success(user)
                case .failure(let error):
                    self.result = .failure(error)
                }
            }
        } catch {
            self.result = .failure(error)
        }
    }
    
}
