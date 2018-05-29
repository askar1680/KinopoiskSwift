//
//  ImagesCell.swift
//  FinalProject
//
//  Created by Аскар on 12.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit



class ImageCVCell: UICollectionViewCell {
    
    let imageKey = "https://image.tmdb.org/t/p/w500"
    
    var movieInfoImageUrl: String?{
        didSet{
            //print(movieInfoImageUrl)
            if let imageUrl = movieInfoImageUrl{
                print(imageKey+"\(String(describing: imageUrl))")
                imageView.loadImageUsingKingfisherWithUrlString(urlString: imageKey+"\(String(describing: imageUrl))")
            }
        }
    }
    var newsImageUrl: String?{
        didSet{
            darkView.isHidden = false
            gradientView.isHidden = false
            imageView.loadImageUsingKingfisherWithUrlString(urlString: newsImageUrl!)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.init(named: "no_poster")
        return imageView
    }()
    
    let darkView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
        return view
    }()
    
    let gradientView: GradientView = {
        let gradientView = GradientView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        return gradientView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupConstraints(){
        addSubview(imageView)
        addSubview(darkView)
        addSubview(gradientView)
        
        imageView.anchorFullSize(to: self)
        darkView.anchorFullSize(to: self)
        gradientView.anchorFullSize(to: self)
        
    }
}



/*

*/


