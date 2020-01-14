//
//  UnaService.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 07.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import PostgresClientKit

class UnaDBService: AbstractPostgresRequestFactory {
    
    private let host = "5.23.55.140"
    private let port = 5432
    private let database = "una_db"
    private let user = "una"
    private let password = "3WsZsR98"
    
    var configuration: ConnectionConfiguration
    
    static let shared = UnaDBService()
    
    private init() {
        var config = ConnectionConfiguration()
        config.host = host
        config.port = port
        config.database = database
        config.user = user
        config.credential = .md5Password(password: password)
        self.configuration = config
    }
    
}
