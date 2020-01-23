//
//  LoadUserDataBaseOperation.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import CoreData

enum LoadUserDataBaseOperationResult {
    case success(User)
    case notFound
    case failure(Error)
}

class LoadUserDataBaseOperation: BaseDataBaseOperation {
    
    private(set) var result: LoadUserDataBaseOperationResult? { didSet { finish() } }
    private let email: String
    
    init(context: NSManagedObjectContext, userEmail: String) {
        self.email = userEmail
        super.init(context: context)
    }
    
    override func main() {
        guard !self.isCancelled else { return }
        let dbService = UserCoreDataService(context: context)
        do {
            guard let user = try dbService.loadUser(email: email) else {
                self.result = .notFound
                return
            }
            self.result = .success(user)
        } catch {
            self.result = .failure(error)
        }
    }
    
}
