//
//  LessonCoreDataService.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import CoreData

class LessonCoreDataService: BaseCoreDataService {
    
    private let entityName = "Lesson"
    
    func load() throws -> [Lesson] {
        let request: NSFetchRequest<Lesson> = NSFetchRequest(entityName: entityName)
        request.sortDescriptors = [ NSSortDescriptor(key: "id", ascending: false) ]
        return try context.fetch(request)
    }
    
    func load(with id: Int) throws -> Lesson? {
        let request: NSFetchRequest<Lesson> = NSFetchRequest(entityName: entityName)
        request.predicate = NSPredicate(format: "id = %d", id)
        return try context.fetch(request).first
    }
    
    enum SaveLessonResult {
        case success(Lesson)
        case failure(Error)
    }
    
    func save(_ lesson: UnaLesson, completion: @escaping (SaveLessonResult) -> ()) throws {
        let cdLesson = try load(with: lesson.id) ?? Lesson(context: context)
        cdLesson.id = Int64(lesson.id)
        cdLesson.title = lesson.title
        cdLesson.descript = lesson.description
        cdLesson.difficulty = lesson.difficulty
        cdLesson.underTitle = lesson.underTitle
        if let parts = lesson.parts {
            cdLesson.parts = NSSet(array: parts)
        }
        saveContext {
            if let error = $0 {
                completion(.failure(error))
            } else {
                completion(.success(cdLesson))
            }
        }
    }
    
    enum SaveLessonsResult {
        case success([Lesson])
        case failure(Error)
    }
    
    func save(_ lessons: [UnaLesson], completion: @escaping (SaveLessonsResult) -> ()) throws {
        var cdLessons: [Lesson] = []
        try lessons.forEach { lesson in
            try self.save(lesson) { result in
                switch result {
                case .success(let lesson):
                    cdLessons.append(lesson)
                    if cdLessons.count == lessons.count {
                        completion(.success(cdLessons))
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
