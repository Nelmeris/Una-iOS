//
//  UnaDBServiceUser.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 22.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation

protocol UnaDBServiceUserFactory {
    func getUser(with username: String, completion: @escaping (UnaAuthUser?) -> ()) throws
    func getUserProfile(with userId: Int, completion: @escaping (UnaUserProfile?) -> ()) throws
}

extension UnaDBService: UnaDBServiceUserFactory {
    
    func getUser(with username: String, completion: @escaping (UnaAuthUser?) -> ()) throws {
        try self.request(with: (getAuthUserSQL(), [username])) { values in
            guard values.count != 0 else {
                completion(nil)
                return
            }
            let user: UnaAuthUser = try UnaAuthUser(from: values[0])
            completion(user)
        }
    }
    
    private func getAuthUserSQL() -> String {
        let usersTable = "auth_user"
        return "SELECT * FROM \(usersTable) WHERE email = $1"
    }
    
    func getUserProfile(with userId: Int, completion: @escaping (UnaUserProfile?) -> ()) throws {
        try self.request(with: (getUserProfileSQL(), [String(userId)])) { values in
            guard values.count != 0 else {
                completion(nil)
                return
            }
            let userProfile = try UnaUserProfile(from: values[0])
            completion(userProfile)
        }
    }
    
    private func getUserProfileSQL() -> String {
        let usersTable = "userprofile_profile"
        return "SELECT * FROM \(usersTable) WHERE user_id = $1"
    }
    
}
