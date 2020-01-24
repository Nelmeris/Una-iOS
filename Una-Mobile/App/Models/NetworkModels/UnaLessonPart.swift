//
//  UnaLessonPart.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 11.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import PostgresClientKit

struct UnaLessonPart {
    
    let id: Int
    let lessonId: Int
    let title: String
    
    init(from postgresValues: [PostgresValue]) throws {
        id = try postgresValues[0].int()
        title = try postgresValues[1].string()
        lessonId = try postgresValues[2].int()
    }
    
}
