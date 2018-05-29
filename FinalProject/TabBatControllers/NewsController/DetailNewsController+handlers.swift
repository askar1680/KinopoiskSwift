//
//  DetailNewsController+handlers.swift
//  FinalProject
//
//  Created by Аскар on 11.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import Firebase


extension DetailNewsController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.headerCell, for: indexPath) as! NewsImageTVCell
            cell.selectionStyle = .none
            if let feed = feed{
                cell.feed = feed
            }
            cell.imageViews = feed?.imageViews
            return cell
        }
        else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextTVCell") as! TextTVCell
            cell.newsTopic = feed?.topic
            cell.newsText = feed?.text
            cell.selectionStyle = .none
            
            return cell
        }
        else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.commentsCell) as! CommentTVCell
            cell.comments = feed?.comments
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.leaveACommentCell) as! LeaveACommentCell
            cell.leaveCommentDelegate = self
            cell.selectionStyle = .none
            return cell
        }
            
        else {
            let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "myCell")
            cell.textLabel?.text = "text"
            cell.detailTextLabel?.text = "detail text"
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            let width = UIScreen.main.bounds.width
            let height = 9*width/16 + 25
            return height
        }
        else if indexPath.row == 1{
            let text = feed?.topic
            let detailText = feed?.text
            let height = estimateFrameForText(text: text!, font: UIFont.boldSystemFont(ofSize: 15)).height +
                estimateFrameForText(text: detailText!, font: UIFont.systemFont(ofSize: 13)).height + 32
            return height
        }
        else if indexPath.row == 2{
            let heightOfImage:CGFloat = CGFloat(60 * (feed?.comments?.count)!)
            var heightOfComments: CGFloat = 0
            for comment in (feed?.comments)!{
                heightOfComments += estimateFrameForText(text: comment.comment!, font: UIFont.systemFont(ofSize: 13)).height
            }
            return heightOfComments+heightOfImage
        }
        else if indexPath.row == 3{
            return 180
        }
        return 0
    }
    
    private func estimateFrameForText(text: String, font: UIFont) -> CGRect {
        let size = CGSize.init(width: view.frame.width - 16, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString.init(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: font], context: nil)
        
    }
    
    
}

extension DetailNewsController{
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = 9*view.frame.width/16 - 4*view.frame.width/16
        var offSet = scrollView.contentOffset.y / height
        if offSet > 1{
            offSet = 1
            let color = UIColor.init(red: 21/255, green: 27/255, blue: 36/255, alpha: offSet)
            self.navigationController?.navigationBar.backgroundColor = color
            UIApplication.shared.statusBarView?.backgroundColor = color
        }
        else{
            let color = UIColor.init(red: 21/255, green: 27/255, blue: 36/255, alpha: offSet)
            self.navigationController?.navigationBar.backgroundColor = color
            UIApplication.shared.statusBarView?.backgroundColor = color
        }
    }
}

