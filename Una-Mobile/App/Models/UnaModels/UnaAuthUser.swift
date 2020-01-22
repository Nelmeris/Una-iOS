//
//  UnaAuthUser.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 22.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import PostgresClientKit

struct UnaAuthUser {
    
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let isSuperuser: Bool
    
    init(from postgresValues: [PostgresValue]) throws {
        id = try postgresValues[0].int()
        isSuperuser = try postgresValues[3].bool()
        email = try postgresValues[4].string()
        firstName = try postgresValues[5].string()
        lastName = try postgresValues[6].string()
    }
    
    init(from user: User) {
        self.id = user.id
        self.email = user.email
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.isSuperuser = user.isSuperuser
    }
    
}
