//
//  StudyRouter.swift
//  Una-Mobile
//
//  Created by Артем Куфаев on 29/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

final class StudyRouter: BaseRouter {
    
    private let storyboardName = "Study"
    
    private let lessonViewControllerId = "Lesson"
    
    func toLesson(configurate: ((LessonPartsViewController) -> ())? = nil) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: lessonViewControllerId)
        guard let lessonPartsVC = controller as? LessonPartsViewController else { fatalError() }
        configurate?(lessonPartsVC)
        push(lessonPartsVC, animated: true)
    }
    
}

