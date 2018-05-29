//
//  LeaveACommentCell.swift
//  FinalProject
//
//  Created by Аскар on 10.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit

protocol LeaveCommentToNewsDelegate {
    func leaveComment(comment: String)
}

protocol LeaveCommentToMovieDelegate {
    func leaveComment(comment: String)
}

class LeaveACommentCell: UITableViewCell {
    var leaveCommentDelegate: LeaveCommentToNewsDelegate?
    var leaveCommentMovieDelegate: LeaveCommentToMovieDelegate?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Colors.mainColor
        setupConstraints()
        // height = 100 + 8 + 8 + 25 + 16
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func handleSendComment(){
        if !commentTextView.text.isEmpty{
            leaveCommentDelegate?.leaveComment(comment: commentTextView.text)
            leaveCommentMovieDelegate?.leaveComment(comment: commentTextView.text)
            commentTextView.text = ""
        }
    }
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "profile1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let commentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = true
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 3
        textView.layer.masksToBounds = true
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        button.setTitle("Отправить", for: .normal)
        button.addTarget(self, action: #selector(handleSendComment), for: .touchUpInside)
        button.backgroundColor = UIColor.init(red: 19/255, green: 203/255, blue: 175/255, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    func setupConstraints(){
        addSubview(userImageView)
        addSubview(commentTextView)
        addSubview(sendButton)
        
        userImageView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets.init(top: 8, left: 8, bottom: 0, right: 0), size: CGSize.init(width: 32, height: 32))
        
        commentTextView.anchor(top: self.topAnchor, leading: userImageView.trailingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets.init(top: 8, left: 8, bottom: 0, right: 16), size: CGSize.init(width: 0, height: 80))
        
        sendButton.anchor(top: commentTextView.bottomAnchor, leading: commentTextView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets.init(top: 8, left: 0, bottom: 0, right: 0), size: CGSize.init(width: 100, height: 25))
    }
    
    
    
}
