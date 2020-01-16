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
    
    private let passRecoveryVCId = "PassRecovery"
    
    func toPassRecovery(configurate: ((PassRecoveryViewController) -> ())? = nil) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: passRecoveryVCId)
        guard let passRecoveryVC = controller as? PassRecoveryViewController else { fatalError() }
        configurate?(passRecoveryVC)
        show(passRecoveryVC, sender: self.controller)
    }
    
    func toMain(configurate: ((MainTabBarViewController) -> ())? = nil) {
        let controller = MainTabBarViewController()
        configurate?(controller)
        setAsRoot(controller)
    }
    
}
