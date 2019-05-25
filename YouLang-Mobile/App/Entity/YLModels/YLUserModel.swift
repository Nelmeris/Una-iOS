//
//  YLUserModel.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 24/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Foundation

struct YLUserModel: Decodable {
    
    let firstName: String
    let lastName: String
    let isAdmin: Bool
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case isAdmin = "is_admin"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let containers = try decoder.container(keyedBy: CodingKeys.self)
        
        firstName = try containers.decode(String.self, forKey: .firstName)
        lastName = try containers.decode(String.self, forKey: .lastName)
        isAdmin = try containers.decode(Bool.self, forKey: .isAdmin)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        var date = formatter.date(from: try containers.decode(String.self, forKey: .createdAt))!
        createdAt = date
        date = formatter.date(from: try containers.decode(String.self, forKey: .updatedAt))!
        updatedAt = date
    }
    
}
