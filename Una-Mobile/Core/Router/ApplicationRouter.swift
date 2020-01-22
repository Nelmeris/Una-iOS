//
//  ApplicationRouter.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 22.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

final class ApplicationRouter {
    
    static let shared = ApplicationRouter()
    private init() {}
    
    func setAsRoot(_ controller: UIViewController) {
        guard let window = UIApplication.shared.windows.first else { fatalError() }
        window.rootViewController = controller
    }
    
    private func getVisibleViewController(base: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
      if let nav = base as? UINavigationController {
        let visible = nav.visibleViewController
        return getVisibleViewController(base: visible)
      }

      if let tab = base as? UITabBarController,
        let selected = tab.selectedViewController {
        return getVisibleViewController(base: selected)
      }

      if let presented = base?.presentedViewController {
        return getVisibleViewController(base: presented)
      }

      return base
    }
    
}
