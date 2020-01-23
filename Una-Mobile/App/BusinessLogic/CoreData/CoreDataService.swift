//
//  CoreDataService.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 22.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import CoreData

class BaseCoreDataService {
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UnaModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext(completion: @escaping (Error?) -> ()) {
        self.context.performAndWait {
            do {
                try self.context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
}

class UserCoreDataService: BaseCoreDataService {
    
    func loadUsers(email: String? = nil) throws -> [User] {
        let request: NSFetchRequest<User> = NSFetchRequest(entityName: "User")
        request.sortDescriptors = [ NSSortDescriptor(key: "id", ascending: false) ]
        if let email = email {
            request.predicate = NSPredicate(format: "email = %@", email)
        }
        return try context.fetch(request)
    }
    
    func saveUser(authUser: UnaAuthUser, profile: UnaUserProfile, completion: @escaping (Error?) -> ()) throws -> User? {
        let user = try loadUsers(email: authUser.email).first ?? User(context: context)
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
