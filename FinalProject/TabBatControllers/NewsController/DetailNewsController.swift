//
//  DetailNewsController.swift
//  FinalProject
//
//  Created by Аскар on 07.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import Firebase

extension DetailNewsController: LeaveCommentToNewsDelegate{
    func leaveComment(comment: String) {
        if let feed = feed{
            let commentRef = Database.database().reference().child("news").child(feed.snapshotKey!).child("comments").childByAutoId()
            let currentUserId = Auth.auth().currentUser?.uid
            let timestamp = Int(NSDate().timeIntervalSince1970)
            let myComment = Comment.init(userUrl: currentUserId!, timestamp: timestamp, comment: comment)
            let commentValues = myComment.toJSONFormat()
            commentRef.setValue(commentValues)
            self.feed?.comments?.append(myComment)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}



class DetailNewsController: UITableViewController {
    
    var feed: Feed? {
        didSet{
            
        }
    }
    var indexPath: IndexPath?
    var pageIndex = 0
    var oX: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.mainColor
        setupNevigationController()
        setupTableView()
        
        let ref = Database.database().reference().child("news").child((feed?.snapshotKey)!).child("comments")
        ref.observe(.value, with: { (snapshots) in
            self.feed?.comments = []
            for snapshot in snapshots.children{
                let snap = snapshot as! DataSnapshot
                let comment = Comment.init(snapshot: snap)
                self.feed?.comments?.append(comment)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }, withCancel: nil)
        
    }
    func setupNevigationController(){
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.isTranslucent = true
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        
    }
    struct TableCell {
        static let headerCell = "headerCell"
        static let textTVCell = "TextTVCell"
        static let commentsCell = "CommentTVCell"
        static let leaveACommentCell = "leaveACommentCell"
    }
    func setupTableView(){
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        tableView.register(NewsImageTVCell.self, forCellReuseIdentifier: TableCell.headerCell)
        tableView.register(TextTVCell.self, forCellReuseIdentifier: TableCell.textTVCell)
        tableView.register(CommentTVCell.self, forCellReuseIdentifier: TableCell.commentsCell)
        tableView.register(LeaveACommentCell.self, forCellReuseIdentifier: TableCell.leaveACommentCell)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.backgroundColor = Colors.mainColor
        UIApplication.shared.statusBarView?.backgroundColor = Colors.mainColor
        
    }
    
}




