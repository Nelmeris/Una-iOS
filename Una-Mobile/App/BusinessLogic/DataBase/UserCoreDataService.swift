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
    
    private let entityName = "User"
    
    func load() throws -> [User] {
        let request: NSFetchRequest<User> = NSFetchRequest(entityName: entityName)
        request.sortDescriptors = [ NSSortDescriptor(key: "id", ascending: false) ]
        return try context.fetch(request)
    }
    
    func load(email: String) throws -> User? {
        let request: NSFetchRequest<User> = NSFetchRequest(entityName: entityName)
        request.predicate = NSPredicate(format: "email = %@", email)
        return try context.fetch(request).first
    }
    
    enum SaveResult {
        case success(User)
        case failure(Error)
    }
    
    func save(authUser: UnaAuthUser, profile: UnaUserProfile, completion: @escaping (SaveResult) -> ()) throws {
        let user = try load(email: authUser.email) ?? User(context: context)
        user.id = Int64(authUser.id)
        user.email = authUser.email
        user.name = authUser.firstName
        user.surname = authUser.lastName
        user.city = profile.city
        user.country = profile.country
        user.isSuperuser = authUser.isSuperuser
        if let birthday = profile.date {
            user.birthday = UserCoreDataService.dateFormatter.date(from: birthday)
        }
        saveContext {
            if let error = $0 {
                completion(.failure(error))
            } else {
                completion(.success(user))
            }
        }
    }
    
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
    
    func removeAll() throws {
        let data = try self.load()
        data.forEach { self.context.delete($0) }
    }
    
}
