//
//  AsyncOperation.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 17.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation

struct AsyncOperationID {
    let number: Int?
    let title: String
}

class AsyncOperation: Operation {
    
    private var _executing = false
    private var _finished = false
    
    private static var count = 0
    let commonQueue = OperationQueue()
    
    let id: AsyncOperationID?
    
    init(id: AsyncOperationID? = nil) {
        if let id = id {
            if id.number == nil {
                let lock = NSLock()
                lock.lock()
                AsyncOperation.count += 1
                self.id = AsyncOperationID(number: AsyncOperation.count, title: id.title)
                lock.unlock()
            } else {
                self.id = id
            }
        } else {
            self.id = nil
        }
        super.init()
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    override var isFinished: Bool {
        return _finished
    }
    
    override func start() {
        guard !isCancelled else {
            finish()
            return
        }
        willChangeValue(forKey: "isExecuting")
        if let id = id {
            print("\(id.number!): \(id.title) operation is executing")
        }
        _executing = true
        didChangeValue(forKey: "isExecuting")
        main()
    }
    
    override func main() {
        fatalError("Should be overriden")
    }
    
    func finish() {
        willChangeValue(forKey: "isFinished")
        if let id = id {
            print("\(id.number!): \(id.title) operation finished")
        }
        _finished = true
        didChangeValue(forKey: "isFinished")
    }
    
    override func cancel() {
        if let id = id {
            print("\(id.number!): \(id.title) operation canselled")
        }
    }
    
}
