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
        registerForKeyboardNotifications()
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
        firstNameField.returnKeyType = .next
        
        lastNameField.delegate = self
        lastNameField.returnKeyType = .next
        
        emailField.delegate = self
        emailField.returnKeyType = .next
        
        passwordField.delegate = self
        passwordField.returnKeyType = .next
        
        rPasswordField.delegate = self
        rPasswordField.returnKeyType = .done
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
            YLService.shared.register(firstName: firstName, lastName: lastName, email: email, password: password) { response in
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
        } catch(let error as ValidationError) {
            showJustAlert(title: "Ошибка", message: error.message)
            return
        } catch(_) {}
    }
    
    // MARK: - TextField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case let field where field == firstNameField:
            lastNameField.becomeFirstResponder()
            break
        case let field where field == lastNameField:
            emailField.becomeFirstResponder()
            break
        case let field where field == emailField:
            passwordField.becomeFirstResponder()
            break
        case let field where field == passwordField:
            rPasswordField.becomeFirstResponder()
            break
            
        default:
            self.view.dismissKeyboard()
            registrationProcess(textField)
            break;
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
        let offsetY = firstNameField.frame.origin.y - firstNameField.frame.size.height
        scrollView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
    }
    
    @objc func kbWillHide() {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
}
