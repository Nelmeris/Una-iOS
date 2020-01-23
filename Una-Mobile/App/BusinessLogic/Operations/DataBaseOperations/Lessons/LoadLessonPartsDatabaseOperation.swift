//
//  LoadLessonPartsDatabaseOperation.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import CoreData

enum LoadLessonPartsDatabaseOperationResult {
    case success([LessonPart])
    case failure(Error)
}

class LoadLessonPartsDatabaseOperation: BaseDatabaseOperation {
    
    private(set) var result: LoadLessonPartsDatabaseOperationResult? { didSet { finish() } }
    
    override func main() {
        guard !self.isCancelled else { return }
        let dbService = LessonPartCoreDataService(context: context)
        do {
            let lessonParts = try dbService.load()
            self.result = .success(lessonParts)
        } catch {
            self.result = .failure(error)
        }
    }
    
}
