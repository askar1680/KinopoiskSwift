//
//  TrailerCell.swift
//  FinalProject
//
//  Created by Аскар on 12.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import YouTubePlayer


class TrailerCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Colors.mainColor
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let watchTrailerBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 239/255, green: 206/255, blue: 74/255, alpha: 1)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    let watchTrailerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Смотреть трейлер"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let videoPlayer: YouTubePlayerView = {
        let player = YouTubePlayerView.init(frame: .zero)
        player.backgroundColor = Colors.mainColor
        player.tintColor = Colors.mainColor
        
        player.translatesAutoresizingMaskIntoConstraints = false
        return player
    }()
    
    func setupConstraints(){
        addSubview(watchTrailerBackgroundView)
        addSubview(watchTrailerLabel)
        addSubview(videoPlayer)
        
        watchTrailerBackgroundView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets.init(top: 8, left: 8, bottom: 0, right: 0), size: CGSize.init(width: 140, height: 30))
        
        watchTrailerLabel.centerXAnchor.constraint(equalTo: watchTrailerBackgroundView.centerXAnchor).isActive = true
        watchTrailerLabel.centerYAnchor.constraint(equalTo: watchTrailerBackgroundView.centerYAnchor).isActive = true
        
        let width = UIScreen.main.bounds.width - 16
        let height = 9*width/16
        videoPlayer.topAnchor.constraint(equalTo: watchTrailerBackgroundView.bottomAnchor, constant: 16).isActive = true
        videoPlayer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        videoPlayer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        videoPlayer.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        
        
    }
    
    
}
