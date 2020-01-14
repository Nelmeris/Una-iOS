//
//  AuthViewController.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 13/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet var router: AuthRouter!
    
    // MARK: - Configures
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Actions
    
    @IBAction func toLogin(_ sender: Any) {
        router.toLogin(configurate: nil)
    }
    
    @IBAction func toRegister(_ sender: Any) {
        router.toRegister(configurate: nil)
    }

}
