//
//  GenreMoviesController.swift
//  FinalProject
//
//  Created by Аскар on 15.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import SwiftyStarRatingView
import Firebase
import TMDBSwift



class GenreMovieController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    let imageKey = "https://image.tmdb.org/t/p/w500"
    let language = "ru"
    var pageNumber = 1
    var key = 0
    
    
    
    var allFavouriteMovies: Bool?{
        didSet{
            let currentUserId = Auth.auth().currentUser?.uid
            if let id = currentUserId{
                let ref = Database.database().reference().child("users").child(id).child("movies")
                ref.observe(.value, with: { (snapshot) in
                    self.movies = []
                    for movieId in snapshot.children{
                        let movieSnapshot = movieId as! DataSnapshot
                        let id = Int(movieSnapshot.key)
                        if let id = id{
                            MovieMDB.movie(movieID: id, language: self.language, completion: { (_, data) in
                                if let data = data{
                                    let movie = Movie.init(data: data)
                                    self.movies.append(movie)
                                    DispatchQueue.main.async {
                                        self.collectionView?.reloadData()
                                    }
                                }
                            })
                            
                        }
                    }
                }, withCancel: nil)
            }
        }
    }
    var allFavouriteShows: Bool?{
        didSet{
            let currentUserId = Auth.auth().currentUser?.uid
            if let id = currentUserId{
                let ref = Database.database().reference().child("users").child(id).child("shows")
                ref.observe(.value) { (snapshot) in
                    self.movies = []
                    for showAny in snapshot.children{
                        let showSnapshot = showAny as! DataSnapshot
                        let id = Int(showSnapshot.key)
                        if let id = id{
                            TVMDB.tv(tvShowID: id, language: self.language, completion: { (_, data) in
                                if let data = data{
                                    let show = Movie.init(data: data)
                                    self.movies.append(show)
                                    DispatchQueue.main.async {
                                        self.collectionView?.reloadData()
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    var movies = [Movie]()
    
    override func viewDidLoad() {
        view.backgroundColor = Colors.mainColor
        setupCollectionView()
        setupNavigationController()
    }
    
    func setupCollectionView(){
        collectionView?.register(GenreMovieCVCell.self, forCellWithReuseIdentifier: "GenreMovieCVCell")
        collectionView?.register(ButtonCVCell.self, forCellWithReuseIdentifier: "ButtonCVCell")
        collectionView?.backgroundColor = Colors.mainColor
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func setupNavigationController(){
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = Colors.mainColor
    }
    
    var keywordId: Int?{
        didSet{
            if let id = keywordId{
                key = 11
                setupKeyword(page: 1, keywordId: id)
            }
        }
    }
    
    var popularFilms: Int?{
        didSet{
            if let key = popularFilms{
                self.key = key
                setupPopularFilms(page: 1)
            }
        }
    }
    var topFilms: Int?{
        didSet{
            if let key = topFilms{
                self.key = key
                setupTopFilms(page: 1)
            }
        }
    }
    
    var popularShows: Int?{
        didSet{
            if let key = popularShows{
                self.key = key
                setupPopularShows(page: 1)
            }
        }
    }
    var topShows: Int?{
        didSet{
            if let key = topShows{
                self.key = key
                setupTopShows(page: 1)
            }
        }
    }
    var genreFilms: Int?{
        didSet{
            if let genreId = genreFilms{
                setupGenre(page: 1, genreId: genreId)
            }
        }
    }
    var titleForToolbar: String?{
        didSet{
            if let titleForToolbar = titleForToolbar{
                navigationItem.title = titleForToolbar
            }
        }
    }
    
    func setupPopularFilms(page: Int){
        MovieMDB.popular(language: language, page: page) { (_, data) in
            if let data = data{
                for item in data{
                    let movie = Movie.init(data: item)
                    self.movies.append(movie)
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
            }
        }
    }
    func setupTopFilms(page: Int){
        MovieMDB.toprated(language: language, page: page) { (_, data) in
            if let data = data{
                for item in data{
                    let movie = Movie.init(data: item)
                    self.movies.append(movie)
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
            }
        }
    }
    func setupPopularShows(page: Int){
        TVMDB.popular(page: page, language: language) { (_, data) in
            if let data = data{
                for item in data{
                    let show = Movie.init(data: item)
                    self.movies.append(show)
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
            }
        }
    }
    func setupTopShows(page: Int){
        TVMDB.toprated(page: page, language: language) { (_, data) in
            if let data = data{
                for item in data{
                    let show = Movie.init(data: item)
                    self.movies.append(show)
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
            }
        }
    }
    func setupGenre(page: Int, genreId: Int){
        GenresMDB.genre_movies(genreId: genreId, page: page, include_adult_movies: true, language: language) { (_, data) in
            if let data = data{
                for item in data{
                    let show = Movie.init(data: item)
                    self.movies.append(show)
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
            }
        }
    }
    
    func setupKeyword(page: Int, keywordId: Int){
        KeywordsMDB.keyword_movies(keywordId: keywordId, page: page, language: language) { (_, data) in
            if let data = data{
                for item in data{
                    let movie = Movie.init(data: item)
                    self.movies.append(movie)
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
            }
        }
    }
    
    
    
}

extension GenreMovieController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if allFavouriteShows == nil && allFavouriteMovies == nil{
            return movies.count + 1
        }
        return movies.count
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == movies.count{
            if allFavouriteShows == nil && allFavouriteMovies == nil{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCVCell", for: indexPath) as! ButtonCVCell
                cell.button.addTarget(self, action: #selector(handleMore), for: .touchUpInside)
                return cell
            }
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreMovieCVCell", for: indexPath) as! GenreMovieCVCell
        let movie = movies[indexPath.row]
        if let imageUrl = movie.postImageUrl{
            cell.imageView.loadImageUsingKingfisherWithUrlString(urlString: imageKey + "\(imageUrl)")
        }
        if let name = movie.name{
            cell.nameLabel.text = name
        }
        cell.ratingLabel.text = movie.getRating()
        if let rating = movie.rating{
            cell.starsRatingView.value = CGFloat(rating/2)
        }
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieController = InfoAboutMovieController()
        if genreFilms != nil || key == 1 || key == 2 || allFavouriteMovies != nil || key == 11{
            movieController.ID = movies[indexPath.row].Id
        }
        else{
            movieController.idShow = movies[indexPath.row].Id
        }
        
        navigationController?.pushViewController(movieController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
        if let titleForToolbar = titleForToolbar{
            navigationItem.title = titleForToolbar
        }
    }
    
    @objc func handleMore(){
        print(321)
        if let genreId = genreFilms{
            pageNumber += 1
            setupGenre(page: pageNumber, genreId: genreId)
            return
        }
        switch key {
        case 1:
            pageNumber += 1
            setupPopularFilms(page: pageNumber)
            break
        case 2:
            pageNumber += 1
            setupTopFilms(page: pageNumber)
            break
        case 3:
            pageNumber += 1
            setupPopularShows(page: pageNumber)
            break
        case 4:
            pageNumber += 1
            setupTopShows(page: pageNumber)
            break
        case 11:
            if let keywordId = keywordId{
                pageNumber += 1
                setupKeyword(page: pageNumber, keywordId: keywordId)
            }
            break
        default:
            print("error")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == movies.count{
            return CGSize.init(width: UIScreen.main.bounds.width, height: 70)
        }
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad{
            let width = UIScreen.main.bounds.width/4-8
            let height = 3*width/2
            return CGSize.init(width: width, height: height+40)
        }
        else{
            let width = UIScreen.main.bounds.width/2-10
            let height = 3*width/2
            return CGSize.init(width: width, height: height+40)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}

class ButtonCVCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let button: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("больше", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.titleLabel?.textColor = Colors.blueColor
        return  button
    }()
    
    
    func setupConstraints(){
        addSubview(button)
        
        button.anchorFullSize(to: self)
    }
}




class GenreMovieCVCell: UICollectionViewCell{
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
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Sophia Bush"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.text = "8.02"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let starsRatingView: SwiftyStarRatingView = {
        let starRating = SwiftyStarRatingView()
        starRating.translatesAutoresizingMaskIntoConstraints = false
        starRating.value = 7.67/2
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
        
        
        imageView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets.init(top: 0, left: 8, bottom: 4, right: 8))
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad{
            let width = UIScreen.main.bounds.width/4-4
            let height = 3*width/2
            imageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        else {
            let width = UIScreen.main.bounds.width/2-10
            let height = 3*width/2
            imageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        nameLabel.anchor(top: imageView.bottomAnchor, leading: imageView.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets.init(top: 4, left: 8, bottom: 0, right: 8))
        ratingLabel.anchor(top: nameLabel.bottomAnchor, leading: imageView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets.init(top: 4, left: 8, bottom: 0, right: 0))
        starsRatingView.anchor(top: nil, leading: ratingLabel.trailingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 0), size: CGSize.init(width: 44, height: 8))
        starsRatingView.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor).isActive = true
    }
}

