//
//  LessonsDataManager.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation

final class LessonsDataManager: BaseDataManager {
    
    static let `default` = LessonsDataManager()
    
    enum GetLessonsResult {
        case success([Lesson])
        case failure(Error)
    }
    
    func getLessons(completion: @escaping (GetLessonsResult) -> ()) {
        let loadOperation = LoadLessonsUIOperation(context: context, backendQueue: backendQueue, dbQueue: dbQueue)
        loadOperation.loadFromDatabase.completionBlock = {
            let result = loadOperation.loadFromDatabase.result!
            switch result {
            case .success(let lessons):
                completion(.success(lessons))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        loadOperation.completionBlock = {
            let result = loadOperation.result!
            switch result {
            case .success(let lessons):
                completion(.success(lessons))
            case .notFound: break
            case .failure(let error):
                completion(.failure(error))
            }
        }
        uiQueue.addOperation(loadOperation)
    }
    
    enum GetLessonPartsResult {
        case success([LessonPart])
        case failure(Error)
    }
    
    func getLessonParts(for lessonId: Int, completion: @escaping (GetLessonPartsResult) -> ()) {
        let loadOperation = LoadLessonPartsUIOperation(with: lessonId, context: context, backendQueue: backendQueue, dbQueue: dbQueue)
        loadOperation.loadFromDatabase.completionBlock = {
            let result = loadOperation.loadFromDatabase.result!
            switch result {
            case .success(let lessonParts):
                completion(.success(lessonParts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        loadOperation.completionBlock = {
            let result = loadOperation.result!
            switch result {
            case .success(let lessons):
                completion(.success(lessons))
            case .notFound: break
            case .failure(let error):
                completion(.failure(error))
            }
        }
        uiQueue.addOperation(loadOperation)
    }
    
    enum GetLessonTasksResult {
        case success([LessonTask])
        case failure(Error)
    }
    
    func getLessonTasks(for partId: Int, completion: @escaping (GetLessonTasksResult) -> ()) {
        let loadOperation = LoadLessonTasksUIOperation(with: partId, context: context, backendQueue: backendQueue, dbQueue: dbQueue)
        loadOperation.loadFromDatabase.completionBlock = {
            let result = loadOperation.loadFromDatabase.result!
            switch result {
            case .success(let lessonParts):
                completion(.success(lessonParts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        loadOperation.completionBlock = {
            let result = loadOperation.result!
            switch result {
            case .success(let lessons):
                completion(.success(lessons))
            case .notFound: break
            case .failure(let error):
                completion(.failure(error))
            }
        }
        uiQueue.addOperation(loadOperation)
    }
    
}
