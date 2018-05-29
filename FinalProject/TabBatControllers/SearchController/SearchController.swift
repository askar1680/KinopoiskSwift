//
//  SearchController.swift
//  FinalProject
//
//  Created by Аскар on 16.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import TMDBSwift
import AMScrollingNavbar
import UICollectionViewLeftAlignedLayout

class SearchController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    let language = "ru"
    var pageNumber = 1
    let imageKey = "https://image.tmdb.org/t/p/w500"
    var movies = [Movie]()
    var searchText = ""
    var timer: Timer?
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar.init(frame: .zero)
        let searchTextField = searchBar.value(forKey: "searchField") as? UITextField
        searchTextField?.backgroundColor = UIColor.clear
        searchTextField?.layer.borderColor = UIColor.white.cgColor
        searchTextField?.layer.borderWidth = 1
        searchTextField?.layer.cornerRadius = 5
        searchTextField?.layer.masksToBounds = true
        
        searchTextField?.textColor = UIColor.white
        searchTextField?.attributedPlaceholder = NSMutableAttributedString.init(string: "Поиск...", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        return searchBar
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewLeftAlignedLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(GenreMovieCVCell.self, forCellWithReuseIdentifier: "GenreMovieCVCell")
        collectionView.register(ButtonCVCell.self, forCellWithReuseIdentifier: "ButtonCell")
        collectionView.backgroundColor = Colors.mainColor
        
        return collectionView
    }()
    
    lazy var searchSegmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl.init(items: ["Актёры", "Фильмы", "Сериалы"])
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.tintColor = .white
        segmentControl.backgroundColor = .clear
        segmentControl.addTarget(self, action: #selector(handleSearchParameterChanged), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 1
        return segmentControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.mainColor
        setupConstraints()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.returnKeyType = .continue
        TMDBConfig.apikey = API
        setupNavigationController()
        
        //setupPopularFilms(page: 1)
        
    }
    
    func setupConstraints(){
        view.addSubview(collectionView)
        view.addSubview(searchSegmentControl)
        searchSegmentControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
        searchSegmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchSegmentControl.widthAnchor.constraint(equalToConstant: 300).isActive = true
        searchSegmentControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        collectionView.anchor(top: searchSegmentControl.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets.init(top: 8, left: 0, bottom: 0, right: 0))
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
    }
    
    func setupNavigationController(){
        self.navigationController?.navigationBar.isTranslucent = false
        //self.navigationController?.navigationBar.backgroundColor = Colors.mainColor
        self.navigationController?.navigationBar.barTintColor = Colors.mainColor
    }
}






extension SearchController {
    @objc func handleMore(){
        if searchSegmentControl.selectedSegmentIndex == 0{
            setupActors(text: searchText)
        }
        else if searchSegmentControl.selectedSegmentIndex == 1{
            setupMovies(text: searchText)
        }
        else if searchSegmentControl.selectedSegmentIndex == 2{
            setupShows(text: searchText)
        }
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        searchMovie(text: searchText)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == movies.count{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCell", for: indexPath) as! ButtonCVCell
            if movies.count % 20 > 0 || movies.count == 0 {
                cell.button.isHidden = true
            }
            else{
                cell.button.isHidden = false
            }
            cell.button.addTarget(self, action: #selector(handleMore), for: .touchUpInside)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreMovieCVCell", for: indexPath) as! GenreMovieCVCell
        let movie = movies[indexPath.row]
        if let imageUrl = movie.postImageUrl{
            if !imageUrl.isEmpty{
                cell.imageView.loadImageUsingKingfisherWithUrlString(urlString: imageKey+"\(imageUrl)")
            }
        }
        if let name = movie.name{
            cell.nameLabel.text = name
        }
        if searchSegmentControl.selectedSegmentIndex == 0{
            cell.ratingLabel.isHidden = true
            cell.starsRatingView.isHidden = true
        }
        else{
            cell.ratingLabel.isHidden = false
            cell.starsRatingView.isHidden = false
            cell.ratingLabel.text = movie.getRating()
            if let rating = movie.rating{
                cell.starsRatingView.value = CGFloat(rating/2)
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == movies.count{
            if movies.count % 20 > 0 || movies.count == 0{
                return CGSize.init(width: view.frame.width, height: 10)
            }
            return CGSize.init(width: view.frame.width, height: 70)
        }
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad{
            let width = UIScreen.main.bounds.width/4-8
            let height = 3*width/2
            if searchSegmentControl.selectedSegmentIndex == 0{
                return CGSize.init(width: width, height: height+20)
            }
            else{
                return CGSize.init(width: width, height: height+40)
            }
        }
        else{
            let width = UIScreen.main.bounds.width/2-10
            let height = 3*width/2
            if searchSegmentControl.selectedSegmentIndex == 0{
                return CGSize.init(width: width, height: height+25)
            }
            else{
                return CGSize.init(width: width, height: height+40)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if searchSegmentControl.selectedSegmentIndex == 0{
            let actorController = ActorInfoController()
            actorController.ID = movies[indexPath.row].Id
            navigationController?.pushViewController(actorController, animated: true)
        }
        else if searchSegmentControl.selectedSegmentIndex == 1{
            let movieController = InfoAboutMovieController()
            movieController.ID = movies[indexPath.row].Id
            navigationController?.pushViewController(movieController, animated: true)
        }
        else if searchSegmentControl.selectedSegmentIndex == 2{
            let movieController = InfoAboutMovieController()
            movieController.idShow = movies[indexPath.row].Id
            navigationController?.pushViewController(movieController, animated: true)
        }
    }
    func searchMovie(text: String){
        movies = []
        collectionView.reloadData()
        pageNumber = 1
        if !text.isEmpty{
            if searchSegmentControl.selectedSegmentIndex == 0{
                setupActors(text: text)
            }
            else if searchSegmentControl.selectedSegmentIndex == 1{
                setupMovies(text: text)
            }
            else if searchSegmentControl.selectedSegmentIndex == 2{
                setupShows(text: text)
            }
        }
        
    }
    
    func setupMovies(text: String){
        //movies = []
        SearchMDB.movie(query: text, language: language, page: pageNumber, includeAdult: true, year: nil, primaryReleaseYear: nil) { (_, data) in
            if let data = data{
                for movieData in data{
                    let movie = Movie.init(data: movieData)
                    self.movies.append(movie)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        pageNumber += 1
    }
    
    func setupActors(text: String){
        //movies = []
        SearchMDB.person(query: text, page: pageNumber, includeAdult: true) { (_, data) in
            if let data = data{
                for actorData in data{
                    let actor = Movie.init(data: actorData)
                    self.movies.append(actor)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        pageNumber += 1
    }
    private func attemptReloadOfData(){
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    @objc func handleReloadTable(){
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
    func setupShows(text: String){
        //movies = []
        SearchMDB.tv(query: text, page: pageNumber, language: language, first_air_date_year: nil) { (_, data) in
            if let data = data{
                for showData in data{
                    let show = Movie.init(data: showData)
                    self.movies.append(show)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        pageNumber += 1
    }
    
    
    @objc func handleSearchParameterChanged(){
        searchBar.text = ""
        movies = []
        collectionView.reloadData()
    }
}

