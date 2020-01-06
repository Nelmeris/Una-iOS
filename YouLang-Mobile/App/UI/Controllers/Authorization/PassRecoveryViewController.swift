//
//  PassRecoveryViewController.swift
//  YouLang-Mobile
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

        self.navigationItem.title = "ВОССТАНОВЛЕНИЕ ПАРОЛЯ"
    }

}
