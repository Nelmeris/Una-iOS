//
//  UnaLesson.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 11.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import PostgresClientKit

struct UnaLesson {
    
    let id: Int
    let title: String
    let underTitle: String
    let imageURL: String?
    let description: String
    let shortDescription: String
    let difficulty: String
    
    var parts: [UnaLessonPart]? = nil
    
    init(from postgresValues: [PostgresValue]) throws {
        id = try postgresValues[0].int()
        title = try postgresValues[1].string()
        underTitle = try postgresValues[2].string()
        description = try postgresValues[3].string()
        imageURL = try postgresValues[4].optionalString()
        difficulty = try postgresValues[5].string()
        shortDescription = try postgresValues[6].string()
    }
    
}
