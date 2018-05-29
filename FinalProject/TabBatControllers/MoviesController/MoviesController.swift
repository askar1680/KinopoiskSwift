//
//  MoviesController.swift
//  FinalProject
//
//  Created by Аскар on 06.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import TMDBSwift
import UICollectionViewLeftAlignedLayout

let API = "91ef52ef30eeb3da1f46bad51aeb9d1e"


extension MoviesController: AnounceWasClickedDelegate, PopularWasClickedDelegate, TopWasClickedDelegate, PopularShowWasClickedDelegate, TopShowWasClickedDelegate, GenreWasClickedDelegate{
    
    func setGenre(genreId: Int, genreName: String) {
        if genreId != 0{
            let layout = UICollectionViewLeftAlignedLayout()
            layout.scrollDirection = .vertical
            let genreController = GenreMovieController.init(collectionViewLayout: layout)
            genreController.genreFilms = genreId
            genreController.titleForToolbar = genreName
            navigationController?.pushViewController(genreController, animated: true)
        }
    }
    
    
    func allPopularId() {
        let layout = UICollectionViewLeftAlignedLayout()
        layout.scrollDirection = .vertical
        let genreController = GenreMovieController.init(collectionViewLayout: layout)
        genreController.popularFilms = 1
        genreController.titleForToolbar = "Популярные фильмы"
        navigationController?.pushViewController(genreController, animated: true)
    }
    
    func allTopId() {
        let layout = UICollectionViewLeftAlignedLayout()
        layout.scrollDirection = .vertical
        let genreController = GenreMovieController.init(collectionViewLayout: layout)
        genreController.topFilms = 2
        genreController.titleForToolbar = "Лучшие фильмы"
        navigationController?.pushViewController(genreController, animated: true)
    }
    
    func allPopularShowId() {
        let layout = UICollectionViewLeftAlignedLayout()
        layout.scrollDirection = .vertical
        let genreController = GenreMovieController.init(collectionViewLayout: layout)
        genreController.popularShows = 3
        genreController.titleForToolbar = "Популярные сериалы"
        navigationController?.pushViewController(genreController, animated: true)
    }
    
    func allTopShowId() {
        let layout = UICollectionViewLeftAlignedLayout()
        layout.scrollDirection = .vertical
        let genreController = GenreMovieController.init(collectionViewLayout: layout)
        genreController.topShows = 4
        genreController.titleForToolbar = "Лучшие сериалы"
        navigationController?.pushViewController(genreController, animated: true)
    }
    
    func setPopularShowId(indexPath: IndexPath) {
        let infoController = InfoAboutMovieController()
        infoController.idShow = popularShows[indexPath.row].Id
        navigationController?.pushViewController(infoController, animated: true)
    }
    
    func setTopShowId(indexPath: IndexPath) {
        let infoController = InfoAboutMovieController()
        infoController.idShow = topShows[indexPath.row].Id
        navigationController?.pushViewController(infoController, animated: true)
    }
    
    func setPopularId(indexPath: IndexPath) {
        let infoController = InfoAboutMovieController()
        infoController.ID = popularFilms[indexPath.row].Id
        navigationController?.pushViewController(infoController, animated: true)
    }
    
    func setTopId(indexPath: IndexPath) {
        let infoController = InfoAboutMovieController()
        infoController.ID = topFilms[indexPath.row].Id
        navigationController?.pushViewController(infoController, animated: true)
    }
    
    func pushIt(indexPath: IndexPath) {
        let infoController = InfoAboutMovieController()
        let id = anouncements[indexPath.row].Id
        infoController.ID = id
        navigationController?.pushViewController(infoController, animated: true)
    }
    
}


class MoviesController: UITableViewController {
    let language = "ru"
    var anouncements = [Movie]()
    var popularFilms = [Movie]()
    var topFilms = [Movie]()
    var popularShows = [Movie]()
    var topShows = [Movie]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.mainColor
        setupTableView()
        setupNavigationBar()
        TMDBConfig.apikey = API
        initAnouncements()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 1.5, animations: {
            self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: 21/255, green: 27/255, blue: 36/255, alpha: 0)
            UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(red: 21/255, green: 27/255, blue: 36/255, alpha: 0)
        }, completion: nil)
        print("View will appear")
    }
    struct TableCell {
        static let anouncementTVCell = "AnouncementTVCell"
        static let genresTVCell = "GenresTVCell"
        static let popularFilms = "PopularFilms"
        static let topFilms = "TopFilms"
        static let popularShows = "PopularShows"
        static let topShows = "TopShows"
    
    }
    func setupTableView(){
        tableView.register(AnouncementTVCell.self, forCellReuseIdentifier: TableCell.anouncementTVCell)
        tableView.register(GenresTVCell.self, forCellReuseIdentifier: TableCell.genresTVCell)
        tableView.register(MoviesTVCell.self, forCellReuseIdentifier: TableCell.popularFilms)
        tableView.register(MoviesTVCell.self, forCellReuseIdentifier: TableCell.topFilms)
        tableView.register(MoviesTVCell.self, forCellReuseIdentifier: TableCell.popularShows)
        tableView.register(MoviesTVCell.self, forCellReuseIdentifier: TableCell.topShows)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.backgroundColor = Colors.mainColor
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
    }
    func setupNavigationBar(){
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = Colors.mainColor
        UIApplication.shared.statusBarView?.backgroundColor = Colors.mainColor
        navigationController?.navigationBar.isTranslucent = true
    }
    
}



extension MoviesController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.anouncementTVCell) as! AnouncementTVCell
            cell.anounceMovies = anouncements
            cell.anounceWasClickedDelegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.genresTVCell) as! GenresTVCell
            cell.genreDelegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.popularFilms) as! MoviesTVCell
            cell.similarFilms = popularFilms
            cell.movieLabel.text = "Популярные фильмы"
            cell.popularDelegate = self
            cell.selectionStyle = .none
            
            return cell
        }
        else if indexPath.row == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.topFilms) as! MoviesTVCell
            cell.similarFilms = topFilms
            cell.movieLabel.text = "Лучшие фильмы"
            cell.topDelegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.popularShows) as! MoviesTVCell
            cell.similarFilms = popularShows
            cell.movieLabel.text = "Популярные сериалы и шоу"
            cell.popularShowDelegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row == 5{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.topShows) as! MoviesTVCell
            cell.similarFilms = topShows
            cell.movieLabel.text = "Лучшие сериалы и шоу"
            cell.topShowDelegate = self
            cell.selectionStyle = .none
            return cell
        }
        
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "cellId")
        cell.textLabel?.text = "blablabla"
        cell.detailTextLabel?.text = "blablabla"
        cell.backgroundColor = Colors.mainColor
        cell.selectionStyle = .none
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            let width = view.frame.width
            let height = 9*width/16
            return height + 20
        }
        else if indexPath.row == 1{
            return 55
        }
        else if indexPath.row == 2{
            return 320
        }
        else if indexPath.row == 3{
            return 320
        }
        else if indexPath.row == 4{
            return 320
        }
        else if indexPath.row == 5{
            return 370
        }
        
        return 80
    }
    
    
    func initAnouncements(){
        MovieMDB.upcoming(page: 1, language: language) { (_, data) in
            if let data = data{
                var length = data.count
                if length > 10{ length = 10 }
                for i in 0..<length{
                    let movieData = data[i]
                    
                    let movie = Movie.init(data: movieData)
                    
                    self.anouncements.append(movie)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        MovieMDB.popular(language: language, page: 1) { (_, data) in
            if let data = data{
                for item in data{
                    let movie = Movie.init(data: item)
                    self.popularFilms.append(movie)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        MovieMDB.toprated(language: language, page: 1) { (_, data) in
            if let data = data{
                for item in data{
                    let movie = Movie.init(data: item)
                    self.topFilms.append(movie)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        TVMDB.popular(page: 1, language: language) { (_, data) in
            if let data = data{
                for item in data{
                    let show = Movie.init(data: item)
                    self.popularShows.append(show)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        TVMDB.toprated(page: 1, language: language) { (_, data) in
            if let data = data{
                for item in data{
                    let show = Movie.init(data: item)
                    self.topShows.append(show)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
    }
}



