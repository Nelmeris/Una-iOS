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
        BaseUIOperation.queue.maxConcurrentOperationCount = 1
        BaseDatabaseOperation.queue.maxConcurrentOperationCount = 1
        BaseBackendOperation.queue.maxConcurrentOperationCount = 1
        print(BaseCoreDataService.persistentContainer.persistentStoreDescriptions.first?.url)
//        AuthManager.shared.logout()
//        UserDefaults.standard.removeObject(forKey: isWelcomeKey)
        clearDatabase()
    }
    
    private func clearDatabase() {
        let context = BaseCoreDataService.persistentContainer.viewContext
        let userCD = UserCoreDataService(context: context)
        let lessonCD = LessonCoreDataService(context: context)
        let lessonPartCD = LessonPartCoreDataService(context: context)
        let lessonTaskCD = LessonTaskCoreDataService(context: context)
        do {
            try userCD.removeAll()
            try lessonCD.removeAll()
            try lessonPartCD.removeAll()
            try lessonTaskCD.removeAll()
        } catch {
            print(error)
        }
    }
    
    private let welcomeIds = (storyboardName: "Welcome", vcId: "Page")
    private let authIds = (storyboardName: "Authorization", vcId: "Auth")
    private let studyIds = (storyboardName: "Study", vcId: "Study")
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
    
    public func configureBarButtonItemAppearance() {
        let BarButtonItemAppearance = UIBarButtonItem.appearance()
        BarButtonItemAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000.0, vertical: 0.0), for: .default)
    }
    
    public func getRootController() -> UIViewController {
        let userDefaults = UserDefaults.standard
        if !userDefaults.bool(forKey: isWelcomeKey) { // If need present WelcomePageViewController
            return UIStoryboard(name: welcomeIds.storyboardName, bundle: nil).instantiateViewController(withIdentifier: welcomeIds.vcId)
        } else {
            if !AuthManager.shared.isAuth() { // If need authorization
                let storyboard = UIStoryboard(name: authIds.storyboardName, bundle: nil)
                let authVC = storyboard.instantiateViewController(withIdentifier: authIds.vcId)
                let navControl = UINavigationController(rootViewController: authVC)
                navControl.modalPresentationStyle = .fullScreen
                return navControl
            } else {
                let storyboard = UIStoryboard(name: studyIds.storyboardName, bundle: nil)
                let studyVC = storyboard.instantiateViewController(withIdentifier: studyIds.vcId)
                let navControl = UINavigationController(rootViewController: studyVC)
                studyVC.modalPresentationStyle = .fullScreen
                return navControl
            }
        }
    }
    
}
