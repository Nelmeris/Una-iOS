//
//  SaveLessonPartsDatabaseOperation.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import CoreData

enum SaveLessonPartsDatabaseOperationResult {
    case success([LessonPart])
    case failure(Error)
}

class SaveLessonPartsDatabaseOperation: BaseDatabaseOperation {
    
    private(set) var result: SaveLessonPartsDatabaseOperationResult? { didSet { finish() } }
    private let parts: [UnaLessonPart]
    
    init(context: NSManagedObjectContext, parts: [UnaLessonPart]) {
        self.parts = parts
        super.init(context: context)
    }
    
    override func main() {
        guard !self.isCancelled else { return }
        let dbService = LessonPartCoreDataService(context: context)
        do {
            try dbService.save(self.parts) { result in
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
