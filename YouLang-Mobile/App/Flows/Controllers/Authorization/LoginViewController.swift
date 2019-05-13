//
//  LoginViewController.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 13/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var router: LoginRouter!
    
    @IBOutlet var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginField.delegate = self
        self.navigationItem.title = "Авторизация"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func toMain(_ sender: Any) {
        if loginField.text == "root" && passwordField.text == "root" {
            router.toMain(configurate: nil)
        } else {
            passwordField.text = nil
            let alert = UIAlertController(title: "Ошибка", message: "Неверные данные", preferredStyle: .alert)
            let action = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func toPassRecovery(_ sender: Any) {
        router.toPassRecovery { (controller) in
            controller.loginText = self.loginField.text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
