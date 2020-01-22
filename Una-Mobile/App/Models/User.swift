//
//  User.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 22.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation

struct User {
    
    let id: Int
    let username: String
    let firstName: String
    let lastName: String
    let isSuperuser: Bool
    let country: String
    let city: String
    
    init(user: UnaAuthUser, profile: UnaUserProfile) {
        self.id = user.id
        self.username = user.username
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.isSuperuser = user.isSuperuser
        self.country = profile.country
        self.city = profile.city
    }
    
}
