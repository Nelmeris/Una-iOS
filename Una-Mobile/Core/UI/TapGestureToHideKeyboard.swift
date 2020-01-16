//
//  TapGestureToHideKeyboard.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 24/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
}

extension UIView {
    
    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tapGesture)
    }
    
    var topSuperview: UIView? {
        var view = superview
        while view?.superview != nil {
            view = view!.superview
        }
        return view
    }
    
    @objc func dismissKeyboard() {
        topSuperview?.endEditing(true)
    }
    
}
