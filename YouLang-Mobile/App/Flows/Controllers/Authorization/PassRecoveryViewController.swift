//
//  PassRecoveryViewController.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 13/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

class PassRecoveryViewController: UIViewController {

    @IBOutlet weak var loginField: UITextField! {
        didSet {
            loginField.text = loginText
        }
    }
    var loginText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Восстановление пароля"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
