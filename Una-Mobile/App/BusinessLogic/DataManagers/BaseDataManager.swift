//
//  BaseDataManager.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import CoreData

class BaseDataManager {
    
    let context: NSManagedObjectContext
    let uiQueue: OperationQueue
    let backendQueue: OperationQueue
    let dbQueue: OperationQueue
    
    init() {
        self.context = BaseCoreDataService.persistentContainer.viewContext
        self.uiQueue = BaseUIOperation.queue
        self.backendQueue = BaseBackendOperation.queue
        self.dbQueue = BaseDatabaseOperation.queue
    }
    
    init(context: NSManagedObjectContext,
         uiQueue: OperationQueue,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        self.uiQueue = uiQueue
        self.context = context
        self.backendQueue = backendQueue
        self.dbQueue = dbQueue
    }
    
}
