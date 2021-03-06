//
//  LoginViewController.swift
//  Una-Mobile
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
    @IBOutlet var emailField: TextFieldUnderline!
    @IBOutlet weak var passwordField: TextFieldUnderline!
    
    // MARK: - Configures
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForKeyboardNotifications(with: #selector(adjustForKeyboard))
        configureTextFields()
        configureNavigationController()
        addTapGestureToHideKeyboard()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
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
        self.navigationItem.title = "Авторизация".uppercased()
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    // MARK: - Actions
    
    @IBAction func toMain(_ sender: Any) {
        guard let data = getData() else { return }
        AuthManager.shared.login(email: data.email, password: data.password) { (isAuth, error) in
            guard error == nil else {
                self.showJustAlert(title: "Сетевая ошибка", message: error!.localizedDescription)
                return
            }
            guard isAuth else {
                self.showJustAlert(title: "Неизвестная ошибка")
                return
            }
            DispatchQueue.main.async {
                self.router.toMain()
            }
        }
    }
    
    private func getData() -> (email: String, password: String)? {
        guard let email = emailField.text,
            !email.isEmpty else {
            self.showJustAlert(title: "Ошибка", message: "Введите почту")
            return nil
        }
        guard let password = passwordField.text,
            !password.isEmpty else {
            self.showJustAlert(title: "Ошибка", message: "Введите пароль")
            return nil
        }
        do {
//            let password = try ValidatorFactory.validatorFor(type: .password).validated(password)
            return (email, password)
        } catch (let error as ValidationError) {
            showJustAlert(title: "Ошибка", message: error.message)
        } catch {}
        return nil
    }
    
    @IBAction func toPassRecovery(_ sender: Any) {
        router.toPassRecovery { controller in
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
    
    var selectedTextFieldYPosition: CGFloat = 0.0
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextFieldYPosition = textField.frame.origin.y - textField.frame.size.height
    }
    
    @objc func adjustForKeyboard(_ notification: Notification) {
        scrollViewContentShift(keyboardNotification: notification, scrollView: scrollView, position: selectedTextFieldYPosition)
    }
    
    deinit {
        removeKeyboardNotifications()
    }

}
