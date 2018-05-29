//
//  TextTVCell.swift
//  FinalProject
//
//  Created by Аскар on 09.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit

class TextTVCell: UITableViewCell {
    
    var attributedText = NSMutableAttributedString.init()
    
    var newsTopic: String? {
        didSet{
            let paragraphStyleForTopic = NSMutableParagraphStyle()
            paragraphStyleForTopic.alignment = .left
            attributedText = NSMutableAttributedString.init(string: newsTopic!, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.paragraphStyle: paragraphStyleForTopic])
            
        }
    }
    
    var originalName: String?{
        didSet{
            attributedText.append(NSMutableAttributedString.init(string: "\n\nОригинальное название: \(originalName!)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColor.white]))
            
        }
    }
    
    var tagline: String?{
        didSet{
            attributedText.append(NSMutableAttributedString.init(string: "\nСлоган: \(tagline!)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColor.white]))
        }
    }
    
    var countries: String? {
        didSet{
            attributedText.append(NSMutableAttributedString.init(string: "\nСтрана: \(countries!)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColor.white]))
        }
    }
    
    var newsText: String?{
        didSet{
            let paragraphStyleForDescription = NSMutableParagraphStyle()
            paragraphStyleForDescription.alignment = .left
            attributedText.append(NSMutableAttributedString.init(string: "\n\n\(newsText!)",
                attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.paragraphStyle: paragraphStyleForDescription]))
            attributedTextView.attributedText = attributedText
        }
    }
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Colors.mainColor
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let attributedTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.boldSystemFont(ofSize: 14)
        textView.isEditable = false
        textView.backgroundColor = Colors.mainColor
        
        textView.isScrollEnabled = false
        return textView
    }()
    
    
    func setupViews(){
        addSubview(attributedTextView)
        
        attributedTextView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8))
        
        
    }
}
