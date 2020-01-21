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
    
    private var user: UnaAuthUser! {
        willSet {
            guard let user = newValue else { return }
            nameLabel.text = "\(user.firstName) \(user.lastName)"
            categoryLabel.text = user.isSuperuser ? "Админ" : "Ученик"
        }
    }
    private var profile: UnaUserProfile! {
        willSet {
            guard let profile = newValue else { return }
            locationLabel.text = "\(profile.city), \(profile.country)"
        }
    }
    
    // MARK: - Outlets

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    // MARK: - Configures
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImageView.cornerRadius = photoImageView.frame.size.height / 2
        configureNavigationBar()
        showUser()
    }
    
    private func showUser() {
        AuthService.shared.getUser { userData in
            self.user = userData?.0
            self.profile = userData?.1
        }
    }
    
    private func configureNavigationBar() {
        self.title = "Профиль".uppercased()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(openProfileEditor))
    }
    
    @objc private func openProfileEditor() {
        
    }

}
