//
//  SaveUserDataBaseOperation.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import CoreData

enum SaveBackendUserDataBaseOperationResult {
    case success(User)
    case failure(Error)
}

class SaveBackendUserDataBaseOperation: BaseDataBaseOperation {
    
    private(set) var result: SaveBackendUserDataBaseOperationResult? { didSet { finish() } }
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
            let user = try dbService.saveUser(authUser: authUser, profile: userProfile) { error in
                if let error = error {
                    self.result = .failure(error)
                }
            }
            self.result = .success(user)
        } catch {
            self.result = .failure(error)
        }
    }
    
}
