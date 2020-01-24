//
//  UnaNetworkable.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 17.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import Moya

protocol UnaNetworkable {
    var provider: MoyaProvider<UnaAPI> { get }
    
    func login(email: String, password: String, completion: @escaping (AccessToken?, Error?) -> ())
}

struct AccessToken: Codable {
    let access: String
    let refresh: String
}
