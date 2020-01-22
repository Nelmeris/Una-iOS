//
//  UnaUserProfile.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 22.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import PostgresClientKit

struct UnaUserProfile {
    
    let id: Int?
    let userId: Int
    let country: String
    let city: String
    let date: Date?
    
    init(from postgresValues: [PostgresValue]) throws {
        id = try postgresValues[0].int()
        userId = try postgresValues[4].int()
        country = try postgresValues[2].string()
        city = try postgresValues[3].string()
        let dateStr = try postgresValues[5].optionalString()
        date = UnaUserProfile.dateFormatter.date(from: dateStr ?? "")
    }
    
    init(from user: User) {
        self.id = nil
        self.userId = user.id
        self.country = user.country
        self.city = user.city
        self.date = user.birthday
    }
    
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
    
}
