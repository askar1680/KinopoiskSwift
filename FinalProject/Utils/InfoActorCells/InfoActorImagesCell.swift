//
//  InfoActorImagesCell.swift
//  FinalProject
//
//  Created by Аскар on 14.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit

protocol InfoActorImagesDelegate {
    func setImage(indexPath: IndexPath)
}



class InfoActorImagesTVCell: UITableViewCell {
    
    var infoActorImagesDelegate: InfoActorImagesDelegate?
    
    let imageKey = "https://image.tmdb.org/t/p/w500"
    var tempImages = [String]()
    var images: [String]? {
        didSet{
            if let images = images{
                tempImages = images
                imagesCollectionView.reloadData()
            }
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Colors.mainColor
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self
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
        label.text = "Фото"
        return label
    }()
    
    let imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCVCell.self, forCellWithReuseIdentifier: "InfoActorImagesCVCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    func setupConstraints(){
        addSubview(actorsFromFilmLabel)
        addSubview(imagesCollectionView)
        
        actorsFromFilmLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets.init(top: 8, left: 8, bottom: 0, right: 0))
        imagesCollectionView.anchor(top: actorsFromFilmLabel.bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8), size: CGSize.init(width: 0, height: 0))
    }
    
}

extension InfoActorImagesTVCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoActorImagesCVCell", for: indexPath) as! MovieCVCell
        cell.imageView.loadImageUsingKingfisherWithUrlString(urlString: imageKey + "\(tempImages[indexPath.row])")
        cell.nameLabel.isHidden = true
        cell.ratingLabel.isHidden = true
        cell.starsRatingView.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 120
        let height = 180
        return CGSize.init(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        infoActorImagesDelegate?.setImage(indexPath: indexPath)
    }
    
    
}

