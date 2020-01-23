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
    
    func save(_ lessonTask: UnaLessonTask, completion: @escaping (SaveLessonTaskResult) -> ()) throws {
        let cdLessonPart = try load(with: lessonTask.id) ?? LessonTask(context: context)
        cdLessonPart.id = Int64(lessonTask.id)
        cdLessonPart.title = lessonTask.title
        cdLessonPart.text = lessonTask.text
        let lessonPartCD = LessonPartCoreDataService(context: context)
        cdLessonPart.lessonPart = try lessonPartCD.load(with: lessonTask.partId)!
        saveContext {
            if let error = $0 {
                completion(.failure(error))
            } else {
                completion(.success(cdLessonPart))
            }
        }
    }
    
    enum SaveLessonsResult {
        case success([LessonTask])
        case failure(Error)
    }
    
    func save(_ lessonTasks: [UnaLessonTask], completion: @escaping (SaveLessonsResult) -> ()) throws {
        var cdLessonTasks: [LessonTask] = []
        try lessonTasks.forEach { lessonTask in
            try self.save(lessonTask) { result in
                switch result {
                case .success(let lessonTask):
                    cdLessonTasks.append(lessonTask)
                    if cdLessonTasks.count == lessonTasks.count {
                        completion(.success(cdLessonTasks))
                    }
                case .failure(let error):
                    completion(.failure(error))
                    return
                }
            }
        }
    }
    
    func removeAll() throws {
        let data = try self.load()
        data.forEach { self.context.delete($0) }
    }
    
}
