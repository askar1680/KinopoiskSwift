//
//  User.swift
//  FinalProject
//
//  Created by Аскар on 09.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import Firebase

struct MyUser {
    var id: String?{
        get{
            let currentUser = Auth.auth().currentUser
            return currentUser?.uid
        }
    }
    var email: String?{
        get{
            let currentUser = Auth.auth().currentUser
            return currentUser?.email
        }
    }
    
    var username: String?
    var profileImageUrl: String?
    
    
    init(username: String?, profileImageUrl: String?) {
        self.username = username
        self.profileImageUrl = profileImageUrl
    }
    init(snapshot: DataSnapshot) {
        let userDict = snapshot.value as! NSDictionary
        username = userDict.value(forKey: "username") as? String
        profileImageUrl = userDict.value(forKey: "profileImageUrl") as? String
    }
    func toJSONFormat() -> Any{
        return ["username": username, "profileImageUrl": profileImageUrl]
    }
}
