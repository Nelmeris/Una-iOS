//
//  AbstractErrorParser.swift
//  NetworkCore
//
//  Created by Artem Kufaev on 23/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Foundation
import Moya

protocol AbstractErrorParser {
    func parse(_ result: Error) -> Error
    func parse(data: Response) -> Error
}
