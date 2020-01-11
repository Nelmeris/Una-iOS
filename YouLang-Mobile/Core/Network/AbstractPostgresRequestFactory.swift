//
//  AbstractPostgresRequestFactory.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 11.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import PostgresClientKit

protocol AbstractPostgresRequestFactory {

    var configuration: ConnectionConfiguration { get }
    func request(
        with sql: (statement: String, parameters: [String]),
        completion: @escaping ([[PostgresValue]]) throws -> ()) throws
    
}

extension AbstractPostgresRequestFactory {

    public func request(
        with sql: (statement: String, parameters: [String]),
        completion: @escaping ([[PostgresValue]]) throws -> ()) throws {
        let connection = try PostgresClientKit.Connection(configuration: configuration)
        defer { connection.close() }
        
        let statement = try connection.prepareStatement(text: sql.statement)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: sql.parameters)
        defer { cursor.close() }
        
        let model = try getValues(cursor)
        try completion(model)
    }
    
    private func getValues(_ cursor: Cursor) throws -> [[PostgresValue]] {
        var values: [[PostgresValue]] = []
        for row in cursor {
            let columns = try row.get().columns
            values.append(columns)
        }
        return values
    }
    
}
