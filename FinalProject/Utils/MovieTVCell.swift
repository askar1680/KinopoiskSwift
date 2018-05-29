//
//  MovieTVCell.swift
//  FinalProject
//
//  Created by Аскар on 13.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import SwiftyStarRatingView

protocol MovieWasClickedDelegate {
    func setId(indexPath: IndexPath)
}

protocol PopularWasClickedDelegate {
    func setPopularId(indexPath: IndexPath)
    func allPopularId()
}

protocol TopWasClickedDelegate {
    func setTopId(indexPath: IndexPath)
    func allTopId()
}

protocol PopularShowWasClickedDelegate {
    func setPopularShowId(indexPath: IndexPath)
    func allPopularShowId()
}

protocol TopShowWasClickedDelegate {
    func setTopShowId(indexPath: IndexPath)
    func allTopShowId()
}

protocol MyFavouriteMovies {
    func viewAllMovies()
    func setMovie(indexPath: IndexPath)
}

protocol MyFavouriteShows {
    func viewAllShows()
    func setShow(indexPath: IndexPath)
}





class MoviesTVCell: UITableViewCell {
    let imageKey = "https://image.tmdb.org/t/p/w500"
    var movies = [Movie]()
    
    var movieDelegate: MovieWasClickedDelegate?
    var popularDelegate: PopularWasClickedDelegate?
    var topDelegate: TopWasClickedDelegate?
    var popularShowDelegate: PopularShowWasClickedDelegate?
    var topShowDelegate: TopShowWasClickedDelegate?
    var myFavouriteMovies: MyFavouriteMovies?
    var myFavouriteShows: MyFavouriteShows?
    
    
    var similarFilms: [Movie]?{
        didSet{
            if let similarFilms = similarFilms{
                movies = similarFilms
                moviesCollectionView.reloadData()
            }
        }
    }
    
    @objc func allPressed(){
        print(123)
        popularDelegate?.allPopularId()
        topDelegate?.allTopId()
        popularShowDelegate?.allPopularShowId()
        topShowDelegate?.allTopShowId()
        myFavouriteMovies?.viewAllMovies()
        myFavouriteShows?.viewAllShows()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Colors.mainColor
        setupConstraints()
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let movieLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        //label.text = "Похожие фильмы"
        return label
    }()
    
    let moviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCVCell.self, forCellWithReuseIdentifier: "MovieCVCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    lazy var allFilmsButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(allPressed), for: .touchUpInside)
        button.setTitle("ВСЕ", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.setTitleColor(Colors.blueColor, for: .normal)
        return button
    }()
    
    func setupConstraints(){
        addSubview(movieLabel)
        addSubview(moviesCollectionView)
        addSubview(allFilmsButton)
        
        movieLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets.init(top: 8, left: 8, bottom: 0, right: 0))
        moviesCollectionView.anchor(top: movieLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8), size: CGSize.init(width: 0, height: 255))
        allFilmsButton.centerYAnchor.constraint(equalTo: movieLabel.centerYAnchor).isActive = true
        allFilmsButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        allFilmsButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        allFilmsButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    
    
}

extension MoviesTVCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCVCell", for: indexPath) as! MovieCVCell
        
        let movie = movies[indexPath.row]
        if let imageUrl = movie.postImageUrl{
            cell.imageView.loadImageUsingKingfisherWithUrlString(urlString: imageKey + "\(imageUrl)")
        }
        cell.nameLabel.text = movie.name
        cell.ratingLabel.text = movie.getRating()
        if let rating = movie.rating{
            cell.starsRatingView.value = CGFloat(rating/2)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 150
        let height = 225 + 30
        return CGSize.init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        movieDelegate?.setId(indexPath: indexPath)
        popularDelegate?.setPopularId(indexPath: indexPath)
        topDelegate?.setTopId(indexPath: indexPath)
        popularShowDelegate?.setPopularShowId(indexPath: indexPath)
        topShowDelegate?.setTopShowId(indexPath: indexPath)
        myFavouriteShows?.setShow(indexPath: indexPath)
        myFavouriteMovies?.setMovie(indexPath: indexPath)
    }
    
    
}


class MovieCVCell: UICollectionViewCell{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.init(named: "no_poster")
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        //label.text = "Sophia Bush"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        //label.text = "8.02"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let starsRatingView: SwiftyStarRatingView = {
        let starRating = SwiftyStarRatingView()
        starRating.translatesAutoresizingMaskIntoConstraints = false
        //starRating.value = 7.67/2
        starRating.tintColor =  UIColor.init(red: 239/255, green: 206/255, blue: 74/255, alpha: 1)
        starRating.accurateHalfStars = true
        starRating.allowsHalfStars = true
        starRating.isUserInteractionEnabled = false
        starRating.backgroundColor = .clear
        return starRating
    }()
    
    func setupConstraints(){
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(ratingLabel)
        addSubview(starsRatingView)
        
        imageView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets.init(top: 0, left: 0, bottom: 4, right: 0), size: CGSize.init(width: 0, height: 210))
        
        nameLabel.anchor(top: imageView.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets.init(top: 8, left: 8, bottom: 0, right: 8))
        ratingLabel.anchor(top: nameLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets.init(top: 4, left: 8, bottom: 0, right: 0))
        starsRatingView.anchor(top: nil, leading: ratingLabel.trailingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 0), size: CGSize.init(width: 44, height: 8))
        starsRatingView.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor).isActive = true
    }
}



