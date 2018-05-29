//
//  InfoMovieTagsCell.swift
//  FinalProject
//
//  Created by Аскар on 23.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import TMDBSwift
import UICollectionViewLeftAlignedLayout

protocol KeywordWasClickedDelegate {
    func setKeyword(id: Int, name: String)
}

extension InfoMovieTagsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeywordsCollectionViewCell", for: indexPath) as! GenreCollectionViewCell
        cell.genreLabel.font = UIFont.boldSystemFont(ofSize: 11)
        cell.genreLabel.text = keywords[indexPath.row].name!
        cell.genreBackgroundView.layer.cornerRadius = 12.5
        
        cell.genreBackgroundView.backgroundColor = Colors.darkBlueColor
        cell.genreLabel.textColor = .white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = estimateFrameForText(text: keywords[indexPath.row].name!, font: UIFont.boldSystemFont(ofSize: 11)).width
        return CGSize.init(width: width + 14, height: 25)
    }
    
    func estimateFrameForText(text: String, font: UIFont) -> CGRect{
        let size = CGSize.init(width: 300, height: 25)
        let options = NSStringDrawingOptions.usesLineFragmentOrigin.union(.usesFontLeading)
        return NSString.init(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: font], context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == keywordsCollectionView{
            if let id = keywords[indexPath.row].id, let name = keywords[indexPath.row].name{
                keywordDelegate?.setKeyword(id: id, name: name)
            }
        }
    }
    
}

class InfoMovieTagsCell: UITableViewCell {
    var keywordDelegate: KeywordWasClickedDelegate?
    var keywords = [Genre]()
    
    var id: Int?{
        didSet{
            if let movieId = id{
                MovieMDB.keywords(movieID: movieId, language: "ru") { (_, data) in
                    if let data = data{
                        self.keywords = []
                        for item in data{
                            if let id = item.id, let name = item.name{
                                let keyword = Genre.init(id: id, name: name)
                                self.keywords.append(keyword)
                                DispatchQueue.main.async {
                                    self.keywordsCollectionView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        keywordsCollectionView.delegate = self
        keywordsCollectionView.dataSource = self
        self.backgroundColor = Colors.mainColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let tagsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Тэги"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let keywordsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: "KeywordsCollectionViewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = Colors.mainColor
        return collectionView
    }()
    
    func setupConstraints(){
        addSubview(tagsLabel)
        addSubview(keywordsCollectionView)
        
        tagsLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets.init(top: 8, left: 8, bottom: 0, right: 0))
        keywordsCollectionView.anchor(top: tagsLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets.init(top: 8, left: 0, bottom: 0, right: 0), size: CGSize.init(width: 0, height: 25))
    }
}


