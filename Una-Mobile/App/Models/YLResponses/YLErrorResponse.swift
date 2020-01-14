//
//  YLErrorResponse.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 24/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Foundation

enum YLErrorResponses: Error, LocalizedError {
    case ylError(response: YLErrorResponse)
    
    public var errorDescription: String? {
        switch self {
        case .ylError(let response):
            return NSLocalizedString(response.errorMessage, comment: "")
        }
    }
}

struct YLErrorResponse: Decodable {
    let result: Int
    let errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case result
        case errorMessage = "error_message"
    }
}
