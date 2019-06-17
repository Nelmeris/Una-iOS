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

struct LessonTaskSubstring: Hashable {
    let value: String
    let position: Int
    let type: LessonTaskTypes
    
    func uniqueValue() -> String {
        return "\(value)-\(position)"
    }
}

struct LessonTask {
    let helpMessage: String
    let text: String
    let keySubstrings: [LessonTaskSubstring: [LessonTaskAnswer]]
}
