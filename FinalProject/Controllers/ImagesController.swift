//
//  ImagesCell.swift
//  FinalProject
//
//  Created by Аскар on 14.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit



class ImagesController: UIViewController{
    
    let imageKey = "https://image.tmdb.org/t/p/w500"
    
    var images: [String]?{
        didSet{
            if let images = images{
                tempImages = images
                imagesCollectionView.reloadData()
            }
        }
    }
    var indexPath: IndexPath?{
        didSet{
            
        }
    }
    
    var tempImages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        imagesCollectionView.contentInsetAdjustmentBehavior = .never
        setupNavigationController()
        tabBarController?.tabBar.isHidden = true
        
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        setupConstraints()
    }
    
    func setupNavigationController(){
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.isTranslucent = true
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        
    }
    
    let imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCVCell.self, forCellWithReuseIdentifier: "ImageCVCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let indexPath = indexPath{
            imagesCollectionView.scrollToItem(at: indexPath, at: .right, animated: false)
        }
    }
    
    func setupConstraints(){
        view.addSubview(imagesCollectionView)
        
        /*let width = UIScreen.main.bounds.width
        let height = 3*width/2
 
        imagesCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imagesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imagesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imagesCollectionView.heightAnchor.constraint(equalToConstant: height).isActive = true
         */
        imagesCollectionView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        
    }
}

extension ImagesController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCVCell", for: indexPath) as! ImageCVCell
        cell.imageView.loadImageUsingKingfisherWithUrlString(urlString: imageKey + "\(tempImages[indexPath.row])")
        cell.imageView.contentMode = .scaleAspectFit
        cell.gradientView.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return imagesCollectionView.frame.size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}


