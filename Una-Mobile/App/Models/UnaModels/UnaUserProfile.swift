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
    let country: String?
    let city: String?
    let date: String?
    
    init(from postgresValues: [PostgresValue]) throws {
        id = try postgresValues[0].int()
        userId = try postgresValues[4].int()
        country = try postgresValues[2].optionalString()
        city = try postgresValues[3].optionalString()
        date = try postgresValues[5].optionalString()
    }
    
    init(from user: User) {
        self.id = nil
        self.userId = Int(user.id)
        self.country = user.country
        self.city = user.city
        if let birthday = user.birthday {
            self.date = UserCoreDataService.dateFormatter.string(from: birthday)
        } else {
            self.date = nil
        }
    }
    
}
