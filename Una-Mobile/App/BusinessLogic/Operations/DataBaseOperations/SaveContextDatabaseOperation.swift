//
//  SaveContextDatabaseOperation.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import CoreData

enum SaveContextDatabaseOperationResult {
    case success
    case failure(Error)
}

class SaveContextDatabaseOperation: BaseDatabaseOperation {
    
    private(set) var result: SaveContextDatabaseOperationResult? { didSet { finish() } }
    
    override func main() {
        guard !self.isCancelled else { return }
        let dbService = BaseCoreDataService(context: context)
        dbService.saveContext { error in
            if let error = error {
                self.result = .failure(error)
            } else {
                self.result = .success
            }
        }
    }
    
}
