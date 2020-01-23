//
//  UserCoreDataService.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import CoreData

class UserCoreDataService: BaseCoreDataService {
    
    func loadUsers() throws -> [User] {
        let request: NSFetchRequest<User> = NSFetchRequest(entityName: "User")
        request.sortDescriptors = [ NSSortDescriptor(key: "id", ascending: false) ]
        return try context.fetch(request)
    }
    
    func loadUser(email: String) throws -> User? {
        let request: NSFetchRequest<User> = NSFetchRequest(entityName: "User")
        request.predicate = NSPredicate(format: "email = %@", email)
        return try context.fetch(request).first
    }
    
    func saveUser(authUser: UnaAuthUser, profile: UnaUserProfile, completion: @escaping (Error?) -> ()) throws -> User {
        let user = try loadUser(email: authUser.email) ?? User(context: context)
        user.id = Int64(authUser.id)
        user.email = authUser.email
        user.name = authUser.firstName
        user.surname = authUser.lastName
        user.city = profile.city
        user.country = profile.country
        if let birthday = profile.date {
            user.birthday = UserCoreDataService.dateFormatter.date(from: birthday)
        }
        saveContext { completion($0) }
        return user
    }
    
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
    
}
