//
//  SignUpViewController.swift
//  instagramClone
//
//  Created by Sam Roman on 11/22/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        view.backgroundColor = .white
        setUpConstraints()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
    }
    
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
    
//    lazy var userNameTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = " Enter Username..."
//        textField.autocorrectionType = .no
//        textField.textAlignment = .left
//        textField.layer.cornerRadius = 15
//        textField.backgroundColor = .init(white: 1.0, alpha: 0.2)
//        textField.textColor = .black
//        textField.borderStyle = .roundedRect
//        textField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
//        return textField
//    }()
    
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
    
//    lazy var userNameIcon: UIImageView = {
//        let icon = UIImageView()
//        icon.image = UIImage(systemName: "person.circle", withConfiguration: .none)
//        icon.tintColor = .lightGray
//        icon.backgroundColor = .clear
//        return icon
//    }()
    
    
    lazy var alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont(name: "Verdana", size: 14)!, NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        attributedTitle.append(NSAttributedString(string: "Login!", attributes: [NSAttributedString.Key.font: UIFont(name: "Verdana-Bold", size: 14)!, NSAttributedString.Key.foregroundColor:  UIColor.magenta ]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(showLogIn), for: .touchUpInside)
     
        return button
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(34)
        button.backgroundColor = .magenta
//        button.addTarget(self, action: #selector(trySignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    //MARK: Private Methods


    
    //MARK: OBJC Methods
    
   
    
    @objc func showLogIn() {
        dismiss(animated: true, completion: nil)
    }

    @objc func validateFields() {
              guard emailTextField.hasText, passwordTextField.hasText else {
                  signUpButton.isEnabled = false
                  return
              }
              signUpButton.isEnabled = true
        emailIcon.tintColor = .magenta
           passwordIcon.tintColor = .magenta
          }
    

    
    //MARK: UI Setup
    
    private func setUpConstraints(){
        setupLoginStackView()
        setupHaveAccountButton()
        setupEmailIcon()
        setupPasswordIcon()
//        setupUserNameIcon()
        setUpSignUpButton()
        setupHaveAccountButton()
        
    }
    
     private func setupLoginStackView() {
           let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
           stackView.axis = .vertical
           stackView.spacing = 20
           stackView.distribution = .fillEqually
           self.view.addSubview(stackView)
           
           stackView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -400),
                                        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
                                        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
                                        stackView.heightAnchor.constraint(equalToConstant: 100)])
       }
    private func setupHaveAccountButton() {
            view.addSubview(alreadyHaveAccountButton)
            
            alreadyHaveAccountButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([alreadyHaveAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                         alreadyHaveAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                         alreadyHaveAccountButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                                         alreadyHaveAccountButton.heightAnchor.constraint(equalToConstant: 50)])
        }
       
    
    private func setUpSignUpButton(){
        view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30), signUpButton.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 70),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor)])
        view.layoutIfNeeded()
        
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
       
//       private func setupUserNameIcon(){
//           view.addSubview(userNameIcon)
//           userNameIcon.translatesAutoresizingMaskIntoConstraints = false
//           NSLayoutConstraint.activate([
//               userNameIcon.trailingAnchor.constraint(equalTo: userNameTextField.leadingAnchor, constant: -10),
//               userNameIcon.centerYAnchor.constraint(equalTo: userNameTextField.centerYAnchor),
//               userNameIcon.heightAnchor.constraint(equalToConstant: 30),
//               userNameIcon.widthAnchor.constraint(equalToConstant: 30)])
//       }
    
    
    

}
