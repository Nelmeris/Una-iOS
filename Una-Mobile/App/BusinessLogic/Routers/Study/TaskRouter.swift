//
//  TaskRouter.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 24.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import UIKit

final class TaskRouter: BaseRouter {
    
    private let storyboardName = "Study"
    private let lessonTaskResultControllerId = "LessonTaskResult"
    
    func toResult(configurate: ((TaskResultViewController) -> ())? = nil) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: lessonTaskResultControllerId)
        guard let taskVC = controller as? TaskResultViewController else { fatalError() }
        configurate?(taskVC)
        push(taskVC, animated: true)
    }
    
}
