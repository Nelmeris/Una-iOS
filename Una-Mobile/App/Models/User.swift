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
    let email: String
    let firstName: String
    let lastName: String
    let isSuperuser: Bool
    let country: String
    let city: String
    let birthday: Date?
    
    init(user: UnaAuthUser, profile: UnaUserProfile) {
        self.id = user.id
        self.email = user.email
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.isSuperuser = user.isSuperuser
        self.country = profile.country
        self.city = profile.city
        self.birthday = profile.date
    }
    
    init(id: Int, email: String, firstName: String, lastName: String, isSuperuser: Bool, country: String, city: String, birthday: Date?) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.isSuperuser = isSuperuser
        self.country = country
        self.city = city
        self.birthday = birthday
    }
    
}
