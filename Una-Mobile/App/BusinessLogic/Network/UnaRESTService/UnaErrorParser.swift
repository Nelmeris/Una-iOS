//
//  UnaErrorParser.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 11.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import SwiftyJSON

class UnaErrorParser: AbstractErrorParser {
    
    func parse(_ result: Error) -> Error {
        return result
    }
    
    func parse(response: HTTPURLResponse?, data: Data?, error: Error?) -> Error? {
        if let data = data,
            (try? JSON(data: data)) != nil {
            print("Request error")
            return nil
        }
        return error
    }
    
}
