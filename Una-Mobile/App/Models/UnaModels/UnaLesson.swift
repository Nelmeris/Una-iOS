//
//  UnaLesson.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 11.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import PostgresClientKit

struct UnaLesson: Decodable {
    
    let id: Int
    let title: String
    let underTitle: String
    let imageURL: URL?
    let description: String
    let shortDescription: String
    let difficulty: DifficultyLevel
    
    var parts: [UnaLessonPart]? = nil
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, difficulty
        case underTitle = "under_title"
        case imageURL = "image"
        case shortDescription = "short_description"
    }
    
    init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try containers.decode(Int.self, forKey: .id)
        title = try containers.decode(String.self, forKey: .title)
        underTitle = try containers.decode(String.self, forKey: .underTitle)
        description = try containers.decode(String.self, forKey: .description)
        shortDescription = try containers.decode(String.self, forKey: .shortDescription)
        
        let imageStr = try containers.decode(String.self, forKey: .imageURL)
        imageURL = URL(string: imageStr)
        
        let difficultyStr = try containers.decode(String.self, forKey: .difficulty)
        difficulty = DifficultyLevel(rawValue: difficultyStr)!
    }
    
    init(from postgresValues: [PostgresValue]) throws {
        id = try postgresValues[0].int()
        title = try postgresValues[1].string()
        underTitle = try postgresValues[2].string()
        description = try postgresValues[3].string()
        imageURL = URL(string: try postgresValues[4].optionalString() ?? "")
        difficulty = DifficultyLevel(rawValue: try postgresValues[5].string())!
        shortDescription = try postgresValues[6].string()
    }
    
    mutating func setParts(_ parts: [UnaLessonPart]) {
        self.parts = parts
    }
    
}
