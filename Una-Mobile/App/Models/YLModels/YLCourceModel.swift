//
//  YLCourceModel.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 24/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Foundation

struct YLCourceModel: Decodable {
    
    let title: String
    let learnedLessonsCount: Int
    let lessonsCount: Int
    let level: DifficultyLevel
    
    enum CodingKeys: String, CodingKey {
        case title
        case learnedLessonsCount = "learned_count"
        case lessonsCount = "lessons_count"
        case level = "level"
    }

    init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)

        title = try containers.decode(String.self, forKey: .title)
        learnedLessonsCount = try containers.decode(Int.self, forKey: .learnedLessonsCount)
        lessonsCount = try containers.decode(Int.self, forKey: .lessonsCount)
        level = DifficultyLevel(rawValue: try containers.decode(String.self, forKey: .level))!
    }
    
}
