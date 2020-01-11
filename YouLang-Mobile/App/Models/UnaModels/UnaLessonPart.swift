//
//  UnaLessonPart.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 11.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import PostgresClientKit

struct UnaLessonPart: Decodable {
    
    let id: Int
    let lessonId: Int
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case lessonId = "lesson_id"
        case title = "part_name"
    }
    
    init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try containers.decode(Int.self, forKey: .id)
        lessonId = try containers.decode(Int.self, forKey: .lessonId)
        title = try containers.decode(String.self, forKey: .title)
    }
    
    init(from postgresValues: [PostgresValue]) throws {
        id = try postgresValues[0].int()
        title = try postgresValues[1].string()
        lessonId = try postgresValues[2].int()
    }
    
}
