//
//  Feed.swift
//  FinalProject
//
//  Created by Аскар on 07.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import Firebase

struct Feed {
    var imageViews: [String]?//
    var authorImageView: String?
    var authorName: String?
    var timestamp: String?//
    var topic: String?//
    var amountOfComments: Int?//
    var amountOfLikes: Int?//
    var comments: [Comment]?//
    var text: String?//
    var likedUsers: [String]?
    var snapshotKey: String?
    
    init(snapshot: DataSnapshot) {
        
        snapshotKey = snapshot.key
        
        let feedDict = snapshot.value as! NSDictionary
        authorName = feedDict.value(forKey: "authorName") as? String
        authorImageView = feedDict.value(forKey: "authorImageView") as? String
        timestamp = feedDict.value(forKey: "timestamp") as? String
        topic = feedDict.value(forKey: "topic") as? String
        amountOfComments = feedDict.value(forKey: "amountOfComments") as? Int
        amountOfLikes = feedDict.value(forKey: "amountOfLikes") as? Int
        text = feedDict.value(forKey: "text") as? String
        
        likedUsers = []
        let snapshotOflikedUsers = snapshot.childSnapshot(forPath: "likedUsers")
        for item in snapshotOflikedUsers.children{
            let likeSnapshot = item as! DataSnapshot
            likedUsers?.append(likeSnapshot.key)
        }
        
        imageViews = []
        let imgViews = snapshot.childSnapshot(forPath: "imageViews")
        
        for imgView in imgViews.children{
            let imgViewSnapshot = imgView as! DataSnapshot
            let dictImage = imgViewSnapshot.value as! NSString
            imageViews?.append(dictImage as String)
        }
        comments = []
        let commentsSnapshots = snapshot.childSnapshot(forPath: "comments")
        for commentItem in commentsSnapshots.children{
            let commentsSnapshot = commentItem as! DataSnapshot
            let comment = Comment.init(snapshot: commentsSnapshot)
            comments?.append(comment)
        }
        
        //print(imgViews)
    }
    
    func toJSONFormat() -> Any{
        return ["authorName": authorName!, "authorImageView": authorImageView!, "timestamp": timestamp!,
                "topic": topic!, "comments": comments!, "text": text!, "amountOfLikes": amountOfLikes!, "amountOfComments": amountOfComments!, "imageViews": imageViews!, "id": 1]
    }
}
