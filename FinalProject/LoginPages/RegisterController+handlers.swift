//
//  RegisterController+handlers.swift
//  FinalProject
//
//  Created by Аскар on 09.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import Firebase

extension RegisterController{
    func registerUser(username: String, email: String, password: String, verify_password: String){
        if username.isEmpty || email.isEmpty || password.isEmpty || verify_password.isEmpty{
            ToastView.shared.long(self.view, txt_msg: "Заполните все поля")
            return
        }
        if password != verify_password {
            ToastView.shared.long(self.view, txt_msg: "Неправильный пароль")
            return
        }
        if password.count < 6 {
            ToastView.shared.long(self.view, txt_msg: "Пароль должен содержать как минимум 6 символов")
            return
        }
        else {
            indicator.isHidden = false
            indicator.startAnimating()
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if error != nil{
                    ToastView.shared.long(self.view, txt_msg: "Ошибка при регистрации")
                    UIView.animate(withDuration: 1, animations: {
                        self.indicator.alpha = 0
                    }, completion: { (isCompleted) in
                        if isCompleted{
                            self.indicator.alpha = 1
                            self.indicator.isHidden = true
                            self.indicator.stopAnimating()
                        }
                    })
                    
                    return
                }
                guard let uid = user?.uid else {return}
                let imageName = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
                if let profileImg = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImg, 0.1){
                    storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                        if error != nil{
                            print("error with uploading image")
                            UIView.animate(withDuration: 1, animations: {
                                self.indicator.alpha = 0
                            }, completion: { (isCompleted) in
                                if isCompleted{
                                    self.indicator.alpha = 1
                                    self.indicator.isHidden = true
                                    self.indicator.stopAnimating()
                                }
                            })
                            return
                        }
                        if let profileImageUrl = metadata?.downloadURL()?.absoluteString{
                            let values = ["username": username, "profileImageUrl": profileImageUrl]
                            self.registerUserInDataBaseWithUID(uid: uid, values: values as [String : AnyObject])
                        }
                    })
                }
            }
        }
    }
    
    
    private func registerUserInDataBaseWithUID(uid: String, values: [String: AnyObject]){
        let ref = Database.database().reference()
        let userRef = ref.child("users").child(uid)
        
        //let values = ["name": name, "email": email]
        
        userRef.setValue(values, withCompletionBlock: {
            (error, something) in
            if error != nil{
                print("some error with saving to database")
                UIView.animate(withDuration: 1, animations: {
                    self.indicator.alpha = 0
                }, completion: { (isCompleted) in
                    if isCompleted{
                        self.indicator.alpha = 1
                        self.indicator.isHidden = true
                        self.indicator.stopAnimating()
                    }
                })
                return
            }
            print("user saved to database successfully")
            UIView.animate(withDuration: 1, animations: {
                self.indicator.alpha = 0
            }, completion: { (isCompleted) in
                if isCompleted{
                    self.indicator.alpha = 1
                    self.indicator.isHidden = true
                    self.indicator.stopAnimating()
                }
            })
            self.dismiss(animated: true){
                self.toastDelegate?.verifyEmail()
            }
        })
    }
}




extension RegisterController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @objc func handleSelectProfileImageView(){
        print(321)
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
            print(editedImage.size)
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            print(originalImage.size)
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker{
            profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
        
    }
}
