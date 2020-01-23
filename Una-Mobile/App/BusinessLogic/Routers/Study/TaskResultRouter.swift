//
//  TaskResultRouter.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 24.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import UIKit

final class TaskResultRouter: BaseRouter {
    
    private let storyboardName = "Study"
    
    func backToLessonPart(animated: Bool) {
        self.pop(animated: animated)
    }
    
    func backToLessonPartsList(animated: Bool) {
        self.pop(animated: animated)
        self.pop(animated: animated)
    }
    
}
