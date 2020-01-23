//
//  LoadLessonTasksBackendOperation.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation

enum LoadLessonTasksBackendOperationResult {
    case success([UnaLessonTask])
    case failure(Error)
}

class LoadLessonTasksBackendOperation: BaseBackendOperation {
    
    private(set) var result: LoadLessonTasksBackendOperationResult? { didSet { finish() } }
    private let lessonPartId: Int
    
    init(with lessonPartId: Int) {
        self.lessonPartId = lessonPartId
        super.init()
    }
    
    override func main() {
        guard !self.isCancelled else { return }
        do {
            try UnaDBService.shared.getTasks(for: lessonPartId) { tasks in
                self.result = .success(tasks)
            }
        } catch {
            self.result = .failure(error)
        }
    }
    
}
