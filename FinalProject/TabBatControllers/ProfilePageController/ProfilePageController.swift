//
//  ProfilePageController.swift
//  FinalProject
//
//  Created by Аскар on 06.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import Firebase

class ProfilePageController: UIViewController {
    
    
    @objc func handleLogout(){
        do{
            try Auth.auth().signOut()
        } catch{
            print("error")
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupConstraints()
        setupViews()
        
    }
    func setupViews(){
        let user = Auth.auth().currentUser
        if let user = user{
            let refUsername = Database.database().reference().child("users").child(user.uid).child("username")
            refUsername.observe(.value) { (snapshot) in
                let username = snapshot.value as! String
                self.usernameLabel.text = username
            }
            
            let refProfileImage = Database.database().reference().child("users").child(user.uid).child("profileImageUrl")
            refProfileImage.observe(.value) { (snapshot) in
                let imageUrl = snapshot.value as! String
                self.profileImageView.loadImageUsingKingfisherWithUrlString(urlString: imageUrl)
            }
            
            emailLabel.text = user.email
        }
    }
    
    func setupNavigationBar(){
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.isTranslucent = true
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }
    
    
    
    
    
    
    
    
    
    // profile image
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.image = UIImage.init(named: "actor")
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var changeProfileImageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Изменить фото"
        label.textColor = Colors.blueColor
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleChangeProfileImage))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let inputContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // username
    let usernameBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.darkBlueColor
        return view
    }()
    
    let usernameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.init(named: "user")
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "username"
        return label
    }()
    
    lazy var changeUsernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "изменить"
        label.textColor = Colors.blueColor
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleChangeUsername))
        label.addGestureRecognizer(tap)
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    // email
    let emailBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.darkBlueColor
        
        return view
    }()
    
    let emailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.init(named: "email")
        return imageView
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    lazy var changeEmailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "изменить"
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleChangeEmail))
        label.addGestureRecognizer(tap)
        label.textColor = Colors.blueColor
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    // password
    let passwordBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.darkBlueColor
        
        return view
    }()
    
    let passwordImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.init(named: "password")
        return imageView
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "******"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    lazy var changePasswordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "изменить"
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleChangePassword))
        label.addGestureRecognizer(tap)
        label.textColor = Colors.blueColor
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let buttonLogout: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.init(red: 19/255, green: 203/255, blue: 175/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        button.setTitle("Выйти", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    
    func setupConstraints(){
        view.addSubview(profileImageView)
        view.addSubview(changeProfileImageLabel)
        view.addSubview(inputContainerView)
        
        
        inputContainerView.addSubview(usernameBackgroundView)
        inputContainerView.addSubview(emailBackgroundView)
        inputContainerView.addSubview(passwordBackgroundView)
        inputContainerView.addSubview(buttonLogout)
        
        usernameBackgroundView.addSubview(usernameImageView)
        usernameBackgroundView.addSubview(usernameLabel)
        usernameBackgroundView.addSubview(changeUsernameLabel)
        
        emailBackgroundView.addSubview(emailImageView)
        emailBackgroundView.addSubview(emailLabel)
        emailBackgroundView.addSubview(changeEmailLabel)
        
        passwordBackgroundView.addSubview(passwordImageView)
        passwordBackgroundView.addSubview(passwordLabel)
        passwordBackgroundView.addSubview(changePasswordLabel)
        
        
        profileImageView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -50).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad{
            profileImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            profileImageView.layer.cornerRadius = 100
        }
        else{
            profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        }
        
        changeProfileImageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        changeProfileImageLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
        
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        inputContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.42).isActive = true
        
        usernameBackgroundView.anchor(top: inputContainerView.topAnchor, leading: inputContainerView.leadingAnchor, bottom: nil, trailing: inputContainerView.trailingAnchor, padding: UIEdgeInsets.init(top: 0, left: 40, bottom: 0, right: 40))
        usernameBackgroundView.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.13).isActive = true
        
        emailBackgroundView.anchor(top: usernameBackgroundView.bottomAnchor, leading: inputContainerView.leadingAnchor, bottom: nil, trailing: inputContainerView.trailingAnchor, padding: UIEdgeInsets.init(top: 24, left: 40, bottom: 0, right: 40))
        emailBackgroundView.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.13).isActive = true
        
        
        passwordBackgroundView.anchor(top: emailBackgroundView.bottomAnchor, leading: inputContainerView.leadingAnchor, bottom: nil, trailing: inputContainerView.trailingAnchor, padding: UIEdgeInsets.init(top: 24, left: 40, bottom: 0, right: 40))
        passwordBackgroundView.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.13).isActive = true
        
        buttonLogout.anchor(top: passwordBackgroundView.bottomAnchor, leading: inputContainerView.leadingAnchor, bottom: nil, trailing: inputContainerView.trailingAnchor, padding: UIEdgeInsets.init(top: 48, left: 40, bottom: 100, right: 40))
        buttonLogout.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.13).isActive = true
        
        
        usernameImageView.centerYAnchor.constraint(equalTo: usernameBackgroundView.centerYAnchor).isActive = true
        usernameImageView.leadingAnchor.constraint(equalTo: usernameBackgroundView.leadingAnchor, constant: 8).isActive = true
        usernameImageView.heightAnchor.constraint(equalTo: usernameBackgroundView.heightAnchor, multiplier: 0.6).isActive = true
        usernameImageView.widthAnchor.constraint(equalTo: usernameBackgroundView.heightAnchor, multiplier: 0.6).isActive = true
        
        usernameLabel.centerYAnchor.constraint(equalTo: usernameBackgroundView.centerYAnchor).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: usernameImageView.trailingAnchor, constant: 8).isActive = true
        
        changeUsernameLabel.centerYAnchor.constraint(equalTo: usernameBackgroundView.centerYAnchor).isActive = true
        changeUsernameLabel.trailingAnchor.constraint(equalTo: usernameBackgroundView.trailingAnchor, constant: -8).isActive = true
        
        
        emailImageView.centerYAnchor.constraint(equalTo: emailBackgroundView.centerYAnchor).isActive = true
        emailImageView.leadingAnchor.constraint(equalTo: emailBackgroundView.leadingAnchor, constant: 8).isActive = true
        emailImageView.heightAnchor.constraint(equalTo: emailBackgroundView.heightAnchor, multiplier: 0.6).isActive = true
        emailImageView.widthAnchor.constraint(equalTo: emailBackgroundView.heightAnchor, multiplier: 0.6).isActive = true
        
        emailLabel.centerYAnchor.constraint(equalTo: emailBackgroundView.centerYAnchor).isActive = true
        emailLabel.leadingAnchor.constraint(equalTo: usernameImageView.trailingAnchor, constant: 8).isActive = true
        
        changeEmailLabel.centerYAnchor.constraint(equalTo: emailBackgroundView.centerYAnchor).isActive = true
        changeEmailLabel.trailingAnchor.constraint(equalTo: emailBackgroundView.trailingAnchor, constant: -8).isActive = true
        
        
        passwordImageView.centerYAnchor.constraint(equalTo: passwordBackgroundView.centerYAnchor).isActive = true
        passwordImageView.leadingAnchor.constraint(equalTo: passwordBackgroundView.leadingAnchor, constant: 8).isActive = true
        passwordImageView.heightAnchor.constraint(equalTo: passwordBackgroundView.heightAnchor, multiplier: 0.6).isActive = true
        passwordImageView.widthAnchor.constraint(equalTo: passwordBackgroundView.heightAnchor, multiplier: 0.6).isActive = true
        
        passwordLabel.centerYAnchor.constraint(equalTo: passwordBackgroundView.centerYAnchor).isActive = true
        passwordLabel.leadingAnchor.constraint(equalTo: usernameImageView.trailingAnchor, constant: 8).isActive = true
        
        changePasswordLabel.centerYAnchor.constraint(equalTo: passwordBackgroundView.centerYAnchor).isActive = true
        changePasswordLabel.trailingAnchor.constraint(equalTo: passwordBackgroundView.trailingAnchor, constant: -8).isActive = true
    }
    
}


