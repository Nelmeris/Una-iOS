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

struct LessonTaskSubstring {
    let value: String
    let position: Int
    
    func uniqueValue() -> String {
        return "\(value)-\(position)"
    }
}

struct LessonTask {
    let helpMessage: String
    let text: String
    let keySubstrings: [LessonTaskSubstring]
    let type: LessonTaskTypes
}
