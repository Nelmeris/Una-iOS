//
//  LoadLessonTasksDatabaseOperation.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import CoreData

enum LoadLessonTasksDatabaseOperationResult {
    case success([LessonTask])
    case failure(Error)
}

class LoadLessonTasksDatabaseOperation: BaseDatabaseOperation {
    
    private(set) var result: LoadLessonTasksDatabaseOperationResult? { didSet { finish() } }
    
    override func main() {
        guard !self.isCancelled else { return }
        let dbService = LessonTaskCoreDataService(context: context)
        do {
            let lessonParts = try dbService.load()
            self.result = .success(lessonParts)
        } catch {
            self.result = .failure(error)
        }
    }
    
}
