//
//  ProfilePageController+handlers.swift
//  FinalProject
//
//  Created by Аскар on 22.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import Firebase

extension String {
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

extension ProfilePageController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @objc func handleChangeProfileImage(){
        print("change profile image")
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
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            let refOldImage = Database.database().reference().child("users").child(uid).child("profileImageUrl")
            refOldImage.observeSingleEvent(of: .value, with: { (snapshot) in
                let imageReference = snapshot.value as! String
                print(imageReference)
                let name = imageReference.slice(from: "%", to: "?")
                print(name as Any)
                if let name = name{
                    let storageRef = Storage.storage().reference().child("profile_images").child(name)
                    storageRef.delete(completion: { (error) in
                        if error != nil{
                            print("ne udalils9")
                        }
                    })
                }
                
            }, withCancel: nil)
        
            let refUpdate = Database.database().reference().child("users").child(uid)
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            if let profileImg = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImg, 0.1){
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil{
                        print("error with updating image")
                        
                        return
                    }
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString{
                        refUpdate.updateChildValues(["profileImageUrl": profileImageUrl] as [String: AnyObject])
                    }
                })
            }
            
            
            
            
            
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
        
    }
}

extension ProfilePageController{
    
    @objc func handleChangeUsername(){
        print("change username")
        let alert = UIAlertController(title: "Изменить username", message: "Введите новый username", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "New username"
        }
        
        alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { (_) in
            let textField = alert.textFields![0]
            if let id = Auth.auth().currentUser?.uid{
                let ref = Database.database().reference().child("users").child(id)
                if let text = textField.text{
                    if !text.isEmpty{
                        ref.updateChildValues(["username": text] as [String: AnyObject])
                    }
                }
                
            }
        }))
        
        alert.addAction(UIAlertAction.init(title: "Отмена", style: .cancel, handler: { (_) in
            print("cancel")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleChangeEmail(){
        print("change email")
        let alert = UIAlertController(title: "Изменить email", message: "Введите новый email", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "New email"
        }
        
        alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { (_) in
            let textField = alert.textFields![0]
            if let user = Auth.auth().currentUser{
                if let text = textField.text{
                    user.updateEmail(to: text, completion: { (error) in
                        if error != nil{
                            ToastView.shared.long(self.view, txt_msg: "Неверный email")
                        }
                    })
                }
            }
        }))
        
        
        alert.addAction(UIAlertAction.init(title: "Отмена", style: .cancel, handler: { (_) in
            print("cancel")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleChangePassword(){
        print("change password")
        print("change email")
        let alert = UIAlertController(title: "Изменить пароль", message: "Введите новый пароль", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "New password"
        }
        
        alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { (_) in
            let textField = alert.textFields![0]
            if let user = Auth.auth().currentUser{
                if let text = textField.text{
                    user.updatePassword(to: text, completion: { (error) in
                        if error != nil{
                            if text.count < 6 {
                                ToastView.shared.long(self.view, txt_msg: "Пароль должен содержать как минимум 6 символов")
                            }
                            else {
                                ToastView.shared.long(self.view, txt_msg: "Неверный пароль")
                            }
                        }
                    })
                }
            }
        }))
        
        alert.addAction(UIAlertAction.init(title: "Отмена", style: .cancel, handler: { (_) in
            print("cancel")
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
}
