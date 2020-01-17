//
//  PrimitiveSequence + Codable.swift
//  GamerSky
//
//  Created by QY on 2018/5/5.
//  Copyright © 2018年 engic. All rights reserved.
//

import Foundation
import RxSwift
import Moya

public extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    
    func mapObject<T: Codable>(_ type: T.Type, path: String? = nil) -> Single<T> {
        return flatMap { response -> Single<T> in
            return Single.just(try response.mapObject(type, path: path))
        }
    }
    
    func mapArray<T: Codable>(_ type: T.Type, path: String? = nil) -> Single<[T]> {
        return flatMap { response -> Single<[T]> in
            return Single.just(try response.mapArray(type, path: path))
        }
    }
    
}
