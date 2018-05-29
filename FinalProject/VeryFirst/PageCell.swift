//
//  PageCell.swift
//  FinalProject
//
//  Created by Аскар on 06.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//


import UIKit

class PageCell: UICollectionViewCell{
    
    var page: Page?{
        didSet{
            guard let unwrappedPage = page else {return}
            backgroundImageView.image = UIImage.init(named: unwrappedPage.imageName!)
            
            let attributedText = NSMutableAttributedString(string: unwrappedPage.title!, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 22), NSAttributedStringKey.foregroundColor: UIColor.white])
            attributedText.append(NSAttributedString(string: "\n\n\(unwrappedPage.subtitle!)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.white]))
            
            tvDescription.backgroundColor = .clear
            tvDescription.attributedText = attributedText
            tvDescription.textAlignment = .center
            
        }
    }
    
    
    let tvDescription: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textAlignment = .center
        tv.isEditable = false
        tv.textColor = .white
        tv.isScrollEnabled = false
        return tv
    }()
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    let blackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.6)
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.init(named: "start22")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout(){
        addSubview(backgroundImageView)
        addSubview(blackView)
        addSubview(tvDescription)
        addSubview(imageView)
        
        blackView.anchorFullSize(to: self)
        backgroundImageView.anchorFullSize(to: self)
        
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -50).isActive = true
        let width = self.frame.width
        imageView.widthAnchor.constraint(equalToConstant: width/4).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: width/4).isActive = true
        
        tvDescription.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        tvDescription.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40).isActive = true
        tvDescription.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        tvDescription.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    }
}
