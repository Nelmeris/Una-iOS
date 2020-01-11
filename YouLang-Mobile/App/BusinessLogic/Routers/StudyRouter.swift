//
//  StudyRouter.swift
//  YouLang-Mobile
//
//  Created by Артем Куфаев on 29/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

final class StudyRouter: BaseRouter {
    
    let storyboardName = "Main"
    
    func toLesson(configurate: ((LessonPartsViewController) -> ())?) {
        let controller = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "Lesson") as! LessonPartsViewController
        if let configurate = configurate {
            configurate(controller)
        }
        push(controller, animated: true)
    }
    
}

