//
//  AuthRouter.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 13/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

final class AuthRouter: BaseRouter {
    
    private let storyboardName = "Authorization"
    
    private let loginVCId = "Login"
    private let registerVCId = "Register"
    
    func toLogin(configurate: ((LoginViewController) -> ())? = nil) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: loginVCId)
        guard let loginVC = controller as? LoginViewController else { fatalError() }
        configurate?(loginVC)
        show(loginVC, sender: self.controller)
    }
    
    func toRegister(configurate: ((RegisterViewController) -> ())? = nil) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: registerVCId)
        guard let registerVC = controller as? RegisterViewController else { fatalError() }
        configurate?(registerVC)
        show(registerVC, sender: self.controller)
    }
    
}
