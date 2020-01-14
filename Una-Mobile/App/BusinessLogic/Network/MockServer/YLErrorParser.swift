//
//  YLErrorParser.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 24/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Foundation
import SwiftyJSON

class YLErrorParser: AbstractErrorParser {
    func parse(_ result: Error) -> Error {
        return result
    }
    
    func parse(response: HTTPURLResponse?, data: Data?, error: Error?) -> Error? {
        if let data = data,
            let json = try? JSON(data: data),
            json["result"].int == 0 {
            let error = try! JSONDecoder().decode(YLErrorResponse.self, from: data)
            return YLErrorResponses.ylError(response: error)
        }
        return error
    }
}
