//
//  RegisterController.swift
//  FinalProject
//
//  Created by Аскар on 07.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import Toast_Swift

protocol ToastDelegate{
    func verifyEmail()
}


class RegisterController: UIViewController {
    var toastDelegate: ToastDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // Button pressed
    @objc func handleLogin(){
        dismiss(animated: true, completion: nil)
        
    }
    @objc func handleRegister(){
        if let username = usernameTextField.text, let email = emailTextField.text,
                            let password = passwordTextField1.text, let verify_password = passwordTextField2.text{
            registerUser(username: username, email: email, password: password, verify_password: verify_password)
        }
    }
    
    // Views
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage.init(named: "register_background2")
        return imageView
    }()
    
    
    
    let blackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
        return view
    }()
    
    let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        return indicator
    }()
    
    let inputContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "profile1")
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.3)
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        
        textField.attributedPlaceholder = NSAttributedString(string: "Username",
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)])
        textField.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 8, y: textField.frame.height/2+12.5, width: 17, height: 17))
        let image = UIImage(named: "user_grey")
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        textField.addSubview(imageView)
        let paddingView = UIView(frame: CGRect.init(x: 0, y: 0, width: 32, height: textField.frame.height))
        textField.leftView = paddingView
        
        textField.textColor = .white
        return textField
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.3)
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        
        textField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)])
        textField.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 8, y: textField.frame.height/2+12.5, width: 17, height: 17))
        let image = UIImage(named: "email_grey")
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        textField.addSubview(imageView)
        let paddingView = UIView(frame: CGRect.init(x: 0, y: 0, width: 32, height: textField.frame.height))
        textField.leftView = paddingView
        
        textField.keyboardType = .emailAddress
        textField.textColor = .white
        return textField
    }()
    
    let passwordTextField1: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.3)
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
       
        textField.attributedPlaceholder = NSAttributedString(string: "password",
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)])
        textField.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 8, y: textField.frame.height/2+12.5, width: 17, height: 17))
        let image = UIImage(named: "password_grey")
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        textField.addSubview(imageView)
        let paddingView = UIView(frame: CGRect.init(x: 0, y: 0, width: 32, height: textField.frame.height))
        textField.leftView = paddingView
        
        textField.textColor = .white
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let passwordTextField2: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.3)
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        
        textField.attributedPlaceholder = NSAttributedString(string: "confirm password",
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)])
        textField.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 8, y: textField.frame.height/2+12.5, width: 17, height: 17))
        let image = UIImage(named: "password_grey")
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        textField.addSubview(imageView)
        let paddingView = UIView(frame: CGRect.init(x: 0, y: 0, width: 32, height: textField.frame.height))
        textField.leftView = paddingView
        
        textField.textColor = .white
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let buttonRegister: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.init(red: 19/255, green: 203/255, blue: 175/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        button.setTitle("Зарегистрироваться", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .selected)
        return button
    }()
    lazy var haveAnAccountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Уже зарегистрированы? Войдите", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.titleLabel?.textAlignment = .center
        buttonRegister.titleLabel?.numberOfLines = 2
        return button
    }()
    
    
    
    func setupConstraints(){
        
        view.addSubview(backgroundImageView)
        view.addSubview(blackView)
        view.addSubview(indicator)
        view.addSubview(profileImageView)
        view.addSubview(inputContainerView)
        inputContainerView.addSubview(usernameTextField)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(passwordTextField1)
        inputContainerView.addSubview(passwordTextField2)
        
        view.addSubview(buttonRegister)
        view.addSubview(haveAnAccountButton)
        
        backgroundImageView.anchorFullSize(to: view)
        blackView.anchorFullSize(to: view)
        
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        indicator.widthAnchor.constraint(equalToConstant: 40).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        inputContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.48).isActive = true
        
        profileImageView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -30).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        usernameTextField.anchor(top: inputContainerView.topAnchor, leading: inputContainerView.leadingAnchor, bottom: nil, trailing: inputContainerView.trailingAnchor, padding: UIEdgeInsets.init(top: 0, left: 40, bottom: 0, right: 40))
        usernameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.115).isActive = true
        
        
        
        emailTextField.anchor(top: usernameTextField.bottomAnchor, leading: inputContainerView.leadingAnchor, bottom: nil, trailing: inputContainerView.trailingAnchor, padding: UIEdgeInsets.init(top: 24, left: 40, bottom: 0, right: 40))
        emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.115).isActive = true
        
        
        
        passwordTextField1.anchor(top: emailTextField.bottomAnchor, leading: inputContainerView.leadingAnchor, bottom: nil, trailing: inputContainerView.trailingAnchor, padding: UIEdgeInsets.init(top: 24, left: 40, bottom: 0, right: 40))
        passwordTextField1.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.115).isActive = true
        
        
        
        passwordTextField2.anchor(top: passwordTextField1.bottomAnchor, leading: inputContainerView.leadingAnchor, bottom: nil, trailing: inputContainerView.trailingAnchor, padding: UIEdgeInsets.init(top: 24, left: 40, bottom: 0, right: 40))
        passwordTextField2.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.115).isActive = true
        
        
        
        buttonRegister.anchor(top: passwordTextField2.bottomAnchor, leading: inputContainerView.leadingAnchor, bottom: nil, trailing: inputContainerView.trailingAnchor, padding: UIEdgeInsets.init(top: 48, left: 40, bottom: 48, right: 40))
        buttonRegister.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.115).isActive = true
        
        haveAnAccountButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        haveAnAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        haveAnAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        haveAnAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
    }
    
    
    
}

