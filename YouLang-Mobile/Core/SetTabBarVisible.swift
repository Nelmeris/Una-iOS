//
//  SetTabBarVisible.swift
//  YouLang-Mobile
//
//  Created by Артем Куфаев on 29/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit
import CoreGraphics

extension UIViewController {
    
    func setTabBarVisible(visible:Bool, animated:Bool) {
        
        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
        
        // bail if the current state matches the desired state
        if (tabBarIsVisible() == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)
        
        // zero duration means no animation
        let duration:TimeInterval = (animated ? 0.3 : 0.0)
        
        self.hidesBottomBarWhenPushed = !visible
        
        // animate the tabBar
        if frame != nil {
            UIView.animate(withDuration: duration) {
                self.tabBarController?.tabBar.frame = (frame?.offsetBy(dx: 0, dy: offsetY!))!
                return
            }
        }
    }
    
    func tabBarIsVisible() -> Bool {
        return (self.tabBarController?.tabBar.frame.origin.y)! <= self.view.frame.maxY
    }
    
}
