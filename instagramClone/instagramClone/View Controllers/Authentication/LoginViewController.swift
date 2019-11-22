//
//  LoginViewController.swift
//  instagramClone
//
//  Created by Sam Roman on 11/22/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    //MARK: UI TextFields
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " Enter Email..."
        textField.autocorrectionType = .no
        textField.textAlignment = .left
        textField.layer.cornerRadius = 15
        textField.backgroundColor = .init(white: 1.0, alpha: 0.2)
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " Enter Password..."
        textField.autocorrectionType = .no
        textField.textAlignment = .left
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 15
        textField.backgroundColor = .init(white: 1.0, alpha: 0.2)
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        return textField
    }()
    
    
    lazy var emailIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "at", withConfiguration: .none)
        icon.tintColor = .lightGray
        icon.backgroundColor = .clear
        return icon
    }()
    
    lazy var passwordIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "lock.circle", withConfiguration: .none)
        icon.tintColor = .lightGray
        icon.backgroundColor = .clear
        return icon
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(34)
        button.backgroundColor = .cyan
        button.addTarget(self, action: #selector(tryLogin), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    
    
    

    override func viewDidLoad() {
        view.backgroundColor = .white
        setUpConstraints()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: Private Methods
    private func clearAllFields(){
           emailTextField.text = ""
           passwordTextField.text = ""
       }
       
    
    //MARK: OBJ-C Methods
    
    @objc func validateFields() {
           guard emailTextField.hasText, passwordTextField.hasText else {
               loginButton.isEnabled = false
               return
           }
           loginButton.isEnabled = true
           emailIcon.tintColor = .systemPurple
           passwordIcon.tintColor = .systemPurple
       }
    
    @objc func tryLogin() {
       
        guard let email = emailTextField.text, let password = passwordTextField.text else {
             clearAllFields()
//           self.showFloatCellAlert(with: .topFloat, title: "oops!", description: "Please fill out all fields.", image: nil)
            return
        }
        
        guard email.isValidEmail else {
            clearAllFields()
//                self.showFloatCellAlert(with: .topFloat, title: "oops!", description: "Please enter a valid email", image: nil)

            return
        }
        
        guard password.isValidPassword else {
            clearAllFields()
//                self.showFloatCellAlert(with: .topFloat, title: "oops!", description: "Please enter a valid password. Passwords must have at least 8 characters.", image: nil)

            return
        }
        FirebaseAuthService.manager.loginUser(email: email.lowercased(), password: password) { (result) in
            self.handleLoginResponse(with: result)
        }
    }

    //MARK: Firebase Authentication Methods
    private func handleLoginResponse(with result: Result<User, Error>) {
        switch result {
        case .failure(let error):
            print(error)
//                self.showAlert(with: "Error", and: "Could not log in. Error: \(error)")
//
        case .success:
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
        let sceneDelegate = windowScene.delegate as? SceneDelegate
        else { return }
        print("login successful")
        sceneDelegate.window?.rootViewController = MainTabBarViewController()

            }
        }
    
    
    
    //MARK: UI Setup
    
    private func setUpConstraints(){
        setupLoginStackView()
        setupEmailIcon()
        setupPasswordIcon()
        setUpLoginButton()
    }
    private func setupLoginStackView() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        self.view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -400),
                                     stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
                                     stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
                                     stackView.heightAnchor.constraint(equalToConstant: 100)])
    }
    
    private func setupEmailIcon(){
        view.addSubview(emailIcon)
        emailIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailIcon.trailingAnchor.constraint(equalTo: emailTextField.leadingAnchor, constant: -10),
            emailIcon.centerYAnchor.constraint(equalTo: emailTextField.centerYAnchor),
            emailIcon.heightAnchor.constraint(equalToConstant: 30),
            emailIcon.widthAnchor.constraint(equalToConstant: 30)])
    }
    
    private func setupPasswordIcon(){
        view.addSubview(passwordIcon)
        passwordIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordIcon.trailingAnchor.constraint(equalTo: passwordTextField.leadingAnchor, constant: -10),
            passwordIcon.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor),
            passwordIcon.heightAnchor.constraint(equalToConstant: 30),
            passwordIcon.widthAnchor.constraint(equalToConstant: 30)])
    }
    
    private func setUpLoginButton(){
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30), loginButton.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 70),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor)])
        view.layoutIfNeeded()
        
    }

}
