//
//  LoginRouter.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 13/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

final class LoginRouter: BaseRouter {
    
    let storyboardName = "Authorization"
    let mainStoryboardName = "Main"
    
    func toPassRecovery(configurate: ((PassRecoveryViewController) -> ())?) {
        let controller = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "PassRecovery")
        show(controller, sender: self.controller)
        if let configurate = configurate {
            configurate(controller as! PassRecoveryViewController)
        }
    }
    
    func toMain(configurate: ((MainTabBarViewController) -> ())?) {
        let controller = UIStoryboard(name: mainStoryboardName, bundle: nil).instantiateViewController(withIdentifier: "TabBar")
        if let configurate = configurate {
            configurate(controller as! MainTabBarViewController)
        }
        setAsRoot(controller)
    }
    
}
