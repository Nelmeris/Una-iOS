//
//  LoadLessonsBackendOperation.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation

enum LoadLessonsBackendOperationResult {
    case success([UnaLesson])
    case failure(Error)
}

class LoadLessonsBackendOperation: BaseBackendOperation {
    
    private(set) var result: LoadLessonsBackendOperationResult? { didSet { finish() } }
    
    override func main() {
        guard !self.isCancelled else { return }
        do {
            try UnaDBService.shared.getLessons { lessons in
                self.result = .success(lessons)
            }
        } catch {
            self.result = .failure(error)
        }
    }
    
}
