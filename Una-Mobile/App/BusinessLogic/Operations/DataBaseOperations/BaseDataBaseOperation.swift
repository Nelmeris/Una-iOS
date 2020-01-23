//
//  BaseDataBaseOperation.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import CoreData

class BaseDataBaseOperation: AsyncOperation {
    
    static var queue = OperationQueue()
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
}
