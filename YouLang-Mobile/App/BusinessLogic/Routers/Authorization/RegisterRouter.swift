//
//  RegisterRouter.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 13/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

final class RegisterRouter: BaseRouter {
    
    let mainStoryboardName = "Main"
    
    func toMain(configurate: ((MainTabBarViewController) -> ())?) {
        let controller = UIStoryboard(name: mainStoryboardName, bundle: nil).instantiateViewController(withIdentifier: "TabBar")
        if let configurate = configurate {
            configurate(controller as! MainTabBarViewController)
        }
        setAsRoot(controller)
    }
    
}
