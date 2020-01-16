//
//  RegisterRouter.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 13/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

final class RegisterRouter: BaseRouter {
    
    func toMain(configurate: ((MainTabBarViewController) -> ())? = nil) {
        let controller = MainTabBarViewController()
        configurate?(controller)
        setAsRoot(controller)
    }
    
}
