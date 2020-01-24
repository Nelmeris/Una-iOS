//
//  RegisterViewController.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 13/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit
import Keychain

class RegisterViewController: UIViewController, UITextFieldDelegate, AlertDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet var router: RegisterRouter!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var firstNameField: TextFieldUnderline!
    @IBOutlet weak var lastNameField: TextFieldUnderline!
    @IBOutlet weak var emailField: TextFieldUnderline!
    @IBOutlet weak var passwordField: TextFieldUnderline!
    @IBOutlet weak var rPasswordField: TextFieldUnderline!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextFields()
        configureNavigationController()
        registerForKeyboardNotifications(with: #selector(adjustForKeyboard))
        addTapGestureToHideKeyboard()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    // MARK: - Configures
    
    private func configureTextFields() {
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        rPasswordField.delegate = self
    }
    
    private func configureNavigationController() {
        self.navigationItem.title = "Регистрация".uppercased()
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    // MARK: - Actions
    
    @IBAction func registrationProcess(_ sender: Any) {
        do {
            let firstName = try ValidatorFactory.validatorFor(type: .username).validated(firstNameField.text ?? "")
            let lastName = try ValidatorFactory.validatorFor(type: .username).validated(lastNameField.text ?? "")
            let email = try ValidatorFactory.validatorFor(type: .email).validated(emailField.text ?? "")
            let password = try ValidatorFactory.validatorFor(type: .password).validated(passwordField.text ?? "")
            let rPassword = try ValidatorFactory.validatorFor(type: .password).validated(rPasswordField.text ?? "")
            guard password == rPassword else { showJustAlert(title: "Ошибка", message: "Пароли не совпадают"); return }
//            YLService.shared.register(firstName: firstName, lastName: lastName, email: email, password: password) { response in
//                switch response.result {
//                case .success(let value):
//                    if (!Keychain.save(value.accessToken, forKey: "access_token")) {
//                        fatalError()
//                    }
//                    DispatchQueue.main.async {
//                        self.router.toMain(configurate: nil)
//                    }
//                case .failure(let error):
//                    if let ylError = error as? YLErrorResponses {
//                        self.showJustAlert(title: "Ошибка", message: ylError.errorDescription!)
//                    } else {
//                        self.showJustAlert(title: "Сетевая ошибка", message: error.localizedDescription)
//                    }
//                }
//            }
        } catch(let error as ValidationError) {
            showJustAlert(title: "Ошибка", message: error.message)
            return
        } catch(_) {}
    }
    
    // MARK: - TextField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameField {
            lastNameField.becomeFirstResponder()
        } else if textField == lastNameField {
            emailField.becomeFirstResponder()
        } else if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            rPasswordField.becomeFirstResponder()
        } else {
            self.view.dismissKeyboard()
            registrationProcess(textField)
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
