//
//  SaveLessonsDatabaseOperation.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import CoreData

enum SaveLessonsDatabaseOperationResult {
    case success([Lesson])
    case failure(Error)
}

class SaveLessonsDatabaseOperation: BaseDatabaseOperation {
    
    private(set) var result: SaveLessonsDatabaseOperationResult? { didSet { finish() } }
    private let lessons: [UnaLesson]
    
    init(context: NSManagedObjectContext, lessons: [UnaLesson]) {
        self.lessons = lessons
        super.init(context: context)
    }
    
    override func main() {
        guard !self.isCancelled else { return }
        let dbService = LessonCoreDataService(context: context)
        do {
            try dbService.save(self.lessons) { result in
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
