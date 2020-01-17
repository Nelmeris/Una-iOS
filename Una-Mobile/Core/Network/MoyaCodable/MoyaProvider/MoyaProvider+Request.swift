//
//  Moya+Codable.swift
//  Moya+Codable
//
//  Created by QY on 2018/3/31.
//  Copyright © 2018年 QY. All rights reserved.
//

import Foundation
import Moya

extension MoyaProvider {
    
    // MARK: - For object
    @discardableResult
    func request<T: Decodable>(_ target: Target,
                             errorParser: AbstractErrorParser,
                             objectModel: T.Type,
                             path: String? = nil,
                             success: ((_ returnData: T) -> ())?, failure: ((_ Error: Error) -> ())?) -> Cancellable? {
        
        return request(target, completion: {
            
            if let error = $0.error {
                let error = errorParser.parse(error)
                failure?(error)
                return
            }
            
            do {
                
                guard let returnData = try $0.value?.mapObject(objectModel.self, path: path) else {
                    return
                }
                success?(returnData)
            } catch {
                let error = errorParser.parse(data: $0.value!)
                failure?(error)
            }
        })
    }
    
    // MARK: - For array
    @discardableResult
    func request<T: Decodable>(_ target: Target,
                               errorParser: AbstractErrorParser,
                               arrayModel: T.Type,
                               path: String? = nil,
                               success: ((_ returnData: [T]) -> ())?,
                               failure: ((_ Error: Error) -> ())?) -> Cancellable? {
        
        return request(target, completion: {
            
            if let error = $0.error {
                let error = errorParser.parse(error)
                failure?(error)
                return
            }
            
            do {
                
                guard let returnData = try $0.value?.mapArray(arrayModel.self, path: path) else {
                    return
                }
                success?(returnData)
            } catch {
                let error = errorParser.parse(data: $0.value!)
                failure?(error)
            }
        })
    }
    
}
