//
//  YLRegisterResponse.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 24/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Foundation

struct YLRegisterResponse: Codable {
    let result: Int
    let accessToken: String
    let userMessage: String
    
    enum CodingKeys: String, CodingKey {
        case result
        case accessToken = "access_token"
        case userMessage = "user_message"
    }
}
