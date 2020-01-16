//
//  PreferredStatusBarStyleNavigationController.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 17.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

extension UINavigationController {

   open override var preferredStatusBarStyle: UIStatusBarStyle {
      return topViewController?.preferredStatusBarStyle ?? .default
   }
}
