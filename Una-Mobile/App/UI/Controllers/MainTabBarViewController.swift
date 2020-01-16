//
//  MainTabBarViewController.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 13/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    // MARK: - Properties
    
    private let storyboardName = "Study"
    private let lessonItemTitle = "Уроки"
    
    // MARK: - Configures
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setControllers()
    }
    
    private func configure() {
        self.tabBar.isTranslucent = true
        self.tabBar.barTintColor = UIColor(named: "SecondColor")
        self.tabBar.tintColor = UIColor(named: "MainColor")
    }
    
    private func setControllers() {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Study")
        let navController = UINavigationController(rootViewController: controller)
        navController.tabBarItem = UITabBarItem(title: lessonItemTitle, image: UIImage(named: "CourcesTabBarIcon"), tag: 0)
        navController.tabBarItem.badgeColor = UIColor(named: "TextColor")
        
        self.setViewControllers([navController], animated: true)
    }
    
}
