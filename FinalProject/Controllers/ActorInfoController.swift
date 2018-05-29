//
//  ActorInfoController.swift
//  FinalProject
//
//  Created by Аскар on 14.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import TMDBSwift

extension ActorInfoController: MovieDelegate, InfoActorImagesDelegate, ShowDelegate{
    
    func setShow(indexPath: IndexPath) {
        if let id = shows[indexPath.row].id{
            let infoController = InfoAboutMovieController()
            infoController.idShow = id
            navigationController?.pushViewController(infoController, animated: true)
        }
    }
    
    func setImage(indexPath: IndexPath) {
        let imagesController = ImagesController()
        imagesController.indexPath = indexPath
        imagesController.images = images
        navigationController?.pushViewController(imagesController, animated: true)
        
    }
    
    func setMovie(indexPath: IndexPath) {
        if let id = movies[indexPath.row].id{
            let infoController = InfoAboutMovieController()
            infoController.ID = id
            navigationController?.pushViewController(infoController, animated: true)
        }
    }
    
}

class ActorInfoController: UITableViewController {
    let imageKey = "https://image.tmdb.org/t/p/w500"
    var images = [String]()
    var actor: ActorInfo?
    var movies = [Actor]()
    var shows = [Actor]()
    var ID: Int?{
        didSet{
            if let id = ID{
                setupActor(id: id)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    struct TableCell {
        static let headerCell = "HeaderCell"
        static let photosCell = "PhotosCell"
        static let biographyCell = "BiographyCell"
        static let filmsCell = "FilmsCell"
        static let showsCell = "ShowsCell"
    }
    
    func setupNavigationController(){
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.isTranslucent = true
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        
    }
    
    func setupTableView(){
        tableView.backgroundColor = Colors.mainColor
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(ActorInfoHeaderCell.self, forCellReuseIdentifier: TableCell.headerCell)
        tableView.register(InfoActorImagesTVCell.self, forCellReuseIdentifier: TableCell.photosCell)
        tableView.register(TextTVCell.self, forCellReuseIdentifier: TableCell.biographyCell)
        tableView.register(InfoMovieActorsTVCell.self, forCellReuseIdentifier: TableCell.filmsCell)
        tableView.register(InfoMovieActorsTVCell.self, forCellReuseIdentifier: TableCell.showsCell)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        
    }
    
}

extension ActorInfoController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.headerCell) as! ActorInfoHeaderCell
            cell.selectionStyle = .none
            if let actor = actor{
                cell.actorImageView.loadImageUsingKingfisherWithUrlString(urlString: actor.getProfileImageUrl())
                cell.nameLabel.text = actor.name
                cell.infoLabel.text = actor.getInfo()
            }
            
            cell.backgroundImageView.image = UIImage.init(named: "actor_info_background")
            
            return cell
        }
        else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.photosCell) as! InfoActorImagesTVCell
            cell.selectionStyle = .none
            cell.images = images
            cell.infoActorImagesDelegate = self
            return cell
        }
        else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.biographyCell) as! TextTVCell
            cell.selectionStyle = .none
            cell.newsTopic = "Биография"
            if let actor = actor{
                if let biography = actor.biography{
                    cell.newsText = biography
                }
            }
            return cell
        }
        else if indexPath.row == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.filmsCell) as! InfoMovieActorsTVCell
            cell.selectionStyle = .none
            cell.actors = movies
            if movies.count > 0{
                cell.actorsFromFilmLabel.text = "Фильмография"
            }
            else {
                cell.actorsFromFilmLabel.text = ""
            }
            cell.movieDelegate = self
            return cell
        }
        else if indexPath.row == 4{
            let cell =  tableView.dequeueReusableCell(withIdentifier: TableCell.showsCell) as! InfoMovieActorsTVCell
            cell.selectionStyle = .none
            cell.actors = shows
            if shows.count > 0{
                cell.actorsFromFilmLabel.text = "ТВ Шоу"
            } else{
                cell.actorsFromFilmLabel.text = ""
            }
            cell.showsDelegate = self
            return cell
        }
        
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "myCell")
        cell.selectionStyle = .none
        cell.textLabel?.text = "blabla"
        cell.detailTextLabel?.text = "blabla"
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            let width = view.frame.width
            let height = 9*width/16
            return height
        }
        else if indexPath.row == 1{
            return 210
        }
        else if indexPath.row == 2{
            if let actor = actor{
                if let biography = actor.biography{
                    let height = estimateFrameForText(text: biography).height
                    if biography.isEmpty{
                        return 0
                    }
                    return height + 30
                }
            }
        }
        else if indexPath.row == 3{
            if movies.count == 0{
                return 0
            }
            return 280
        }
        else if indexPath.row == 4{
            if shows.count == 0{
                return 50
            }
            return 340
        }
        
        return 10
    }
    
    func estimateFrameForText(text: String) -> CGRect{
        let size = CGSize.init(width: view.frame.width-16, height: 1000)
        let options = NSStringDrawingOptions.usesLineFragmentOrigin.union(.usesFontLeading)
        return NSString.init(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)], context: nil)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = 9*view.frame.width/16 - 4*view.frame.width/16
        var offSet = scrollView.contentOffset.y / height
        if offSet > 1{
            offSet = 1
            let color = UIColor.init(red: 21/255, green: 27/255, blue: 36/255, alpha: offSet)
            self.navigationController?.navigationBar.backgroundColor = color
            UIApplication.shared.statusBarView?.backgroundColor = color
        }
        else{
            let color = UIColor.init(red: 21/255, green: 27/255, blue: 36/255, alpha: offSet)
            self.navigationController?.navigationBar.backgroundColor = color
            UIApplication.shared.statusBarView?.backgroundColor = color
        }
    }
    
    func setupActor(id: Int){
        PersonMDB.person_id(personID: id, language: "ru") { (_, data) in
            if let data = data{
                self.actor = ActorInfo.init(data: data)
                self.tableView.reloadData()
                
            }
        }
        PersonMDB.images(personID: id) { (_, data) in
            if let data = data{
                for item in data{
                    if let imageUrl = item.file_path{
                        self.images.append(imageUrl)
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        PersonMDB.movie_credits(personID: id, language: "ru") { (_, data) in
            if let data = data{
                for item in data.cast{
                    let movie = Actor.init(data: item)
                    self.movies.append(movie)
                    self.tableView.reloadData()
                }
            }
        }
        PersonMDB.tv_credits(personID: id, language: "ru") { (_, data) in
            if let data = data{
                for item in data.cast{
                    let show = Actor.init(data: item)
                    self.shows.append(show)
                    self.tableView.reloadData()
                }
            }
        }
        
        
    }
    
}



