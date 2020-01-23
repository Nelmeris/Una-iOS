//
//  LessonTaskCoreDataService.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import CoreData

class LessonTaskCoreDataService: BaseCoreDataService {
    
    private let entityName = "LessonTask"
    
    func load() throws -> [LessonTask] {
        let request: NSFetchRequest<LessonTask> = NSFetchRequest(entityName: entityName)
        request.sortDescriptors = [ NSSortDescriptor(key: "id", ascending: false) ]
        return try context.fetch(request)
    }
    
    func load(with id: Int) throws -> LessonTask? {
        let request: NSFetchRequest<LessonTask> = NSFetchRequest(entityName: entityName)
        request.predicate = NSPredicate(format: "id = %d", id)
        return try context.fetch(request).first
    }
    
    enum SaveLessonTaskResult {
        case success(LessonTask)
        case failure(Error)
    }
    
    private func save(_ lessonTask: UnaLessonTask) throws -> LessonTask {
        let cdTask = try load(with: lessonTask.id)
        switch lessonTask {
        case let task as UnaLessonTaskFind:
            let cdTaskFind = (cdTask ?? LessonTaskFind(context: context)) as! LessonTaskFind
            try fillTask(cdTask: cdTaskFind, task: task)
            cdTaskFind.answers = task.answers
            cdTaskFind.rightAnswers = task.rightAnswers
            return cdTaskFind
        default: fatalError()
        }
    }
    
    private func fillTask(cdTask: LessonTask, task: UnaLessonTask) throws {
        cdTask.id = Int64(task.id)
        cdTask.partId = Int64(task.partId)
        cdTask.title = task.title
        cdTask.text = task.text
        let partCD = LessonPartCoreDataService(context: context)
        cdTask.lessonPart = try partCD.load(with: task.partId)!
    }
    
    enum SaveLessonsResult {
        case success([LessonTask])
        case failure(Error)
    }
    
    func save(_ lessonTasks: [UnaLessonTask], completion: @escaping (SaveLessonsResult) -> ()) throws {
        var cdLessonTasks: [LessonTask] = []
        try lessonTasks.forEach { lessonTask in
            let task = try self.save(lessonTask)
            cdLessonTasks.append(task)
            if cdLessonTasks.count == lessonTasks.count {
                completion(.success(cdLessonTasks))
            }
        }
        saveContext {
            if let error = $0 {
                completion(.failure(error))
            } else {
                completion(.success(cdLessonTasks))
            }
        }
    }
    
    func removeAll() throws {
        let data = try self.load()
        data.forEach { self.context.delete($0) }
    }
    
}
