//
//  BaseRouter.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 13/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

class BaseRouter: NSObject {
    
    @IBOutlet weak var controller: UIViewController!
    
    func show(_ controller: UIViewController, sender: Any?) {
        self.controller.show(controller, sender: sender)
    }
    
    func present(_ controller: UIViewController, animated: Bool) {
        self.controller.present(controller, animated: animated)
    }
    
    func dismiss(aminated: Bool, completion: (() -> Void)?) {
        self.controller.dismiss(animated: aminated, completion: completion)
    }
    
    func setAsRoot(_ controller: UIViewController) {
        ApplicationRouter.shared.setAsRoot(controller)
    }
    
    func push(_ controller: UIViewController, animated: Bool) {
        self.controller.navigationController?.pushViewController(controller, animated: animated)
    }
    
    func pop(animated: Bool) {
        self.controller.navigationController?.popViewController(animated: animated)
    }
    
}
