//
//  AnnouncementCell.swift
//  FinalProject
//
//  Created by Аскар on 10.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit

protocol AnounceWasClickedDelegate {
    func pushIt(indexPath: IndexPath)
}

class AnouncementTVCell: UITableViewCell {
    
    let imageKey = "https://image.tmdb.org/t/p/w500"
    
    var anounceWasClickedDelegate: AnounceWasClickedDelegate?
    
    var anounceMovies: [Movie]?{
        didSet{
            if let number = anounceMovies?.count{
                pageControl.numberOfPages = number
            }
            moviesCollectionView.reloadData()
        }
    }
 
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Colors.mainColor
        setupConstraints()
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let moviesCollectionView: UICollectionView = {
        let width = UIScreen.main.bounds.width
        let height = 9*width/16
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height), collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(AnouncementCVCell.self, forCellWithReuseIdentifier: "AnouncementCVCell")
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPage = 0
        
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = .lightGray
        return pc
    }()
    
    
    func setupConstraints(){
        addSubview(moviesCollectionView)
        addSubview(pageControl)
        
        pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        pageControl.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
}


extension AnouncementTVCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (anounceMovies?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnouncementCVCell", for: indexPath) as! AnouncementCVCell
        cell.movie = anounceMovies![indexPath.row]
        if let imageUrl = anounceMovies![indexPath.row].imageUrl{
            cell.imageView.loadImageUsingKingfisherWithUrlString(urlString: imageKey+"\(imageUrl)")
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = 9*width/16
        return CGSize.init(width: width, height: height)
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / self.frame.width)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        anounceWasClickedDelegate?.pushIt(indexPath: indexPath)
    }
}


class AnouncementCVCell: UICollectionViewCell{
    var movie: Movie?{
        didSet{
            if let movie = movie{
                if let name = movie.name{
                    nameLabel.text = name
                }
                if let time = movie.release_date{
                    timeAndGenreLabel.text = time + " \(movie.getGenre())"
                }
                
            }
        }
    }
    private func estimateFrameForText(text: String, font: UIFont) -> CGRect {
        let size = CGSize.init(width: self.frame.width - 16, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString.init(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: font], context: nil)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let darkView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let timeAndGenreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    func setupConstraints(){
        addSubview(imageView)
        addSubview(darkView)
        let gradientView = GradientView.init()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(gradientView)
        addSubview(timeAndGenreLabel)
        addSubview(nameLabel)
        
        gradientView.anchorFullSize(to: self)
        imageView.anchorFullSize(to: self)
        darkView.anchorFullSize(to: self)
        nameLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: timeAndGenreLabel.topAnchor, trailing: nil, padding: UIEdgeInsets.init(top: 0, left: 12, bottom: 2, right: 0))
        timeAndGenreLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: nil, padding: UIEdgeInsets.init(top: 0, left: 12, bottom: 12, right: 0))
        
    }
}
