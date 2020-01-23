//
//  UnaLessonTask.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 11.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import PostgresClientKit

class UnaLessonTask {
    
    let id: Int
    let partId: Int
    let title: String
    let text: String
    
    init(id: Int, partId: Int, title: String, text: String) {
        self.id = id
        self.partId = partId
        self.title = title
        self.text = text
    }
    
}

class UnaLessonTaskFind: UnaLessonTask {
    
    let answers: String
    let rightAnswers: String
    
    required init(from postgresValues: [PostgresValue]) throws {
        let id = try postgresValues[0].int()
        let title = try postgresValues[1].string()
        let text = try postgresValues[2].string()
        let partId = try postgresValues[4].int()
        
        self.answers = try postgresValues[3].string()
        self.rightAnswers = try postgresValues[5].string()
        
        super.init(id: id, partId: partId, title: title, text: text)
    }
    
}
