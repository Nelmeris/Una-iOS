//
//  SaveUserDataBaseOperation.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import CoreData

enum SaveUserDataBaseOperationResult {
    case success
    case failure(Error)
}

class SaveUserDataBaseOperation: BaseDataBaseOperation {
    
    private(set) var result: SaveUserDataBaseOperationResult? { didSet { finish() } }
    private let user: User
    
    init(context: NSManagedObjectContext, user: User) {
        self.user = user
        super.init(context: context)
    }
    
    override func main() {
        guard !self.isCancelled else { return }
        let dbService = UserCoreDataService(context: context)
        dbService.saveContext { error in
            if let error = error {
                self.result = .failure(error)
            } else {
                self.result = .success
            }
        }
    }
    
}
