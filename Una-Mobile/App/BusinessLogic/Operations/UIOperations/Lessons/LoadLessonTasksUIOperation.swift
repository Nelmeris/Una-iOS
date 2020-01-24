//
//  LoadLessonTasksUIOperation.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import CoreData

enum LoadLessonTasksUIOperationResult {
    case success([LessonTask])
    case notFound
    case failure(Error)
}

class LoadLessonTasksUIOperation: BaseUIOperation {
    
    private let context: NSManagedObjectContext
    
    private let dbQueue: OperationQueue
    private let backendQueue: OperationQueue
    
    let loadFromDatabase: LoadLessonTasksDatabaseOperation
    private let loadFromBackend: LoadLessonTasksBackendOperation
    var saveToDatabase: SaveLessonTasksDatabaseOperation?
    
    private(set) var result: LoadLessonTasksUIOperationResult? { didSet { finish() } }
    private var lessonTasks: [LessonTask]?
    
    init(
        with partId: Int,
        context: NSManagedObjectContext,
        backendQueue: OperationQueue,
        dbQueue: OperationQueue
        ) {
        self.context = context
        self.dbQueue = dbQueue
        self.backendQueue = backendQueue
        
        loadFromDatabase = LoadLessonTasksDatabaseOperation(context: context)
        loadFromBackend = LoadLessonTasksBackendOperation(with: partId)
        
        super.init()
        
        startLoadFromDB()
        startLoadLessonsFromBackend()
    }
    
    private func startLoadFromDB() {
        let loadFromDBCompletion = BlockOperation {
            let result = self.loadFromDatabase.result!
            switch result {
            case .success(let lessonTasks):
                self.lessonTasks = lessonTasks
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
            case .success(let lessonTasks):
                self.startSaveToDB(with: lessonTasks)
            case .failure(let error):
                self.result = .failure(error)
            }
        }
        loadFromBackendCompletion.addDependency(loadFromBackend)
        commonQueue.addOperation(loadFromBackendCompletion)
        backendQueue.addOperation(loadFromBackend)
        self.addDependency(loadFromBackendCompletion)
    }
    
    private func startSaveToDB(with lessonTasks: [UnaLessonTask]) {
        let saveToDatabase = SaveLessonTasksDatabaseOperation(context: context, tasks: lessonTasks)
        self.saveToDatabase = saveToDatabase
        let saveToDatabaseCompletion = BlockOperation {
            let result = saveToDatabase.result!
            switch result {
            case .success(let lessonTasks):
                self.lessonTasks = lessonTasks
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
            let lessonTasks = lessonTasks else { return }
        self.result = .success(lessonTasks)
    }
    
    override func cancel() {
        super.cancel()
        loadFromDatabase.cancel()
        loadFromBackend.cancel()
        saveToDatabase?.cancel()
    }

}
