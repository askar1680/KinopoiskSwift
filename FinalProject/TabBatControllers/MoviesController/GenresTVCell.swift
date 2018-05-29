//
//  GenresTVCell.swift
//  FinalProject
//
//  Created by Аскар on 17.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import UICollectionViewLeftAlignedLayout

protocol GenreWasClickedDelegate {
    func setGenre(genreId: Int, genreName: String)
}

extension GenresTVCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCollectionViewCell", for: indexPath) as! GenreCollectionViewCell
        cell.genreLabel.font = UIFont.boldSystemFont(ofSize: 13)
        cell.genreLabel.text = genres[indexPath.row]
        cell.genreBackgroundView.layer.cornerRadius = 17
        cell.genreBackgroundView.layer.borderWidth = 0.6
        if indexPath.row == 0{
            cell.genreBackgroundView.backgroundColor = .white
            cell.genreLabel.textColor = Colors.mainColor
        }
        else{
            cell.genreBackgroundView.backgroundColor = .clear
            cell.genreLabel.textColor = .white
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = estimateFrameForText(text: genres[indexPath.row], font: UIFont.boldSystemFont(ofSize: 13)).width
        return CGSize.init(width: width + 20, height: 34)
    }
    
    func estimateFrameForText(text: String, font: UIFont) -> CGRect{
        let size = CGSize.init(width: 300, height: 34)
        let options = NSStringDrawingOptions.usesLineFragmentOrigin.union(.usesFontLeading)
        return NSString.init(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: font], context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        genreDelegate?.setGenre(genreId: genresDictionary[genres[indexPath.row]]!, genreName: genres[indexPath.row])
    }
    
    
}

/*

 {"genres":[{"id":28,"name":"Action"},{"id":12,"name":"Adventure"},{"id":16,"name":"Animation"},{"id":35,"name":"Comedy"},{"id":80,"name":"Crime"},{"id":99,"name":"Documentary"},{"id":18,"name":"Drama"},{"id":10751,"name":"Family"},{"id":14,"name":"Fantasy"},{"id":10769,"name":"Foreign"},{"id":36,"name":"History"},{"id":27,"name":"Horror"},{"id":10402,"name":"Music"},{"id":9648,"name":"Mystery"},{"id":10749,"name":"Romance"},{"id":878,"name":"Science Fiction"},{"id":10770,"name":"TV Movie"},{"id":53,"name":"Thriller"},{"id":10752,"name":"War"},{"id":37,"name":"Western"}]}
 */
class GenresTVCell: UITableViewCell {
    
    var genreDelegate: GenreWasClickedDelegate?
    let genres = ["Все фильмы", "Боевики", "Вестерны" , "Военные", "Драмы", "Документальные", "Исторические", "Комедии", "Криминальные", "Мелодрамы", "Мистика", "Мультфильмы", "Мюзиклы", "Научная фантастика", "Приключенческие", "Семейные", "Триллеры", "Ужасы", "Фантастика"]
    let genresDictionary = ["Все фильмы": 0, "Боевики": 28, "Вестерны": 37 , "Военные": 10752, "Драмы": 18, "Документальные":99, "Исторические":36, "Комедии": 35, "Криминальные": 80, "Мелодрамы": 10749, "Мистика": 9648, "Мультфильмы": 16, "Мюзиклы": 10402, "Научная фантастика": 878, "Приключенческие": 12, "Семейные": 10751, "Триллеры": 53, "Ужасы": 27, "Фантастика": 14]
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        genresCollectionView.delegate = self
        genresCollectionView.dataSource = self
        self.backgroundColor = Colors.mainColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let genresCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: "GenreCollectionViewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = Colors.mainColor
        return collectionView
    }()
    
    func setupConstraints(){
        addSubview(genresCollectionView)
        genresCollectionView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8))
    }
}




