//
//  ProfileViewController.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 22.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, AlertDelegate {
    
    // MARK: - Properties
    
    private var user: User! {
        willSet {
            guard let user = newValue else { return }
            nameLabel.text = "\(user.name!) \(user.surname!)"
            categoryLabel.text = user.isSuperuser ? "Админ" : "Ученик"
            locationLabel.text = "\(user.city ?? ""), \(user.country ?? "")"
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
        guard let userEmail = AuthManager.shared.userEmail else {
            AuthManager.shared.logout()
            return
        }
        UserDataManager.default.get(with: userEmail) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.user = user
                case .failure(let error):
                    self.showJustAlert(title: "Operation Error", message: error.localizedDescription)
                }
            }
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
