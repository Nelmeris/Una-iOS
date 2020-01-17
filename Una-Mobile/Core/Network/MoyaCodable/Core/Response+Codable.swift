//
//  Response+Codable.swift
//  Moya+Codable
//
//  Created by QY on 2018/5/5.
//  Copyright © 2018年 QY. All rights reserved.
//

import Foundation
import Moya

public extension Response {
    
    // MARK: - 转成对象模型
    func mapObject<T: Decodable>(_ type: T.Type, path: String? = nil) throws -> T {
        
        do {
            return try JSONDecoder().decode(T.self, from: try getJsonData(path))
        } catch {
            throw MoyaError.jsonMapping(self)
        }
    }
    
    // MARK: - 转成数组模型
    func mapArray<T: Decodable>(_ type: T.Type, path: String? = nil) throws -> [T] {
        
        do {
            return try JSONDecoder().decode([T].self, from: try getJsonData(path))
        } catch {
            throw MoyaError.jsonMapping(self)
        }
    }
    
    // MARK: - 获取指定路径数据
    private func getJsonData(_ path: String? = nil) throws -> Data {
        
        do {
            
            var jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            if let path = path {
                
                guard let specificObject = jsonObject.value(forKeyPath: path) else {
                    throw MoyaError.jsonMapping(self)
                }
                jsonObject = specificObject as AnyObject
            }
            
            return try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        } catch {
            throw MoyaError.jsonMapping(self)
        }
    }
}
