//
//  Actor.swift
//  FinalProject
//
//  Created by Аскар on 14.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import TMDBSwift

struct Actor{
    var id: Int?
    var name: String?
    var imageUrl: String?
    
    init(id: Int, name: String, imageUrl: String) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
    }
    init(data: PersonMovieCast) {
        id = data.id
        name = data.title
        imageUrl = data.poster_path
    }
    init(data: PersonTVCast) {
        id = data.id
        name = data.name
        imageUrl = data.poster_path
    }
    init(data: PersonMDB) {
        id = data.id
        name = data.name
        
        /////////////
        imageUrl = data.profile_path
        /////////////
    }
}

struct ActorInfo{
    let imageKey = "https://image.tmdb.org/t/p/w500"
    
    var id: Int?
    var name: String?
    var imageUrl: String?
    var placeOfBirth: String?
    var birthday: String?
    var biography: String?
    
    init(data: PersonMDB) {
        id = data.id
        name = data.name
        
        if let profile_path = data.profile_path{
            imageUrl = profile_path
        }
        if let place = data.place_of_birth{
            placeOfBirth = place
        }
        if let birthday = data.birthday{
            self.birthday = birthday
        }
        if let biography = data.biography{
            self.biography = biography
        }
    }
    
    func getInfo() -> String{
        if birthday == nil{
            if let place = placeOfBirth{
                return place
            }
        }
        if placeOfBirth == nil{
            if let birthday = birthday{
                let index = birthday.index(birthday.startIndex, offsetBy: 4)
                return String(birthday[..<index])
            }
        }
        if let birthday = birthday, let place = placeOfBirth{
            let index = birthday.index(birthday.startIndex, offsetBy: 4)
            return place + " \(String(birthday[..<index]))"
        }
        return ""
    }
    
    func getProfileImageUrl() -> String{
        if let imageUrl = imageUrl{
            return imageKey + "\(imageUrl)"
        }
        
        return "http://www.stickpng.com/assets/images/585e4bcdcb11b227491c3396.png"
    }
    
}


