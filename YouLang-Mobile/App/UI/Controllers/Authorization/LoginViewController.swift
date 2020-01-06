//
//  LoginViewController.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 13/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit
import Keychain

class LoginViewController: UIViewController, UITextFieldDelegate, AlertDelegate {
    
    // MARK: - Outlets

    @IBOutlet var router: LoginRouter!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var emailField: CustomTextField!
    @IBOutlet weak var passwordField: CustomTextField!
    
    // MARK: - Configures
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForKeyboardNotifications()
        configureTextFields()
        configureNavigationController()
        addTapGestureToHideKeyboard()
    }
    
    private func configureTextFields() {
        emailField.delegate = self
        emailField.returnKeyType = .next
        emailField.attributedPlaceholder = NSAttributedString(string: "Email: ",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        passwordField.delegate = self
        passwordField.returnKeyType = .done
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password: ",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    private func configureNavigationController() {
        self.navigationItem.title = "АВТОРИЗАЦИЯ"
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    // MARK: - Actions
    
    @IBAction func toMain(_ sender: Any) {
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""
        YLService.shared.login(email: email, password: password) { response in
            switch response.result {
            case .success(let value):
                if (!Keychain.save(value.accessToken, forKey: "access_token")) {
                    fatalError()
                }
                DispatchQueue.main.async {
                    self.router.toMain(configurate: nil)
                }
            case .failure(let error):
                if let ylError = error as? YLErrorResponses {
                    self.showJustAlert(title: "Ошибка", message: ylError.errorDescription!)
                } else {
                    self.showJustAlert(title: "Сетевая ошибка", message: error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func toPassRecovery(_ sender: Any) {
        router.toPassRecovery { (controller) in
            controller.loginText = self.emailField.text
        }
    }
    
    // MARK: - TextField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else {
            self.view.dismissKeyboard()
            toMain(textField)
        }
        return false
    }
    
    // MARK: - Keyboard
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardNotifications() {
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
