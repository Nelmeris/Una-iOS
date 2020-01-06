//
//  MainTabBarViewController.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 13/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    // MARK: - Configures
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setControllers()
    }
    
    private func configure() {
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = UIColor(named: "SecondColor")
        self.tabBar.tintColor = UIColor(named: "MainColor")
    }
    
    private func setControllers() {
        let controller = UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Study"))
        controller.tabBarItem = UITabBarItem(title: "Учеба", image: UIImage(named: "CourcesTabBarIcon"), tag: 0)
        controller.tabBarItem.badgeColor = UIColor(named: "TextColor")
        
        self.setViewControllers([controller], animated: true)
    }
    
}
