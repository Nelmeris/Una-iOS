//
//  LessonPartCoreDataService.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import CoreData

class LessonPartCoreDataService: BaseCoreDataService {
    
    private let entityName = "LessonPart"
    
    func load() throws -> [LessonPart] {
        let request: NSFetchRequest<LessonPart> = NSFetchRequest(entityName: entityName)
        request.sortDescriptors = [ NSSortDescriptor(key: "id", ascending: false) ]
        return try context.fetch(request)
    }
    
    func load(with id: Int) throws -> LessonPart? {
        let request: NSFetchRequest<LessonPart> = NSFetchRequest(entityName: entityName)
        request.predicate = NSPredicate(format: "id = %d", id)
        return try context.fetch(request).first
    }
    
    enum SaveLessonPartResult {
        case success(LessonPart)
        case failure(Error)
    }
    
    func save(_ lessonPart: UnaLessonPart, completion: @escaping (SaveLessonPartResult) -> ()) throws {
        let cdLessonPart = try load(with: lessonPart.id) ?? LessonPart(context: context)
        cdLessonPart.id = NSNumber(value: lessonPart.id)
        cdLessonPart.title = lessonPart.title
        cdLessonPart.lessonId = NSNumber(value: lessonPart.lessonId)
        let lessonCD = LessonCoreDataService(context: context)
        cdLessonPart.lesson = try lessonCD.load(with: lessonPart.lessonId)!
        saveContext {
            if let error = $0 {
                completion(.failure(error))
            } else {
                completion(.success(cdLessonPart))
            }
        }
    }
    
    enum SaveLessonsResult {
        case success([LessonPart])
        case failure(Error)
    }
    
    func save(_ lessonParts: [UnaLessonPart], completion: @escaping (SaveLessonsResult) -> ()) throws {
        var cdLessonParts: [LessonPart] = []
        try lessonParts.forEach { lessonPart in
            try self.save(lessonPart) { result in
                switch result {
                case .success(let lessonPart):
                    cdLessonParts.append(lessonPart)
                    if cdLessonParts.count == lessonParts.count {
                        completion(.success(cdLessonParts))
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
