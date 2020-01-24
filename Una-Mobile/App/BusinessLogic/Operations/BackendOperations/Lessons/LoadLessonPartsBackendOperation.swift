//
//  LoadLessonPartsBackendOperation.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation

enum LoadLessonPartsBackendOperationResult {
    case success([UnaLessonPart])
    case failure(Error)
}

class LoadLessonPartsBackendOperation: BaseBackendOperation {
    
    private(set) var result: LoadLessonPartsBackendOperationResult? { didSet { finish() } }
    private let lessonId: Int
    
    init(with lessonId: Int) {
        self.lessonId = lessonId
        super.init()
    }
    
    override func main() {
        guard !self.isCancelled else { return }
        do {
            try UnaDBService.shared.getLessonParts(for: lessonId) { lessons in
                self.result = .success(lessons)
            }
        } catch {
            self.result = .failure(error)
        }
    }
    
}
