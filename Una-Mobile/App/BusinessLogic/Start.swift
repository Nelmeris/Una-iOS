//
//  Start.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 16.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

class Start {
    
    static public let shared = Start()
    private init() {
        AuthService.shared.logout()
    }
    
    private let welcomeIds = (storyboardName: "Welcome", vcId: "Page")
    private let authIds = (storyboardName: "Authorization", vcId: "Auth")
    private let isWelcomeKey = "isWelcome"
    
    public func configureWindow(_ window: UIWindow) {
        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = .light
        }
    }
    
    public func configureNavBarAppearance() {
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.isTranslucent = false
        navigationBarAppearace.tintColor = UIColor(named: "MainColor")
        navigationBarAppearace.barTintColor = .white
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "MainColor")!]
    }
    
    public func getRootController() -> UIViewController {
        let userDefaults = UserDefaults.standard
        if !userDefaults.bool(forKey: isWelcomeKey) { // If need present WelcomePageViewController
            return UIStoryboard(name: welcomeIds.storyboardName, bundle: nil).instantiateViewController(withIdentifier: welcomeIds.vcId)
        } else {
            if !AuthService.shared.isAuth() { // If need authorization
                let authVC = UIStoryboard(name: authIds.storyboardName, bundle: nil).instantiateViewController(withIdentifier: authIds.vcId)
                let navControl = UINavigationController(rootViewController: authVC)
                navControl.modalPresentationStyle = .fullScreen
                return navControl
            } else {
                return MainTabBarViewController()
            }
        }
    }
    
}
