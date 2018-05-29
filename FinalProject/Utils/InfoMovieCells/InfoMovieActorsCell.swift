//
//  InfoMovieActorsCell.swift
//  FinalProject
//
//  Created by Аскар on 13.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import SwiftyStarRatingView

protocol ActorWasClickedDelegate {
    func setActor(indexPath: IndexPath)
}

protocol MovieDelegate {
    func setMovie(indexPath: IndexPath)
}

protocol ShowDelegate {
    func setShow(indexPath: IndexPath)
}

class InfoMovieActorsTVCell: UITableViewCell {
    
    var actorDelegate: ActorWasClickedDelegate?
    var movieDelegate: MovieDelegate?
    var showsDelegate: ShowDelegate?
    
    
    let imageKey = "https://image.tmdb.org/t/p/w500"
    var tempActors = [Actor]()
    var actors: [Actor]? {
        didSet{
            if let actors = actors{
                tempActors = actors
                actorsCollectionView.reloadData()
            }
        }
    }
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Colors.mainColor
        actorsCollectionView.dataSource = self
        actorsCollectionView.delegate = self
        setupConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let actorsFromFilmLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        //label.text = "Актеры"
        return label
    }()
    
    let actorsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCVCell.self, forCellWithReuseIdentifier: "InfoMovieActorsCVCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    
    
    func setupConstraints(){
        addSubview(actorsFromFilmLabel)
        addSubview(actorsCollectionView)
        
        actorsFromFilmLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets.init(top: 8, left: 8, bottom: 0, right: 0))
        actorsCollectionView.anchor(top: actorsFromFilmLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets.init(top: 16, left: 8, bottom: 0, right: 8), size: CGSize.init(width: 0, height: 230))
    }
    
}

extension InfoMovieActorsTVCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempActors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoMovieActorsCVCell", for: indexPath) as! MovieCVCell
        if let imageUrl = tempActors[indexPath.row].imageUrl{
            if !imageUrl.isEmpty{
                cell.imageView.loadImageUsingKingfisherWithUrlString(urlString: imageKey + "\(imageUrl)")
            }
        }
        cell.nameLabel.text = tempActors[indexPath.row].name!
        cell.ratingLabel.isHidden = true
        cell.starsRatingView.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 140
        let height = 210 + 30
        return CGSize.init(width: width, height: height)
    }
    
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        actorDelegate?.setActor(indexPath: indexPath)
        movieDelegate?.setMovie(indexPath: indexPath)
        showsDelegate?.setShow(indexPath: indexPath)
    }
    
}

