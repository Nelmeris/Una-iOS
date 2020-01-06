//
//  LessonTask.swift
//  YouLang-Mobile
//
//  Created by Артем Куфаев on 30/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Foundation

enum LessonTaskTypes: String {
    case input
    case find
}

struct LessonTaskAnswer {
    let value: String
    let isCorrect: Bool
}

struct LessonTaskSubstring: Equatable {
    static func == (lhs: LessonTaskSubstring, rhs: LessonTaskSubstring) -> Bool {
        return lhs.value == rhs.value && lhs.position == rhs.position
    }
    
    private let value: String
    var changedValue: String
    let position: Int
    let type: LessonTaskTypes
    let answers: [LessonTaskAnswer]
    
    func uniqueValue() -> String {
        return "\(value)-\(position)"
    }
    
    func isCorrectAnswer(value: String) -> Bool {
        for answer in answers {
            if (answer.value.lowercased() == value.lowercased() && answer.isCorrect) {
                return true
            }
        }
        return false
    }
    
    init(value: String, position: Int, type: LessonTaskTypes, answers: [LessonTaskAnswer]) {
        self.value = value
        self.changedValue = value
        self.position = position
        self.type = type
        self.answers = answers
    }
}

struct LessonTask: Equatable {
    let helpMessage: String
    let text: String
    var keySubstrings: [LessonTaskSubstring]
}
