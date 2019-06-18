//
//  UIAlertViewDelegate.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 29/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

protocol AlertDelegate: UIViewController {
    func showJustAlert(title: String, message: String?, action: ((UIAlertAction) -> Void)?)
}

extension AlertDelegate {
    
    func showJustAlert(title: String, message: String? = nil, action: ((UIAlertAction) -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: action)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
