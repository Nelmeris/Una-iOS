//
//  ConfiguratePerformForSegue.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 13/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

extension UIViewController {
    
    typealias ConfiguratePerformSegue = (UIStoryboardSegue) -> ()
    func performSegueWithIdentifier(identifier: String, sender: AnyObject?, configurate: ConfiguratePerformSegue?) {
        
    }
    
}
