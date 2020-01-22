//
//  ProfileEditorViewController.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 22.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

class ProfileEditorViewController: UIViewController, UITextFieldDelegate {
    
    var user: User!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var nameTextField: TextFieldUnderline!
    @IBOutlet weak var surnameTextField: TextFieldUnderline!
    @IBOutlet weak var cityTextField: TextFieldUnderline!
    @IBOutlet weak var countryTextField: TextFieldUnderline!
    @IBOutlet weak var birthdayTextField: TextFieldUnderline!
    @IBOutlet weak var emailTextField: TextFieldUnderline!
    @IBOutlet weak var passwordTextField: TextFieldUnderline!
    @IBOutlet weak var repeatPasswordTextField: TextFieldUnderline!
    @IBOutlet var router: ProfileEditorRouter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTextFields()
        registerForKeyboardNotifications(with: #selector(adjustForKeyboard))
        showProfile()
        addTapGestureToHideKeyboard()
    }
    
    private func configureTextFields() {
        nameTextField.delegate = self
        surnameTextField.delegate = self
        cityTextField.delegate = self
        countryTextField.delegate = self
        birthdayTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
    }
    
    private func showProfile() {
        nameTextField.text = user.firstName
        surnameTextField.text = user.lastName
        cityTextField.text = user.city
        countryTextField.text = user.country
        if let birthday = user.birthday {
            let str = UnaUserProfile.dateFormatter.string(from: birthday)
            birthdayTextField.text = str
        }
        emailTextField.text = user.email
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        guard let name = nameTextField.text,
            !name.isEmpty else {
            print()
                return
        }
        guard let surname = surnameTextField.text,
            !surname.isEmpty else {
            print()
                return
        }
        guard let city = cityTextField.text,
            !city.isEmpty else {
            print()
                return
        }
        guard let country = countryTextField.text,
            !country.isEmpty else {
            print()
                return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        guard let birthdayStr = birthdayTextField.text,
            !birthdayStr.isEmpty,
            let birthday = dateFormatter.date(from: birthdayStr) else {
            print()
                return
        }
        guard let email = emailTextField.text,
            !email.isEmpty else {
            print()
                return
        }
        do {
            _ = try ValidatorFactory.validatorFor(type: .email).validated(email)
        } catch {
            print(error)
        }
        let user = User(id: self.user.id, email: email, firstName: name, lastName: surname, isSuperuser: self.user.isSuperuser, country: country, city: city, birthday: birthday)
        AuthService.shared.saveUserChanges(user) {
            self.router.backToProfile(animated: true)
        }
    }
    
    @IBAction func exitFromAccount(_ sender: Any) {
        AuthService.shared.logout()
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
