//
//  LoadLessonsDatabaseOperation.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import CoreData

enum LoadLessonsDatabaseOperationResult {
    case success([Lesson])
    case failure(Error)
}

class LoadLessonsDatabaseOperation: BaseDatabaseOperation {
    
    private(set) var result: LoadLessonsDatabaseOperationResult? { didSet { finish() } }
    
    override func main() {
        guard !self.isCancelled else { return }
        let dbService = LessonCoreDataService(context: context)
        do {
            let lessons = try dbService.load()
            self.result = .success(lessons)
        } catch {
            self.result = .failure(error)
        }
    }
    
}
