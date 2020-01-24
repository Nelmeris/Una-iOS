//
//  SaveLessonTasksDatabaseOperation.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import CoreData

enum SaveLessonTasksDatabaseOperationResult {
    case success([LessonTask])
    case failure(Error)
}

class SaveLessonTasksDatabaseOperation: BaseDatabaseOperation {
    
    private(set) var result: SaveLessonTasksDatabaseOperationResult? { didSet { finish() } }
    private let tasks: [UnaLessonTask]
    
    init(context: NSManagedObjectContext, tasks: [UnaLessonTask]) {
        self.tasks = tasks
        super.init(context: context)
    }
    
    override func main() {
        guard !self.isCancelled else { return }
        let dbService = LessonTaskCoreDataService(context: context)
        do {
            try dbService.save(self.tasks) { result in
                switch result {
                case .success(let lessons):
                    self.result = .success(lessons)
                case .failure(let error):
                    self.result = .failure(error)
                }
            }
        } catch {
            self.result = .failure(error)
        }
    }
    
}
