//
//  StudyRouter.swift
//  Una-Mobile
//
//  Created by Артем Куфаев on 29/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

final class StudyRouter: BaseRouter {
    
    private let studyStoryboardName = "Study"
    private let profileStoryboardName = "Profile"
    
    private let lessonViewControllerId = "Lesson"
    private let profileViewControllerId = "Profile"
    
    func toLesson(configurate: ((LessonPartsViewController) -> ())? = nil) {
        let storyboard = UIStoryboard(name: studyStoryboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: lessonViewControllerId)
        guard let lessonPartsVC = controller as? LessonPartsViewController else { fatalError() }
        configurate?(lessonPartsVC)
        push(lessonPartsVC, animated: true)
    }
    
    func toProfile(configurate: ((ProfileViewController) -> ())? = nil) {
        let storyboard = UIStoryboard(name: profileStoryboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: profileViewControllerId)
        guard let profileVC = controller as? ProfileViewController else { fatalError() }
        configurate?(profileVC)
        push(profileVC, animated: true)
    }
    
}

