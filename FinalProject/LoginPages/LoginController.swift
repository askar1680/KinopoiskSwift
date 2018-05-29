//
//  LoginController.swift
//  FinalProject
//
//  Created by Аскар on 06.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import Firebase


extension LoginController: ToastDelegate{
    func verifyEmail() {
        ToastView.shared.long(self.view, txt_msg: "Подтвердите свой электронный адрес")
    }
}


class LoginController: UIViewController {
    let transition = AnimationTransition()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupConstraints()
        indicator.isHidden = true
        checkingForFirstOpening()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil{
            //if (Auth.auth().currentUser?.isEmailVerified)!{
                present(MainController(), animated: false, completion: nil)
            //}
        }
    }
    
    func checkingForFirstOpening(){
        let preferences = UserDefaults.standard
        let currentLevelKey = "firsttime"
        if preferences.integer(forKey: currentLevelKey) == 1{
            
        } else {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            let startController = SwipingViewController.init(collectionViewLayout: layout)
            present(startController, animated: false, completion: nil)
            preferences.set(1, forKey: currentLevelKey)
            preferences.synchronize()
        }
        
    }
    
    // Button pressed
    @objc func handleLogin(){
        indicator.isHidden = false
        indicator.startAnimating()
        if let email = emailTextField.text, let password = passwordTextField.text{
            if email.isEmpty || password.isEmpty{
                ToastView.shared.long(self.view, txt_msg: "Заполните все поля")
                stopAnimatingIndicator()
                return
            }
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error != nil{
                    ToastView.shared.long(self.view, txt_msg: "Неправильный логин или пароль")
                    self.stopAnimatingIndicator()
                    return
                }
                if !(user?.isEmailVerified)!{
                    ToastView.shared.long(self.view, txt_msg: "Подтвердите свой электронный адрес")
                    self.stopAnimatingIndicator()
                    Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
                        self.present(MainController(), animated: true, completion: nil)
                    })
                    
                    return
                }
                self.stopAnimatingIndicator()
                self.present(MainController(), animated: true, completion: nil)
            }
        }
    }
    
    @objc func handleForgotPassword(){
        print("123")
        
        let alert = UIAlertController(title: "Пароль", message: "Забыли пароль?", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "email"
        }
        
        alert.addAction(UIAlertAction(title: "Отправить", style: .default, handler: { (_) in
            let textField = alert.textFields![0]
            if let text = textField.text{
                Auth.auth().sendPasswordReset(withEmail: text) { (error) in
                    if error != nil{
                        ToastView.shared.long(self.view, txt_msg: "Some error")
                        return
                    }
                    ToastView.shared.long(self.view, txt_msg: "Мы отправили пароль на ваш email")
                }
            }
            
        }))
        
        alert.addAction(UIAlertAction.init(title: "Отмена", style: .cancel, handler: { (_) in
            print("cancel")
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func handleRegister(){
        print(123)
        let registerController = RegisterController()
        registerController.toastDelegate = self
        present(registerController, animated: true, completion: nil)
    }
    
    func stopAnimatingIndicator(){
        UIView.animate(withDuration: 1, animations: {
            self.indicator.alpha = 0
        }, completion: { (isCompleted) in
            if isCompleted{
                self.indicator.alpha = 1
                self.indicator.isHidden = true
                self.indicator.stopAnimating()
            }
        })
    }
    
    // Views
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage.init(named: "start1")
        return imageView
    }()
    
    
    
    let blackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.6)
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let firstColor = UIColor.init(red: 1, green: 78/255, blue: 137/255, alpha: 1)
        let attributedText = NSMutableAttributedString(string: "Sounds", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 28),
                                                                                   NSAttributedStringKey.foregroundColor: firstColor
                                                                                   ])
        attributedText.append(NSAttributedString(string: "Well", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 28), NSAttributedStringKey.foregroundColor: UIColor.white]))
        label.attributedText = attributedText
        return label
    }()
    
    let inputContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
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
        
        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        textField.textColor = .white
        return textField
    }()
    
    let passwordTextField: UITextField = {
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
    
    lazy var forgotPasswordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Забыли пароль?"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleForgotPassword))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let buttonLogin: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.init(red: 19/255, green: 203/255, blue: 175/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("У вас ещё нет аккаунта? Зарегистрируйтесь", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        return button
    }()
    
    
    func setupConstraints(){
        
        view.addSubview(backgroundImageView)
        view.addSubview(blackView)
        view.addSubview(indicator)
        view.addSubview(nameLabel)
        view.addSubview(inputContainerView)
        
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(passwordTextField)
        inputContainerView.addSubview(forgotPasswordLabel)
        
        view.addSubview(buttonLogin)
        view.addSubview(registerButton)
        
        backgroundImageView.anchorFullSize(to: view)
        blackView.anchorFullSize(to: view)
        
        
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        indicator.widthAnchor.constraint(equalToConstant: 40).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        inputContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.24).isActive = true
        
        nameLabel.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -40).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        emailTextField.anchor(top: inputContainerView.topAnchor, leading: inputContainerView.leadingAnchor, bottom: nil, trailing: inputContainerView.trailingAnchor, padding: UIEdgeInsets.init(top: 0, left: 40, bottom: 0, right: 40))
        emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.23).isActive = true
        
        
        passwordTextField.anchor(top: emailTextField.bottomAnchor, leading: inputContainerView.leadingAnchor, bottom: nil, trailing: inputContainerView.trailingAnchor, padding: UIEdgeInsets.init(top: 24, left: 40, bottom: 0, right: 40))
        passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.23).isActive = true
        
        forgotPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 12).isActive = true
        forgotPasswordLabel.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor).isActive = true
        
        buttonLogin.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 8).isActive = true
        buttonLogin.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        buttonLogin.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        buttonLogin.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.23).isActive = true
        
        registerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        
    }
}

extension LoginController: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
}
