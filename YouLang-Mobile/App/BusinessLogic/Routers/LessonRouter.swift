//
//  LessonRouter.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 11.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

final class LessonRouter: BaseRouter {
    
    let storyboardName = "Main"
    
    func toTask(configurate: ((TaskViewController) -> ())?) {
        let controller = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "LessonTask") as! TaskViewController
        if let configurate = configurate {
            configurate(controller)
        }
        push(controller, animated: true)
    }
    
}
