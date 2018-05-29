//
//  ImageCell.swift
//  FinalProject
//
//  Created by Аскар on 07.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import Firebase

class NewsImageTVCell: UITableViewCell{
    
    var imageViews: [String]?{
        didSet{
            pageControl.numberOfPages = (imageViews?.count)!
            imagesCollectionView.reloadData()
        }
    }
    
    var likeCounter: Int = 0
    
    var feed: Feed?{
        didSet{
            if let feed = feed{
                if let imageUrl = feed.authorImageView{
                    authorImageView.loadImageUsingKingfisherWithUrlString(urlString: imageUrl)
                }
                authorName.text = feed.authorName!
                timeLabel.text = feed.timestamp!
                amountLikesLabel.text = String(feed.likedUsers!.count)
                let currentUserUid = Auth.auth().currentUser?.uid
                if let snapshotKey = feed.snapshotKey{
                    let ref = Database.database().reference().child("news").child(snapshotKey).child("likedUsers")
                    
                    initLikes(ref: ref, currentUserUid: currentUserUid!)
                    ref.observe(.value, with: { (snapshots) in
                        var count = 0
                        for _ in snapshots.children{
                            count += 1
                        }
                        self.amountLikesLabel.text = String(count)
                    }, withCancel: nil)
                    
                    
                }
                
            }
        }
    }
    func initLikes(ref: DatabaseReference, currentUserUid: String){
        ref.observeSingleEvent(of: .value) { (snapshots) in
            for snapshotAny in snapshots.children{
                let snapshot = snapshotAny as! DataSnapshot
                if currentUserUid == snapshot.key{
                    self.likesImageView.image = UIImage.init(named: "like_red")
                    return
                }
                else{
                    self.likesImageView.image = UIImage.init(named: "like_white")
                }
            }
        }
    }
    
    @objc func handleLike(){
        print("like")
        if let feed = feed{
            let snapshotKey = feed.snapshotKey
            if let snapshotKey = snapshotKey{
                let ref = Database.database().reference().child("news").child(snapshotKey).child("likedUsers")
                let currentUserUid = Auth.auth().currentUser?.uid
                
                ref.observeSingleEvent(of: .value) { (snapshot) in
                    if let id = currentUserUid{
                        if snapshot.hasChild(id){
                            print("already liked so dislike")
                            ref.child(id).removeValue()
                            self.likesImageView.image = UIImage.init(named: "like_white")
                            if let amount = Int(self.amountLikesLabel.text!){
                                self.amountLikesLabel.text = String(amount - 1)
                            }
                        }
                        else{
                            ref.updateChildValues([id: 1] as [String: AnyObject])
                            self.likesImageView.image = UIImage.init(named: "like_red")
                            if let amount = Int(self.amountLikesLabel.text!){
                                self.amountLikesLabel.text = String(amount + 1)
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        imagesCollectionView.isScrollEnabled = true
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.isPagingEnabled = true
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = .lightGray
        return pc
    }()
    
    let imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Colors.mainColor
        collectionView.register(ImageCVCell.self, forCellWithReuseIdentifier: "ImageCVCell")
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let authorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.image = UIImage.init(named: "profile2")
        return imageView
    }()
    
    let authorName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Jon Snow"
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "Вчера, в 18:28"
        return label
    }()
    
    lazy var likesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.init(named: "like_white")
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleLike))
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    
    
    let amountLikesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "178"
        label.textColor = .white
        return label
    }()
    
    func setupConstraints(){
        self.backgroundColor = Colors.mainColor
        addSubview(imagesCollectionView)
        addSubview(authorImageView)
        addSubview(authorName)
        addSubview(authorName)
        addSubview(timeLabel)
        addSubview(amountLikesLabel)
        addSubview(likesImageView)
        
        
        addSubview(pageControl)
        
        pageControl.topAnchor.constraint(equalTo: imagesCollectionView.bottomAnchor, constant: 0).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        let width = UIScreen.main.bounds.width
        let height = 9*width/16
        
        imagesCollectionView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, size: CGSize.init(width: width, height: height))
        
        authorImageView.anchor(top: nil, leading: self.leadingAnchor, bottom: imagesCollectionView.bottomAnchor, trailing: nil, padding: UIEdgeInsets.init(top: 0, left: 12, bottom: 8, right: 0), size: CGSize.init(width: 40, height: 40))
        
        authorName.bottomAnchor.constraint(equalTo: authorImageView.centerYAnchor, constant: 0).isActive = true
        authorName.leadingAnchor.constraint(equalTo: authorImageView.trailingAnchor, constant: 8).isActive = true
        
        timeLabel.topAnchor.constraint(equalTo: authorImageView.centerYAnchor, constant: 2).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: authorImageView.trailingAnchor, constant: 8).isActive = true
        
        amountLikesLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        amountLikesLabel.centerYAnchor.constraint(equalTo: authorImageView.centerYAnchor).isActive = true
        
        likesImageView.trailingAnchor.constraint(equalTo: amountLikesLabel.leadingAnchor, constant: -8).isActive = true
        likesImageView.centerYAnchor.constraint(equalTo: authorImageView.centerYAnchor).isActive = true
        likesImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        likesImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        
    }
}


extension NewsImageTVCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (imageViews?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCVCell", for: indexPath) as! ImageCVCell
        cell.newsImageUrl = imageViews?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.frame.width
        let height = 9*width/16
        return CGSize.init(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x/self.frame.width)
    }
    
    
}


