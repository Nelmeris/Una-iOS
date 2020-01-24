//
//  LoadLessonsUIOperation.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import CoreData

enum LoadLessonsUIOperationResult {
    case success([Lesson])
    case notFound
    case failure(Error)
}

class LoadLessonsUIOperation: BaseUIOperation {
    
    private let context: NSManagedObjectContext
    
    private let dbQueue: OperationQueue
    private let backendQueue: OperationQueue
    
    let loadFromDatabase: LoadLessonsDatabaseOperation
    private let loadFromBackend: LoadLessonsBackendOperation
    var saveToDatabase: SaveLessonsDatabaseOperation?
    
    private(set) var result: LoadLessonsUIOperationResult? { didSet { finish() } }
    private var lessons: [Lesson]?
    
    init(
        context: NSManagedObjectContext,
        backendQueue: OperationQueue,
        dbQueue: OperationQueue
        ) {
        self.context = context
        self.dbQueue = dbQueue
        self.backendQueue = backendQueue
        
        loadFromDatabase = LoadLessonsDatabaseOperation(context: context)
        loadFromBackend = LoadLessonsBackendOperation()
        
        super.init()
        
        startLoadFromDB()
        startLoadLessonsFromBackend()
    }
    
    private func startLoadFromDB() {
        let loadFromDBCompletion = BlockOperation {
            let result = self.loadFromDatabase.result!
            switch result {
            case .success(let lessons):
                self.lessons = lessons
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
        let loadLessonsFromBackendCompletion = BlockOperation {
            let result = self.loadFromBackend.result!
            switch result {
            case .success(let lessons):
                self.startSaveToDB(lessons: lessons)
            case .failure(let error):
                self.result = .failure(error)
            }
        }
        loadLessonsFromBackendCompletion.addDependency(loadFromBackend)
        commonQueue.addOperation(loadLessonsFromBackendCompletion)
        backendQueue.addOperation(loadFromBackend)
        self.addDependency(loadLessonsFromBackendCompletion)
    }
    
    private func startSaveToDB(lessons: [UnaLesson]) {
        let saveToDatabase = SaveLessonsDatabaseOperation(context: context, lessons: lessons)
        self.saveToDatabase = saveToDatabase
        let saveToDatabaseCompletion = BlockOperation {
            let result = saveToDatabase.result!
            switch result {
            case .success(let lessons):
                self.lessons = lessons
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
            let lessons = lessons else { return }
        self.result = .success(lessons)
    }
    
    override func cancel() {
        super.cancel()
        loadFromDatabase.cancel()
        loadFromBackend.cancel()
        saveToDatabase?.cancel()
    }

}

