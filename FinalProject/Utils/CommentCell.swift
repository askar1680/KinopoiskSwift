//
//  CommentCell.swift
//  FinalProject
//
//  Created by Аскар on 09.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import Firebase




class CommentTVCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var tempComments = [Comment]()
    
    var comments:[Comment]? {
        didSet{
            if let comments = comments{
                tempComments = comments
                commentsCollectionView.reloadData()
            }
        }
    }
    
    
    var commentsCollectionView: UICollectionView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Colors.mainColor
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        commentsCollectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        commentsCollectionView.delegate = self
        commentsCollectionView.dataSource = self
        commentsCollectionView.register(CommentCVCell.self, forCellWithReuseIdentifier: "CommentCVCell")
        commentsCollectionView.backgroundColor = Colors.mainColor
        commentsCollectionView.isScrollEnabled = false
        addSubview(commentsCollectionView)
        commentsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        commentsCollectionView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}


extension CommentTVCell {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempComments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentCVCell", for: indexPath) as! CommentCVCell
        let comment = tempComments[indexPath.row]
        cell.commentTextView.text = comment.comment
        
        if let userUrl = comment.userUrl{
            let ref = Database.database().reference().child("users").child(userUrl).child("username")
            ref.observeSingleEvent(of: .value) { (snapshot) in
                let name = snapshot.value as! String
                cell.usernameLabel.text = name
            }
        }
        
        if let timestamp = comment.timestamp{
            let date = Date.init(timeIntervalSince1970: TimeInterval(timestamp))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM HH:mm:a"
            dateFormatter.timeZone = NSTimeZone.local
            let dateString = dateFormatter.string(from: date)
            cell.timeLabel.text = dateString
        
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = 56 + estimateFrameForText(text: comments![indexPath.row].comment!, font: UIFont.systemFont(ofSize: 13)).height
        return CGSize.init(width: width-32, height: height)
    }
    func estimateFrameForText(text: String, font: UIFont) -> CGRect{
        let size = CGSize.init(width: self.frame.width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString.init(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: font], context: nil)
    }
    
}



class CommentCVCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.mainColor
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let seperatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        return view
    }()
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "profile1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "blablabla"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "вчера, в 18 30"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 11)
        
        return label
    }()
    
    let commentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        /*let someText = "blablabla blablabla blablabla blablabla blablabla blablabla blablabla blablabla blablabla blablabla blablabla blablabla blablabla blablabla blablabla blablabla blablabla blablabla blablabla blablabla blablabla"
        let attributedText = NSMutableAttributedString.init(string: someText, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),NSAttributedStringKey.backgroundColor: UIColor.clear])
        attributedText.append(NSMutableAttributedString.init(string: "\n\nвчера, в 18:11", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.backgroundColor: UIColor.clear, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]))*/
        
        
        textView.textColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        //textView.attributedText = attributedText
        return textView
    }()
    
    
    func setupConstraints(){
        addSubview(seperatorLine)
        addSubview(userImageView)
        addSubview(usernameLabel)
        addSubview(timeLabel)
        addSubview(commentTextView)
        
        seperatorLine.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16), size: CGSize.init(width: 0, height: 0.2))
        userImageView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets.init(top: 8, left: 16, bottom: 0, right: 0), size: CGSize.init(width: 32, height: 32))
        
        usernameLabel.bottomAnchor.constraint(equalTo: userImageView.centerYAnchor, constant: 0).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 6).isActive = true
        
        timeLabel.topAnchor.constraint(equalTo: userImageView.centerYAnchor, constant: 0).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 6).isActive = true
        
        commentTextView.anchor(top: userImageView.bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets.init(top: 0, left: 16, bottom: 8, right: 16))
        
    }
}
