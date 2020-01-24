//
//  WelcomeRouter.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 17.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

final class WelcomeRouter: BaseRouter {
    
    private let authStoryboardName = "Authorization"
    private let studyStoryboardName = "Study"
    
    private let authVCId = "Auth"
    private let studyVCId = "Study"
    
    func toAuth(configurate: ((AuthViewController) -> ())? = nil) {
        let storyboard = UIStoryboard(name: authStoryboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: authVCId)
        guard let authVC = controller as? AuthViewController else { fatalError() }
        configurate?(authVC)
        let navControl = UINavigationController(rootViewController: authVC)
        navControl.modalPresentationStyle = .fullScreen
        self.setAsRoot(navControl)
    }
    
    func toStudy(configurate: ((StudyViewController) -> ())? = nil) {
        let storyboard = UIStoryboard(name: studyStoryboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: studyVCId)
        guard let studyVC = controller as? StudyViewController else { fatalError() }
        configurate?(studyVC)
        let navControl = UINavigationController(rootViewController: studyVC)
        studyVC.modalPresentationStyle = .fullScreen
        self.setAsRoot(navControl)
    }
    
}
