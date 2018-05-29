//
//  NewsController.swift
//  FinalProject
//
//  Created by Аскар on 06.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import Firebase

class ButtonWithIndexPath: UIButton{
    var indexPath: IndexPath?
}

extension NewsController: MoreButtonPressedDelegate{
    func morePressed(feed: Feed?) {
        if let feed = feed{
            let detailController = DetailNewsController()
            detailController.feed = feed
            navigationController?.pushViewController(detailController, animated: true)
        }
    }
    
    
    
}

class NewsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var feeds = [Feed]()
    var currentUserId: String!
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUserId = Auth.auth().currentUser?.uid
        setupNavigationBar()
        setupCollectionView()
        
    }
    
    func setupNavigationBar(){
        navigationItem.title = "Новости"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = Colors.mainColor
        self.navigationController?.navigationBar.backgroundColor = Colors.mainColor
        self.navigationController?.navigationBar.barTintColor = Colors.mainColor
        self.navigationController?.navigationBar.isTranslucent = false
        UIApplication.shared.statusBarView?.backgroundColor = Colors.mainColor
          
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupCollectionView(){
        collectionView?.backgroundColor = Colors.mainColor
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        getFeeds()
        
    }
}

extension NewsController{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feeds.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        let feed = feeds[indexPath.row]
        cell.moreButtonDelegate = self
        cell.feed = feed
        if let likedUsers = feed.likedUsers{
            if likedUsers.contains(currentUserId){
                cell.likesImageView.image = UIImage.init(named: "like_red")
            }
            else{
                cell.likesImageView.image = UIImage.init(named: "like_white")
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let heightOfTopic = estimateFrameForText(text: feeds[indexPath.row].topic!)
        let height = 9*width/16 + 8 + heightOfTopic.height + 8 + 40
        return CGSize.init(width: width, height: height)
        
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    /*
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detail = DetailNewsController()
        detail.feed = feeds[indexPath.row]
        navigationController?.pushViewController(detail, animated: true)
    }
    */
    private func estimateFrameForText(text: String) -> CGRect{
        let size = CGSize.init(width: view.frame.width-20, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString.init(string: text).boundingRect(with: size, options: options,
                            attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)], context: nil)
    }
    private func getFeeds(){
        let ref = Database.database().reference().child("news")
        
        ref.observeSingleEvent(of: .value, with: { (snapshots) in
            self.feeds = []
            for snapshot in snapshots.children{
                let feed = Feed.init(snapshot: snapshot as! DataSnapshot)
                self.feeds.append(feed)
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
}

