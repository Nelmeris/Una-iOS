//
//  UnaNetworkErrorParser.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 17.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import SwiftyJSON
import Moya

enum UnaResponseError: Error, LocalizedError {
    case notJSON
    case badCredentials
    case unknown(code: Int, message: String)
    
    public var errorDescription: String? {
        switch self {
        case .notJSON:
            return NSLocalizedString("Некорректные данные", comment: "")
        case .badCredentials:
            return NSLocalizedString("Неверные логин или пароль", comment: "")
        case .unknown(let code, let message):
            return NSLocalizedString("Код: \(code)\n\(message)", comment: "")
        }
    }
}

class UnaNetworkErrorParser: AbstractErrorParser {
    
    func parse(_ result: Error) -> Error {
        return result
    }
    
    func parse(data: Response) -> Error {
        do {
            let json = try JSON(data: data.data)
            if json["detail"].exists() {
                let detail = json["detail"].stringValue
                if detail == "No active account found with the given credentials" {
                    return UnaResponseError.badCredentials
                }
            }
            return UnaResponseError.unknown(code: data.statusCode, message: json.rawString()!)
        } catch {
            return UnaResponseError.notJSON
        }
    }
    
}
