//
//  MovieInfo.swift
//  FinalProject
//
//  Created by Аскар on 13.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import TMDBSwift

struct MovieInfo{
    var Id: Int?
    var name: String?
    var release_date: String?
    var genres: [Genre]?
    var duration: Int?
    var rating: Double?
    var overview: String?
    var tag: String?
    var countries: [String]?
    var originalName: String?
    var numberOfSeasons: Int?
    var numberOfSeries: Int?
    var createdBy: String?
    
    init(data: TVDetailedMDB) {
        Id = data.id
        name = data.name
        if let date = data.first_air_date{
            release_date = date
        }
        self.genres = []
        for item in data.genres{
            if let name = item.name, let id = item.id{
                self.genres?.append(Genre.init(id: id, name: name))
            }
        }
        
        duration = data.episode_run_time[0]
        if let rating = data.vote_average{
            self.rating = rating
        }
        overview = data.overview
        countries = []
        if let dataCountries = data.origin_country{
            countries = dataCountries
        }
        originalName = data.original_name
        numberOfSeasons = data.number_of_seasons
        numberOfSeries = data.number_of_episodes
        createdBy = data.createdBy?.name
    }
    
    init(data: MovieDetailedMDB) {
        Id = data.id
        if let title = data.title{
            self.name = title
        }
        if let release_date = data.release_date{
            self.release_date = release_date
        }
        
        self.genres = []
        for item in data.genres{
            if let name = item.name, let id = item.id{
                self.genres?.append(Genre.init(id: id, name: name))
            }
        }
        
        //for item in data.
        
        
        
        if let duration = data.runtime{
            self.duration = duration
        }
        if let rating = data.vote_average{
            self.rating = rating
        }
        if let overview = data.overview{
            self.overview = overview
        }
        tag = data.tagline
        countries = []
        if let countries = data.production_countries{
            for country in countries{
                if let name = country.name{
                    self.countries?.append(name)
                }
            }
        }
        
        if let original_name = data.original_title{
            originalName = original_name
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
        return "7.9"
    }
    
    func getDuration() -> String{
        if let duration = duration{
            let hours = duration / 60
            let minutes = duration % 60
            if hours == 0{
                return ""
            }
            else if hours == 1{
                return "\(hours) час \(minutes) мин"
            }
            else if hours > 1{
                return "\(hours) часа \(minutes) мин"
            }
        }
        return "2 часа 12 мин"
    }
    func getCountries() -> String{
        if let countries = countries{
            if !countries.isEmpty{
                var string = ""
                for country in countries{
                    string += "\(country) "
                }
                return string
            }
        }
        return ""
    }
}
