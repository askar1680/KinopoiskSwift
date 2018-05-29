//
//  InfoActorHeaderCell.swift
//  FinalProject
//
//  Created by Аскар on 14.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit


class ActorInfoHeaderCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        //imageView.image = UIImage.init(named: "movie1")
        return imageView
    }()
    
    let blurEffect: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    let darkView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 21/255, green: 27/255, blue: 36/255, alpha: 0.4)
        return view
    }()
    
    let actorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        //imageView.image = UIImage.init(named: "actor")
        let width = UIScreen.main.bounds.width
        imageView.layer.masksToBounds = true
        return  imageView
    }()
    
    let gradientView: GradientView = {
        let gradientView = GradientView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.startPointY = 0.5
        return gradientView
    }()
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        //label.text = "Robert D."
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        //label.text = "Los Angeles, USA"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    func setupConstraints(){
        addSubview(backgroundImageView)
        addSubview(blurEffect)
        addSubview(darkView)
        addSubview(gradientView)
        addSubview(actorImageView)
        addSubview(nameLabel)
        addSubview(infoLabel)
        
        
        blurEffect.anchorFullSize(to: self)
        backgroundImageView.anchorFullSize(to: self)
        gradientView.anchorFullSize(to: self)
        darkView.anchorFullSize(to: self)
        
        let widthOfCell = UIScreen.main.bounds.width
        let heightOfCell = 9*widthOfCell/16
        
        let height = heightOfCell/2.2
        
        actorImageView.layer.cornerRadius = height/2
        
        actorImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -12).isActive = true
        actorImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        actorImageView.widthAnchor.constraint(equalToConstant: height).isActive = true
        actorImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: actorImageView.bottomAnchor, constant: 8).isActive = true
        
        infoLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        infoLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        
        
    }
    
    
    
}
