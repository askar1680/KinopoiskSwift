//
//  InfoMovieHeaderCell.swift
//  FinalProject
//
//  Created by Аскар on 12.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import SwiftyStarRatingView
import Firebase

protocol InfoMovieHeaderGenreDelegate {
    func setGenre(id: Int, name: String)
}

extension InfoMovieHeaderCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == genreCollectionView{
            return genres.count
        }
        else {
            return (images?.count)!
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.genreCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCollectionViewCell", for: indexPath) as! GenreCollectionViewCell
            cell.genreLabel.text = genres[indexPath.row].name
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCVCell", for: indexPath) as! ImageCVCell
            cell.movieInfoImageUrl = images![indexPath.row]
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.genreCollectionView{
            let width = estimateFrameForText(text: genres[indexPath.row].name!, font: UIFont.systemFont(ofSize: 10)).width + 16
            return CGSize.init(width: floor(width), height: 16)
        }
        else{
            return imagesCollectionView.frame.size
        }
    }
    func estimateFrameForText(text: String, font: UIFont) -> CGRect{
        let size = CGSize.init(width: 200, height: 20)
        let options = NSStringDrawingOptions.usesLineFragmentOrigin.union(.usesFontLeading)
        return NSString.init(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: font], context: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == genreCollectionView{
            return 5
        }
        else {
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == genreCollectionView{
            if let genreId = genres[indexPath.row].id, let genreName = genres[indexPath.row].name{
                genreDelegate?.setGenre(id: genreId, name: genreName)
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / self.frame.width)
    }
    
    
}

class InfoMovieHeaderCell: UITableViewCell {
    var genreDelegate: InfoMovieHeaderGenreDelegate?
    var genres = [Genre]()
    var idMovie: Int?{
        didSet{
            setupLikes()
        }
    }
    var idShow: Int?{
        didSet{
            setupLikes()
        }
    }
    
    var movieInfo: MovieInfo?{
        didSet{
            if let movieInfo = movieInfo{
                if let g = movieInfo.genres{
                    genres = g
                    genreCollectionView.reloadData()
                }
                nameLabel.text = movieInfo.name
                releaseLabel.text = movieInfo.getReleaseYear()
                if !movieInfo.getDuration().isEmpty{
                    timeLabel.text = movieInfo.getDuration()
                }
                else{
                    timeLabel.text = ""
                    clockImageView.isHidden = true
                }
                ratingLabel.text = movieInfo.getRating()
                starRatingView.value = CGFloat(movieInfo.rating! / 2)
                
            }
        }
    }
    
    var images: [String]?{
        didSet{
            if var images = images{
                if images.count > 10{
                    while images.count != 10{
                        images.removeLast()
                    }
                }
                pageControl.numberOfPages = images.count
                imagesCollectionView.reloadData()
            }
        }
    }
    
    @objc func handleLike(){
        print("like")
        updateLikes()
    }
    
    func setupLikes(){
        var movieRef = Database.database().reference()
        if let idMovie = idMovie{
            movieRef = movieRef.child("movies").child(String(idMovie)).child("likedUsers")
        }
        else if let idShow = idShow{
            movieRef = movieRef.child("shows").child(String(idShow)).child("likedUsers")
        }
        let currentUserUid = Auth.auth().currentUser?.uid
        var counter = 0
        movieRef.observeSingleEvent(of: .value) { (snapshot) in
            for _ in snapshot.children{
                counter += 1
            }
            self.likesLabel.text = String(counter)
            if let id = currentUserUid{
                if snapshot.hasChild(id){
                    self.likesImageView.image = UIImage.init(named: "like_red")
                }
                else{
                    self.likesImageView.image = UIImage.init(named: "like_white")
                }
            }
        }
    }
    
    func updateLikes(){
        var movieRef = Database.database().reference()
        var isMovie: Bool!
        if let idMovie = idMovie{
            isMovie = true
            movieRef = movieRef.child("movies").child(String(idMovie)).child("likedUsers")
        }
        else if let idShow = idShow{
            isMovie = false
            movieRef = movieRef.child("shows").child(String(idShow)).child("likedUsers")
        }
        let currentUserUid = Auth.auth().currentUser?.uid
        movieRef.observeSingleEvent(of: .value) { (snapshot) in
            if let id = currentUserUid{
                let userRef = Database.database().reference().child("users").child(id)
                if snapshot.hasChild(id){
                    if isMovie{
                        if let movieId = self.idMovie{
                            userRef.child("movies").child(String(movieId)).removeValue()
                            movieRef.child(id).removeValue()
                        }
                    } else {
                        if let showId = self.idShow{
                            userRef.child("shows").child(String(showId)).removeValue()
                            movieRef.child(id).removeValue()
                        }
                    }
                    self.likesImageView.image = UIImage.init(named: "like_white")
                    if let amount = Int(self.likesLabel.text!){
                        self.likesLabel.text = String(amount - 1)
                    }
                }
                else{
                    if isMovie{
                        if let movieId = self.idMovie{
                            userRef.child("movies").updateChildValues([String(movieId): 1] as [String: AnyObject])
                            movieRef.updateChildValues([String(id): 1] as [String: AnyObject])
                        }
                    } else {
                        if let showId = self.idShow{
                            userRef.child("shows").updateChildValues([String(showId): 1] as [String: AnyObject])
                            movieRef.updateChildValues([String(id): 1] as [String: AnyObject])
                        }
                    }
                    self.likesImageView.image = UIImage.init(named: "like_red")
                    if let amount = Int(self.likesLabel.text!){
                        self.likesLabel.text = String(amount + 1)
                    }
                }
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Colors.mainColor
        setupConstraints()
        
        genreCollectionView.delegate = self
        genreCollectionView.dataSource = self
        genreCollectionView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.isPagingEnabled = true
        imagesCollectionView.isUserInteractionEnabled = true
        imagesCollectionView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let genreCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: "GenreCollectionViewCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    let imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.register(ImageCVCell.self, forCellWithReuseIdentifier: "ImageCVCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = Colors.mainColor
        return collectionView

    }()
    
    let releaseBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 239/255, green: 206/255, blue: 74/255, alpha: 1)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    let releaseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        //label.text = "2008"
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "7.67"
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    let starRatingView: SwiftyStarRatingView = {
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
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        //label.text = "BATMAN"
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let clockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.init(named: "gold_clock")
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        //label.text = "2 часа 45 мин"
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    let likesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        //label.text = "302"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var likesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.init(named: "like_white")
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleLike))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPage = 0
        pc.numberOfPages = 4
        pc.isUserInteractionEnabled = false
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = .lightGray
        return pc
    }()
    
    func setupConstraints(){
        addSubview(imagesCollectionView)
        addSubview(likesLabel)
        addSubview(likesImageView)
        addSubview(clockImageView)
        addSubview(timeLabel)
        addSubview(nameLabel)
        addSubview(releaseBackgroundView)
        addSubview(releaseLabel)
        addSubview(ratingLabel)
        addSubview(starRatingView)
        addSubview(genreCollectionView)
        addSubview(pageControl)
        
        imagesCollectionView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets.init(top: 0, left: 0, bottom: 10, right: 0))
        likesLabel.anchor(top: nil, leading: nil, bottom: imagesCollectionView.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets.init(top: 0, left: 0, bottom: 12, right: 8))
        likesImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: likesLabel.leadingAnchor, padding: UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 8), size: CGSize.init(width: 17, height: 17))
        likesImageView.centerYAnchor.constraint(equalTo: likesLabel.centerYAnchor).isActive = true
        
        clockImageView.anchor(top: nil, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets.init(top: 0, left: 12, bottom: 0, right: 0), size: CGSize.init(width: 15, height: 15))
        clockImageView.centerYAnchor.constraint(equalTo: likesLabel.centerYAnchor).isActive = true
        
        timeLabel.anchor(top: nil, leading: clockImageView.trailingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 0))
        timeLabel.centerYAnchor.constraint(equalTo: likesLabel.centerYAnchor).isActive = true
        
        nameLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: clockImageView.topAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets.init(top: 0, left: 8, bottom: 8, right: 8))
        
        releaseBackgroundView.anchor(top: nil, leading: self.leadingAnchor, bottom: nameLabel.topAnchor, trailing: nil, padding: UIEdgeInsets.init(top: 0, left: 8, bottom: 12, right: 0), size: CGSize.init(width: 44, height: 25))
        
        releaseLabel.centerYAnchor.constraint(equalTo: releaseBackgroundView.centerYAnchor).isActive = true
        releaseLabel.centerXAnchor.constraint(equalTo: releaseBackgroundView.centerXAnchor).isActive = true
        
        ratingLabel.centerYAnchor.constraint(equalTo: releaseBackgroundView.centerYAnchor).isActive = true
        ratingLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        
        starRatingView.centerYAnchor.constraint(equalTo: releaseBackgroundView.centerYAnchor).isActive = true
        starRatingView.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: -8).isActive = true
        starRatingView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        starRatingView.widthAnchor.constraint(equalToConstant: 84).isActive = true
        
        genreCollectionView.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 8).isActive = true
        genreCollectionView.trailingAnchor.constraint(equalTo: likesImageView.leadingAnchor, constant: -8).isActive = true
        genreCollectionView.centerYAnchor.constraint(equalTo: likesLabel.centerYAnchor).isActive = true
        genreCollectionView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 12).isActive = true
    
    }
}




class GenreCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let genreBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.backgroundColor = .clear
        view.layer.borderWidth = 0.35
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10)
        //label.text = "фантастика"
        return label
    }()
    
    
    
    
    func setupConstraints(){
        addSubview(genreBackgroundView)
        addSubview(genreLabel)
        
        genreBackgroundView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
        genreLabel.centerYAnchor.constraint(equalTo: genreBackgroundView.centerYAnchor).isActive = true
        genreLabel.centerXAnchor.constraint(equalTo: genreBackgroundView.centerXAnchor).isActive = true
        
    }
}






