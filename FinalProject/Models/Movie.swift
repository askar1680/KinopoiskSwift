//
//  Movie.swift
//  FinalProject
//
//  Created by Аскар on 12.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import TMDBSwift
import Firebase

struct Movie{
    var Id: Int
    var name: String?
    var release_date: String?
    var genres: [Genre]?
    var imageUrl: String?
    var rating: Double?
    var postImageUrl: String?
    
    
    init(data: PersonResults) {
        Id = data.id
        name = data.name
        postImageUrl = data.profile_path
    }
    
    init(data: TVMDB) {
        Id = data.id
        name = data.name
        release_date = data.first_air_date
        genres = []
        for genre in data.genres{
            if let name = genre.name, let id = genre.id{
                genres?.append(Genre.init(id: id, name: name))
            }
        }
        if let imageUrl = data.backdrop_path{
            self.imageUrl = imageUrl
        }
        if let rating = data.vote_average{
            self.rating = rating
        }
        if let postImageUrl = data.poster_path{
            self.postImageUrl = postImageUrl
        }
    }
    
    init(data: MovieMDB){
        Id = data.id
        if let title = data.title{
            name = title
        }
        if let release_date = data.release_date{
            self.release_date = release_date
        }
        genres = []
        for genre in data.genres{
            if let name = genre.name, let id = genre.id{
                genres?.append(Genre.init(id: id, name: name))
            }
        }
        
        //data.
        
        if let imageUrl = data.backdrop_path{
            self.imageUrl = imageUrl
        }
        if let rating = data.vote_average{
            self.rating = rating
        }
        if let postImageUrl = data.poster_path{
            self.postImageUrl = postImageUrl
        }
    }
    func getReleaseYear() -> String{
        if let year = release_date{
        
            let index = year.index(year.startIndex, offsetBy: 4)
            return String(year[..<index])
        }
        return "2015"
    }
    func getRating() -> String {
        if let rating = rating{
            let ratingString = String.init(describing: rating)
            let index = ratingString.index(ratingString.startIndex, offsetBy: 3)
            return String(ratingString[..<index])
        }
        return ""
    }
    func getGenre() -> String{
        if let genres = genres{
            if !genres.isEmpty{
                var string = ""
                for genre in genres{
                    string += "\(genre) "
                }
                return string
            }
        }
        return ""
    }
}

struct Genre {
    var name: String?
    var id: Int?
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
