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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var emailField: CustomTextField!
    @IBOutlet weak var passwordField: CustomTextField!
    
    // MARK: - Configuratings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForKeyboardNotifications()
        configureTextFields()
        configureNavigationController()
        addTapGestureToHideKeyboard()
    }
    
    func configureTextFields() {
        emailField.delegate = self
        emailField.returnKeyType = .next
        
        passwordField.delegate = self
        passwordField.returnKeyType = .done
    }
    
    func configureNavigationController() {
        self.navigationItem.title = "АВТОРИЗАЦИЯ"
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    // MARK: - Button Handlers
    
    @IBAction func toMain(_ sender: Any) {
        guard let email = emailField.text,
            let password = passwordField.text else { return }
        let factory = YLRequestFactory()
        let auth = factory.makeAuthRequestFatory()
        auth.login(email: email, password: password) { (response) in
            guard let value = response.value else {
                DispatchQueue.main.async {
                    self.passwordField.text = nil
                    let alert = UIAlertController(title: "Ошибка", message: "Неверные данные", preferredStyle: .alert)
                    let action = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                return
            }
            DispatchQueue.main.async {
                UserDefaults.standard.set(value.accessToken, forKey: "access_token")
                self.router.toMain(configurate: nil);
            }
        }
    }
    
    @IBAction func toPassRecovery(_ sender: Any) {
        router.toPassRecovery { (controller) in
            controller.loginText = self.emailField.text
        }
    }
    
    // MARK: - TextField & Keyboard
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
            toMain(textField)
        }
        return false
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func kbWillShow(_ notification: Notification) {
        let offsetY = emailField.frame.origin.y - emailField.frame.size.height
        scrollView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
    }
    
    @objc func kbWillHide() {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    deinit {
        removeKeyboardNotifications()
    }

}
