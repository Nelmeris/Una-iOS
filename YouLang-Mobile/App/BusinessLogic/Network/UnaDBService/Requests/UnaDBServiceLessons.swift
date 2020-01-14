//
//  UnaDBServiceLessons.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 11.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation

protocol UnaDBServiceLessonsFactory {
    func getLessons(complete: @escaping ([UnaLesson]) -> ()) throws
    func getLessonParts(for id: Int, complete: @escaping ([UnaLessonPart]) -> ()) throws
}

extension UnaDBService: UnaDBServiceLessonsFactory {
    
    func getLessons(complete: @escaping ([UnaLesson]) -> ()) throws {
        try self.request(with: (getLessonsSQL(), [])) { values in
            var lessons: [UnaLesson] = []
            try values.forEach { try lessons.append(UnaLesson(from: $0)) }
            complete(lessons)
        }
    }
    
    private func getLessonsSQL() -> String {
        let lessonsTable = "lessons_lesson"
        return "SELECT * FROM \(lessonsTable);"
    }
    
    func getLessonParts(for id: Int, complete: @escaping ([UnaLessonPart]) -> ()) throws {
        try self.request(with: (getLessonPartsSQL(), [String(id)])) { values in
            var parts: [UnaLessonPart] = []
            try values.forEach { try parts.append(UnaLessonPart(from: $0)) }
            complete(parts)
        }
    }
    
    private func getLessonPartsSQL() -> String {
        let lessonPartsTable = "lessons_lessonpart"
        return "SELECT * FROM \(lessonPartsTable) WHERE lesson_id = $1"
    }
    
}
