//
//  UnaRequestDBFactory.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 11.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import PostgresClientKit

final class UnaRequestDBFactory {
    
    private let host = "5.23.55.140"
    private let port = 5432
    private let database = "una_db"
    private let user = "una"
    private let password = "3WsZsR98"
    
    func makeConfiguration() -> ConnectionConfiguration {
        var config = ConnectionConfiguration()
        config.host = host
        config.port = port
        config.database = database
        config.user = user
        config.credential = .md5Password(password: password)
        return config
    }
    
}
