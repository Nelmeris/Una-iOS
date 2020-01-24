//
//  PassRecoveryViewController.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 13/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

class PassRecoveryViewController: UIViewController {
    
    // MARK: - Properties

    var loginText: String?
    
    // MARK: - Outlets
    
    @IBOutlet weak var loginField: UITextField! {
        didSet {
            loginField.text = loginText
        }
    }
    
    // MARK: - Configures
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Восстановление пароля".uppercased()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }

}
