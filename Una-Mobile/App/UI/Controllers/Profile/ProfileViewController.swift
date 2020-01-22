//
//  ProfileViewController.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 22.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private var user: User! {
        willSet {
            guard let user = newValue else { return }
            nameLabel.text = "\(user.firstName) \(user.lastName)"
            categoryLabel.text = user.isSuperuser ? "Админ" : "Ученик"
            locationLabel.text = "\(user.city), \(user.country)"
        }
    }
    
    // MARK: - Outlets

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet var router: ProfileRouter!
    
    // MARK: - Configures
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImageView.cornerRadius = photoImageView.frame.size.height / 2
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showUser()
    }
    
    private func showUser() {
        AuthService.shared.getUser { user in
            self.user = user
        }
    }
    
    private func configureNavigationBar() {
        self.title = "Профиль".uppercased()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(openProfileEditor))
    }
    
    @objc private func openProfileEditor() {
        router.toEditor { controller in
            controller.user = self.user
        }
    }

}
