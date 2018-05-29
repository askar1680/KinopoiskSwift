//
//  MyMoviesController.swift
//  FinalProject
//
//  Created by Аскар on 06.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import TMDBSwift
import Firebase

extension MyMoviesController: MyFavouriteMovies, MyFavouriteShows{
    func viewAllShows() {
        print("view all shows")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let genreController = GenreMovieController.init(collectionViewLayout: layout)
        genreController.allFavouriteShows = true
        navigationController?.pushViewController(genreController, animated: true)
    }
    
    func setShow(indexPath: IndexPath) {
        let movieController = InfoAboutMovieController()
        movieController.idShow = shows[indexPath.row].Id
        navigationController?.pushViewController(movieController, animated: true)
    }
    
    func viewAllMovies() {
        print("view all movies")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let genreController = GenreMovieController.init(collectionViewLayout: layout)
        genreController.allFavouriteMovies = true
        navigationController?.pushViewController(genreController, animated: true)
    }
    
    func setMovie(indexPath: IndexPath) {
        let movieController = InfoAboutMovieController()
        movieController.ID = movies[indexPath.row].Id
        navigationController?.pushViewController(movieController, animated: true)
    }
}


class MyMoviesController: UITableViewController {
    let language = "ru"
    var movies = [Movie]()
    var shows = [Movie]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAll()
        //setupNavigationBar()
        setupTableView()
        
        
    }
    
    func initAll(){
        TMDBConfig.apikey = API
        self.view.backgroundColor = Colors.mainColor
        initMovies()
        initShows()
    }
    struct TableCell {
        static let favouriteMoviesCell = "FavouriteMoviesCell"
        static let favouriteShowsCell = "FavouriteShowsCell"
    }
    func setupNavigationBar(){
        navigationItem.title = "Мои фильмы"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = Colors.mainColor
        navigationController?.navigationBar.tintColor = .white
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        tableView.reloadData()
    }
    func setupTableView(){
        tableView.separatorStyle = .none
        tableView.register(MoviesTVCell.self, forCellReuseIdentifier: TableCell.favouriteMoviesCell)
        tableView.register(MoviesTVCell.self, forCellReuseIdentifier: TableCell.favouriteShowsCell)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
    }
    func initMovies(){
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
                                    self.tableView.reloadData()
                                }
                            }
                        })
                        
                    }
                }
            }, withCancel: nil)
        }
    }
    
    func initShows(){
        let currentUserId = Auth.auth().currentUser?.uid
        if let id = currentUserId{
            let ref = Database.database().reference().child("users").child(id).child("shows")
            ref.observe(.value) { (snapshot) in
                self.shows = []
                for showAny in snapshot.children{
                    let showSnapshot = showAny as! DataSnapshot
                    let id = Int(showSnapshot.key)
                    if let id = id{
                        TVMDB.tv(tvShowID: id, language: self.language, completion: { (_, data) in
                            if let data = data{
                                let show = Movie.init(data: data)
                                self.shows.append(show)
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
  
}

extension MyMoviesController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.favouriteMoviesCell) as! MoviesTVCell
            if movies.count > 0{
                cell.movieLabel.text = "Мои фильмы"
                cell.allFilmsButton.isHidden = false
            }
            else{
                cell.movieLabel.text = ""
                cell.allFilmsButton.isHidden = true
            }
            cell.selectionStyle = .none
            cell.myFavouriteMovies = self
            cell.similarFilms = movies
            return cell
        }
        else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.favouriteShowsCell) as! MoviesTVCell
            if shows.count > 0{
                cell.movieLabel.text = "Мои сериалы"
                cell.allFilmsButton.isHidden = false
            }
            else{
                cell.movieLabel.text = ""
                cell.allFilmsButton.isHidden = true
            }
            cell.selectionStyle = .none
            cell.similarFilms = shows
            cell.myFavouriteShows = self
            return cell
        }
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "myCell")
        cell.backgroundColor = Colors.mainColor
        cell.selectionStyle = .none
        cell.textLabel?.text = "blablabla"
        cell.detailTextLabel?.text = "blablabla"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            if movies.count == 0{
                return 0
            }
            return 320
        }
        else if indexPath.row == 1{
            if shows.count == 0{
                return 0
            }
            return 320
        }
        
        return 80
    }
}



