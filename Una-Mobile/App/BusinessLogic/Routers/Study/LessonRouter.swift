//
//  LessonRouter.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 11.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

final class LessonRouter: BaseRouter {
    
    private let storyboardName = "Study"
    
    private let lessonTaskControllerId = "LessonTask"
    
    func toTask(configurate: ((TaskViewController) -> ())? = nil) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: lessonTaskControllerId)
        guard let taskVC = controller as? TaskViewController else { fatalError() }
        configurate?(taskVC)
        push(taskVC, animated: true)
    }
    
}
