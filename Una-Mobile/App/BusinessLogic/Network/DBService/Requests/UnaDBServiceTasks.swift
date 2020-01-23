//
//  UnaDBServiceTasks.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 11.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation

protocol UnaDBServiceTasksFactory {
    func getTasks(for lessonPartId: Int, complete: @escaping ([UnaLessonTask]) -> ()) throws
}

extension UnaDBService: UnaDBServiceTasksFactory {
    
    func getTasks(for lessonPartId: Int, complete: @escaping ([UnaLessonTask]) -> ()) throws {
        let group = DispatchGroup()
        try self.request(with: (getLessonTasksSQL(), [String(lessonPartId)])) { values in
            var tasks: [UnaLessonTask] = []
            for value in values {
                let taskId = try value[1].int()
                let taskType = try value[2].int()
                switch taskType {
                case 1:
                    group.wait()
                    group.enter()
                    try self.getLessonTypeOne(with: taskId) {
                        tasks.append(contentsOf: $0)
                        group.leave()
                    }
                default: break;
                }
            }
            complete(tasks)
        }
    }
    
    private func getLessonTasksSQL() -> String {
        let tasksTable = "lessons_tasktype"
        return "SELECT * FROM \(tasksTable) WHERE lesson_part_id = $1;"
    }
    
    func getLessonTypeOne(with id: Int, complete: @escaping ([UnaLessonTaskFind]) -> ()) throws {
        try self.request(with: (getLessonTypeOneSQL(), [String(id)])) { values in
            var tasks: [UnaLessonTaskFind] = []
            try values.forEach { try tasks.append(UnaLessonTaskFind(from: $0)) }
            complete(tasks)
        }
    }
    
    private func getLessonTypeOneSQL() -> String {
        let table = "lessons_tasktypeone"
        return "SELECT * FROM \(table) WHERE id = $1;"
    }
    
}

