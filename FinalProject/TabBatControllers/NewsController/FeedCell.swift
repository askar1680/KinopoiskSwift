//
//  FeedCell.swift
//  FinalProject
//
//  Created by Аскар on 07.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import Firebase

class UILabelWithIndexPath: UILabel {
    var indexPath: IndexPath?
}

class UIImageViewWithIndexPath: UIImageView {
    var indexPath: IndexPath?
}

protocol MoreButtonPressedDelegate{
    func morePressed(feed: Feed?)
}

class FeedCell: UICollectionViewCell {
    var moreButtonDelegate: MoreButtonPressedDelegate?
    
    var feed: Feed? {
        didSet{
            if let feed = feed{
                if let topic = feed.topic, let author = feed.authorName, let authorImage = feed.authorImageView, let timestamp = feed.timestamp{
                    topicLabel.text = topic
                    if let comments = feed.comments{
                        amountCommentsLabel.text = "\(String(describing: comments.count))"
                    }
                    if let likes = feed.likedUsers{
                        amountLikesLabel.text = "\(String(describing: likes.count))"
                    }
                    authorName.text = author
                    authorImageView.loadImageUsingKingfisherWithUrlString(urlString: authorImage)
                    imageView.loadImageUsingKingfisherWithUrlString(urlString: feed.imageViews![0])
                    timeLabel.text = timestamp
                    if let snapshotKey = feed.snapshotKey{
                        let ref = Database.database().reference().child("news").child(snapshotKey).child("likedUsers")
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
    }
    
    @objc func likePressed(){
        print(123)
        if let feed = feed{
            let snapshotKey = feed.snapshotKey
            if let snapshotKey = snapshotKey{
                let ref = Database.database().reference().child("news").child(snapshotKey)
                let currentUserUid = Auth.auth().currentUser?.uid
                if let id = currentUserUid{
                    if likesImageView.image == UIImage.init(named: "like_white"){
                        ref.child("likedUsers").updateChildValues([id: 1] as [String: AnyObject])
                        UIView.transition(with: self.likesImageView, duration: 0.2, options: .curveEaseInOut, animations: {
                            self.likesImageView.transform = CGAffineTransform.init(scaleX: 0.7, y: 0.7)
                        }) { (isCompleted) in
                            if isCompleted{
                                print(123)
                                self.likesImageView.image = UIImage.init(named: "like_red")
                                UIView.animate(withDuration: 0.2, animations: {
                                    self.likesImageView.transform = CGAffineTransform.identity
                                }, completion: { (_) in
                                    
                                })
                            }
                        }
                        
                    }
                    else{
                        ref.child("likedUsers").child(id).removeValue()
                        likesImageView.image = UIImage.init(named: "like_white")
                    }
                }
            }
            
        }
    }
    
    /*func getLikes(snapshotKey: String) -> [String]{
        var result = [String]()
        let ref = Database.database().reference().child("news").child(snapshotKey).child("likedUsers")
        ref.observeSingleEvent(of: .value, with: { (snapshots) in
            for snapshotAny in snapshots.children{
                let snapshot = snapshotAny as! DataSnapshot
                result.append(snapshot.key)
            }
        }, withCancel: nil)
        
        return result
    }*/
    
    @objc func handleMore(){
        moreButtonDelegate?.morePressed(feed: feed)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // VIEWS
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.init(named: "movie1")
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleMore)))
        return imageView
    }()
    
    lazy var authorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.image = UIImage.init(named: "profile1")
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleMore))
        imageView.addGestureRecognizer(tap)
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
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = "Вчера, в 18:28"
        return label
    }()
    
    lazy var moreButton: ButtonWithIndexPath = {
        let button = ButtonWithIndexPath()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Подробнее", for: .normal)
        button.addTarget(self, action: #selector(handleMore), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.setTitleColor(Colors.blueColor, for: .normal)
        return button
    }()
    
    let topicLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "sdnfjndsjfkdfnjasdnfjdnfjnjsdnfjsscscxcx mcnxzcnxzknckxznckxnckxznckzx"
        label.textColor = .white
        label.numberOfLines = 5
        return label
    }()
    
    let commentsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.init(named: "comment")
        return imageView
    }()
    
    let amountCommentsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "16"
        
        label.textColor = .white
        return label
    }()
    
    lazy var likesImageView: UIImageViewWithIndexPath = {
        let imageView = UIImageViewWithIndexPath()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.init(named: "like_white")
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(likePressed))
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
    
    // SETUP Constraints
    func setupConstraints(){
        let gradientView = GradientView()
        
        addSubview(imageView)
        addSubview(gradientView)
        
        addSubview(authorImageView)
        addSubview(authorName)
        addSubview(timeLabel)
        addSubview(moreButton)
        addSubview(topicLabel)
        addSubview(amountLikesLabel)
        addSubview(amountCommentsLabel)
        addSubview(commentsImageView)
        addSubview(likesImageView)
       
        
        let width = UIScreen.main.bounds.width
        let height = 9*width/16
        
        imageView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, size: CGSize.init(width: width, height: height))
        gradientView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, size: CGSize.init(width: width, height: height))
        
        authorImageView.anchor(top: nil, leading: self.leadingAnchor, bottom: imageView.bottomAnchor, trailing: nil, padding: UIEdgeInsets.init(top: 0, left: 12, bottom: 8, right: 0), size: CGSize.init(width: 40, height: 40))
        
        authorName.bottomAnchor.constraint(equalTo: authorImageView.centerYAnchor, constant: 0).isActive = true
        authorName.leadingAnchor.constraint(equalTo: authorImageView.trailingAnchor, constant: 8).isActive = true
        
        timeLabel.topAnchor.constraint(equalTo: authorImageView.centerYAnchor, constant: 2).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: authorImageView.trailingAnchor, constant: 8).isActive = true
        
        moreButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        moreButton.centerYAnchor.constraint(equalTo: authorImageView.centerYAnchor).isActive = true
        
        topicLabel.anchor(top: imageView.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets.init(top: 8, left: 8, bottom: 0, right: 8))
        
        amountLikesLabel.anchor(top: topicLabel.bottomAnchor, leading: nil, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets.init(top: 8, left: 0, bottom: 0, right: 8))
        
        likesImageView.centerYAnchor.constraint(equalTo: amountLikesLabel.centerYAnchor).isActive = true
        likesImageView.trailingAnchor.constraint(equalTo: amountLikesLabel.leadingAnchor, constant: -8).isActive = true
        likesImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        likesImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        amountCommentsLabel.centerYAnchor.constraint(equalTo: amountLikesLabel.centerYAnchor).isActive = true
        amountCommentsLabel.trailingAnchor.constraint(equalTo: likesImageView.leadingAnchor, constant: -16).isActive = true
        
        commentsImageView.centerYAnchor.constraint(equalTo: amountCommentsLabel.centerYAnchor).isActive = true
        commentsImageView.trailingAnchor.constraint(equalTo: amountCommentsLabel.leadingAnchor, constant: -8).isActive = true
        commentsImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        commentsImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        
        
        
    }
    
}
