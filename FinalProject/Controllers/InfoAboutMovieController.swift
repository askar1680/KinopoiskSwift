//
//  InfoAboutMovieController.swift
//  FinalProject
//
//  Created by Аскар on 12.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import TMDBSwift
import Firebase
import UICollectionViewLeftAlignedLayout

extension InfoAboutMovieController: MovieWasClickedDelegate, ActorWasClickedDelegate, LeaveCommentToMovieDelegate, InfoMovieHeaderGenreDelegate, KeywordWasClickedDelegate{
    func setKeyword(id: Int, name: String) {
        let layout = UICollectionViewLeftAlignedLayout()
        layout.scrollDirection = .vertical
        let genreController = GenreMovieController.init(collectionViewLayout: layout)
        genreController.keywordId = id
        genreController.titleForToolbar = name
        navigationController?.pushViewController(genreController, animated: true)
    }
    
    func setGenre(id: Int, name: String) {
        let layout = UICollectionViewLeftAlignedLayout()
        layout.scrollDirection = .vertical
        let genreController = GenreMovieController.init(collectionViewLayout: layout)
        genreController.genreFilms = id
        genreController.titleForToolbar = name
        navigationController?.pushViewController(genreController, animated: true)
    }
    
    
    func leaveComment(comment: String) {
        var commentRef: DatabaseReference!
        if let id = ID{
            commentRef = Database.database().reference().child("movies").child("\(id)").child("comments").childByAutoId()
        }
        else if let id = idShow {
            commentRef = Database.database().reference().child("shows").child("\(id)").child("comments").childByAutoId()
        }
        let currentUserId = Auth.auth().currentUser?.uid
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let myComment = Comment.init(userUrl: currentUserId!, timestamp: timestamp, comment: comment)
        let commentValues = myComment.toJSONFormat()
        commentRef.setValue(commentValues)
        self.comments.append(myComment)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        
    }
    
    func setActor(indexPath: IndexPath) {
        let actorController = ActorInfoController()
        actorController.ID = actors[indexPath.row].id
        navigationController?.pushViewController(actorController, animated: true)
    }
    
    func setId(indexPath: IndexPath) {
        let infoController = InfoAboutMovieController()
        if ID == nil{
            infoController.idShow = similarFilms[indexPath.row].Id
        }
        else if idShow == nil{
            infoController.ID = similarFilms[indexPath.row].Id
        }
        navigationController?.pushViewController(infoController, animated: true)
    }
}


class InfoAboutMovieController: UITableViewController{
    let language = "ru"
    var movieInfo: MovieInfo?
    var actors = [Actor]()
    var comments = [Comment]()
    
    var ID: Int?{
        didSet{
            if let id = ID{
                setupMovie(id: id)
            }
        }
    }
    
    var idShow: Int?{
        didSet{
            if let id = idShow{
                setupShow(id: id)
            }
        }
    }
    
    var videoId: String?
    var images = [String]()
    var similarFilms = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.mainColor
        setupTableView()
        setupNavigationBar()
        setupComments()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    struct TableCell {
        static let headerCell = "HeaderCell"
        static let plotCell = "PlotCell"
        static let playerCell = "PlayerCell"
        static let actorsCell = "ActorsCell"
        static let keywordsCell = "KeywordsCell"
        static let similarFilmsCell = "SimilarFilmsCell"
        static let commentsCell = "CommentsCell"
        static let leaveCommentCell = "LeaveCommentCell"
    }
    func setupTableView(){
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(InfoMovieHeaderCell.self, forCellReuseIdentifier: TableCell.headerCell)
        tableView.register(InfoMovieActorsTVCell.self, forCellReuseIdentifier: TableCell.actorsCell)
        tableView.register(TextTVCell.self, forCellReuseIdentifier: TableCell.plotCell)
        tableView.register(TrailerCell.self, forCellReuseIdentifier: TableCell.playerCell)
        tableView.register(InfoMovieTagsCell.self, forCellReuseIdentifier: TableCell.keywordsCell)
        tableView.register(MoviesTVCell.self, forCellReuseIdentifier: TableCell.similarFilmsCell)
        tableView.register(CommentTVCell.self, forCellReuseIdentifier: TableCell.commentsCell)
        tableView.register(LeaveACommentCell.self, forCellReuseIdentifier: TableCell.leaveCommentCell)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
    }
    func setupNavigationBar(){
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.isTranslucent = true
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }
    
}


extension InfoAboutMovieController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.headerCell) as! InfoMovieHeaderCell
            cell.genreDelegate = self
            cell.selectionStyle = .none
            cell.images = images
            cell.movieInfo = movieInfo
            if let idMovie = ID{
                cell.idMovie = idMovie
            }
            if let idShow = idShow{
                cell.idShow = idShow
            }
            
            return cell
        }
        else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.actorsCell) as! InfoMovieActorsTVCell
            cell.selectionStyle = .none
        
            cell.actors = actors
            cell.actorDelegate = self
            return cell
        }
        else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.plotCell) as! TextTVCell
            cell.selectionStyle = .none
            cell.newsTopic = "О фильме"
            if let originalName = movieInfo?.originalName{
                if !originalName.isEmpty{
                    cell.originalName = originalName
                }
            }
            if let tag = movieInfo?.tag{
                if !tag.isEmpty{
                    cell.tagline = tag
                }
            }
            if let movieInfo = movieInfo{
                if !movieInfo.getCountries().isEmpty{
                    cell.countries = movieInfo.getCountries()
                }
            }
            
            if let overview = movieInfo?.overview{
                cell.newsText = overview
            }
            else {
                cell.newsText = ""
            }
            return cell
        }
        else if indexPath.row == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.playerCell) as! TrailerCell
            cell.selectionStyle = .none
            if let videoId = videoId{
                if !videoId.isEmpty{
                    cell.videoPlayer.loadVideoID(videoId)
                }
                else {
                    cell.watchTrailerLabel.text = ""
                }
            }
            return cell
        }
        else if indexPath.row == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.keywordsCell) as! InfoMovieTagsCell
            if let id = ID{
                cell.tagsLabel.isHidden = false
                cell.keywordsCollectionView.isHidden = false
                cell.id = id
                cell.keywordDelegate = self
                
            }
            else{
                cell.tagsLabel.isHidden = true
                cell.keywordsCollectionView.isHidden = true
            }
            return cell
        }
        else if indexPath.row == 5{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.similarFilmsCell) as! MoviesTVCell
            cell.selectionStyle = .none
            cell.allFilmsButton.isHidden = true
            cell.similarFilms = similarFilms
            cell.movieDelegate = self
            return cell
        }
        else if indexPath.row == 6{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.commentsCell) as! CommentTVCell
            cell.selectionStyle = .none
            cell.comments = comments
            return cell
        }
        else if indexPath.row == 7{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.leaveCommentCell) as! LeaveACommentCell
            cell.leaveCommentMovieDelegate = self
            
            return cell
        }
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "myCell")
        cell.textLabel?.text = "blablabla"
        cell.detailTextLabel?.text = "blablalba"
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            let width = view.frame.width
            let height = 9*width/16 + 30
            return height
        }
        else if indexPath.row == 1{
            return 290
        }
        else if indexPath.row == 2{
            var height: CGFloat = 0
            if let overview = movieInfo?.overview{
                if !overview.isEmpty{
                    height = estimateFrameForText(text: overview).height + 60
                }
            }
            if let tag = movieInfo?.tag{
                if !tag.isEmpty{
                    height += estimateFrameForText(text: tag).height + 10
                }
            }
            if let movieInfo = movieInfo{
                if !movieInfo.getCountries().isEmpty{
                    height += estimateFrameForText(text: movieInfo.getCountries()).height + 10
                }
            }
            return height
        }
        else if indexPath.row == 3{
            if let videoId = videoId{
                if videoId.isEmpty{
                    return 0
                }
            }
            let height = 9*(view.frame.width-16)/16 + 62
            return height
        }
        else if indexPath.row == 4{
            if ID == nil{
                return 0
            }
            return 60
        }
        else if indexPath.row == 5{
            if similarFilms.isEmpty{
                return 0
            }
            return 320
        }
        else if indexPath.row == 6{
            let heightOfImage:CGFloat = CGFloat(60 * comments.count)
            var heightOfComments: CGFloat = 0
            for comment in comments{
                heightOfComments += estimateFrameForText(text: comment.comment!).height
            }
            return heightOfComments+heightOfImage
        }
        else if indexPath.row == 7{
            return 180
        }
        return 80
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
    func setupComments(){
        if let id = ID{
            let ref = Database.database().reference().child("movies").child("\(id)").child("comments")
            ref.observe(.value, with: { (snapshots) in
                self.comments = []
                for snapshot in snapshots.children{
                    let snap = snapshot as! DataSnapshot
                    let comment = Comment.init(snapshot: snap)
                    self.comments.append(comment)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
            }, withCancel: nil)
        }
    }
    
    
    
    
    
    
    
    
    
    func setupMovie(id: Int){
        MovieMDB.images(movieID: id) { (_, data) in
            if let data = data{
                for imageMDB in data.backdrops{
                    if let path = imageMDB.file_path{
                        self.images.append(path)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
        MovieMDB.movie(movieID: ID!, language: language) { (_, data) in
            if let data = data{
                self.movieInfo = MovieInfo.init(data: data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        MovieMDB.credits(movieID: id, language: language) { (_, data) in
            if let data = data{
                for actor in data.cast{
                    if let imageUrl = actor.profile_path{
                        let actor1 = Actor.init(id: actor.id, name: actor.name, imageUrl: imageUrl)
                        self.actors.append(actor1)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
                
            }
        }
        MovieMDB.videos(movieID: id, language: language) { (_, data) in
            if let data = data{
                if !data.isEmpty{
                    self.videoId = data[0].key
                }
            }
        }
        MovieMDB.similar(movieID: id, page: 1, language: language) { (_, data) in
            if let data = data{
                for movieData in data{
                    let movie = Movie.init(data: movieData)
                    self.similarFilms.append(movie)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
            }
        }
    }
    func setupShow(id: Int){
        TVMDB.images(tvShowID: id) { (_, data) in
            if let data = data{
                for imageMDB in data.backdrops{
                    if let path = imageMDB.file_path{
                        self.images.append(path)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
        
        TVMDB.tv(tvShowID: id, language: language) { (_, data) in
            if let data = data{
                self.movieInfo = MovieInfo.init(data: data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        TVMDB.credits(tvShowID: id, language: language) { (_, data) in
            if let data = data{
                for item in data.cast{
                    if let imageUrl = item.profile_path{
                        let actor = Actor.init(id: item.id, name: item.name, imageUrl: imageUrl)
                        self.actors.append(actor)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
        TVMDB.videos(tvShowID: id, language: language) { (_, data) in
            if let data = data{
                if !data.isEmpty{
                    self.videoId = data[0].key
                }
            }
        }
        TVMDB.similar(tvShowID: id, page: 1, language: language) { (_, data) in
            if let data = data{
                for movieData in data{
                    let movie = Movie.init(data: movieData)
                    self.similarFilms.append(movie)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        
    }
}

