//
//  LoadLessonPartsUIOperation.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import CoreData

enum LoadLessonPartsUIOperationResult {
    case success([LessonPart])
    case notFound
    case failure(Error)
}

class LoadLessonPartsUIOperation: BaseUIOperation {
    
    private let context: NSManagedObjectContext
    
    private let dbQueue: OperationQueue
    private let backendQueue: OperationQueue
    
    let loadFromDatabase: LoadLessonPartsDatabaseOperation
    private let loadFromBackend: LoadLessonPartsBackendOperation
    var saveToDatabase: SaveLessonPartsDatabaseOperation?
    
    private(set) var result: LoadLessonPartsUIOperationResult? { didSet { finish() } }
    private var lessonParts: [LessonPart]?
    
    init(
        with lessonId: Int,
        context: NSManagedObjectContext,
        backendQueue: OperationQueue,
        dbQueue: OperationQueue
        ) {
        self.context = context
        self.dbQueue = dbQueue
        self.backendQueue = backendQueue
        
        loadFromDatabase = LoadLessonPartsDatabaseOperation(context: context)
        loadFromBackend = LoadLessonPartsBackendOperation(with: lessonId)
        
        super.init()
        
        startLoadFromDB()
        startLoadLessonsFromBackend()
    }
    
    private func startLoadFromDB() {
        let loadFromDBCompletion = BlockOperation {
            let result = self.loadFromDatabase.result!
            switch result {
            case .success(let lessonParts):
                self.lessonParts = lessonParts
            case .failure(let error):
                self.result = .failure(error)
            }
        }
        loadFromDBCompletion.addDependency(loadFromDatabase)
        commonQueue.addOperation(loadFromDBCompletion)
        dbQueue.addOperation(loadFromDatabase)
        self.addDependency(loadFromDBCompletion)
    }
    
    private func startLoadLessonsFromBackend() {
        let loadFromBackendCompletion = BlockOperation {
            let result = self.loadFromBackend.result!
            switch result {
            case .success(let lessonParts):
                self.startSaveToDB(with: lessonParts)
            case .failure(let error):
                self.result = .failure(error)
            }
        }
        loadFromBackendCompletion.addDependency(loadFromBackend)
        commonQueue.addOperation(loadFromBackendCompletion)
        backendQueue.addOperation(loadFromBackend)
        self.addDependency(loadFromBackendCompletion)
    }
    
    private func startSaveToDB(with lessonParts: [UnaLessonPart]) {
        let saveToDatabase = SaveLessonPartsDatabaseOperation(context: context, parts: lessonParts)
        self.saveToDatabase = saveToDatabase
        let saveToDatabaseCompletion = BlockOperation {
            let result = saveToDatabase.result!
            switch result {
            case .success(let lessonParts):
                self.lessonParts = lessonParts
            case .failure(let error):
                self.result = .failure(error)
            }
        }
        saveToDatabaseCompletion.addDependency(saveToDatabase)
        commonQueue.addOperation(saveToDatabaseCompletion)
        dbQueue.addOperation(saveToDatabase)
        self.addDependency(saveToDatabaseCompletion)
    }
    
    override func main() {
        guard !self.isFinished,
            loadFromDatabase.isFinished,
            loadFromBackend.isFinished,
            saveToDatabase?.isFinished ?? true,
            let lessonParts = lessonParts else { return }
        self.result = .success(lessonParts)
    }
    
    override func cancel() {
        super.cancel()
        loadFromDatabase.cancel()
        loadFromBackend.cancel()
        saveToDatabase?.cancel()
    }

}
