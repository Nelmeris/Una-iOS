//
//  LoginRouter.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 13/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

final class LoginRouter: BaseRouter {
    
    private let storyboardName = "Authorization"
    private let studyStoryboardName = "Study"
    
    private let passRecoveryVCId = "PassRecovery"
    private let studyVCId = "Study"
    
    func toPassRecovery(configurate: ((PassRecoveryViewController) -> ())? = nil) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: passRecoveryVCId)
        guard let passRecoveryVC = controller as? PassRecoveryViewController else { fatalError() }
        configurate?(passRecoveryVC)
        show(passRecoveryVC, sender: self.controller)
    }
    
    func toMain(configurate: ((StudyViewController) -> ())? = nil) {
        let storyboard = UIStoryboard(name: studyStoryboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: studyVCId)
        guard let studyVC = controller as? StudyViewController else { fatalError() }
        configurate?(studyVC)
        let navControl = UINavigationController(rootViewController: studyVC)
        studyVC.modalPresentationStyle = .fullScreen
        self.setAsRoot(navControl)
    }
    
}
