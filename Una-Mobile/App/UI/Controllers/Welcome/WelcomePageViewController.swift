//
//  WelcomePageViewController.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 13/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

class WelcomePageViewController: UIPageViewController {
    
    // MARK: - Properties
    
    let storyboardName = "Welcome"
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        [self.getViewController(withIdentifier: "Welcome1"),
        self.getViewController(withIdentifier: "Welcome2"),
        self.getViewController(withIdentifier: "Welcome3"),
        self.getViewController(withIdentifier: "Welcome4")]
    }()
    
    // MARK: - Configures

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    private func getViewController(withIdentifier name: String) -> UIViewController {
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "\(name)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.set(true, forKey: "isWelcome")
    }

}

// MARK: - PageViewControllerDataSource

extension WelcomePageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController),
            viewControllerIndex - 1 >= 0,
            orderedViewControllers.count > viewControllerIndex - 1
            else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex,
            orderedViewControllersCount > nextIndex
            else { return nil }
        
        return orderedViewControllers[nextIndex]
    }
    
}
