//
//  ScrollableKeyboard.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 22.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    internal func registerForKeyboardNotifications(with selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: selector, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    internal func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    internal func scrollViewContentShift(keyboardNotification: Notification, scrollView: UIScrollView, position: CGFloat) {
        guard let keyboardValue = keyboardNotification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        let keyboardHeight = keyboardViewEndFrame.height - view.safeAreaInsets.bottom

        let contentHeight = scrollView.contentSize.height
//        let screenHeight = self.view.frame.height
        let scrollViewHegith = scrollView.frame.size.height
        
        if keyboardNotification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
//            let offset = scrollView.contentOffset.y - keyboardHeight
//            scrollView.setContentOffset(CGPoint(x: 0, y: offset > 0 ? offset : 0), animated: true)
        } else {
            let offset = (contentHeight - position)
            > scrollView.frame.size.height - keyboardHeight
                ? position
                : contentHeight - (scrollViewHegith - keyboardHeight)
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0) // Отступ от нижнего края
            scrollView.setContentOffset(CGPoint(x: 0, y: offset), animated: true) // Сдвиг прокрутки до нужного места
        }
    }
    
}
