//
//  AuthRouter.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 13/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

final class AuthRouter: BaseRouter {
    
    let storyboardName = "Authorization"
    
    func toLogin(configurate: ((LoginViewController) -> ())?) {
        let controller = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "Login")
        if let configurate = configurate {
            configurate(controller as! LoginViewController)
        }
        show(controller, sender: self.controller)
    }
    
    func toRegister(configurate: ((RegisterViewController) -> ())?) {
        let controller = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "Register")
        if let configurate = configurate {
            configurate(controller as! RegisterViewController)
        }
        show(controller, sender: self.controller)
    }
    
}
