//
//  Comment.swift
//  FinalProject
//
//  Created by Аскар on 09.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import Firebase

struct Comment {
    var userUrl: String?
    var timestamp: Int?
    var comment: String?
    init(userUrl: String, timestamp: Int, comment: String) {
        self.comment = comment
        self.timestamp = timestamp
        self.userUrl = userUrl
    }
    
    func toJSONFormat() -> Any{
        return ["userUrl": userUrl!, "timestamp": timestamp!, "comment": comment!]
    }
    
    init(snapshot: DataSnapshot) {
        let dict = snapshot.value as! NSDictionary
        userUrl = dict.value(forKey: "userUrl") as? String
        timestamp = dict.value(forKey: "timestamp") as? Int
        comment = dict.value(forKey: "comment") as? String
     }
}
