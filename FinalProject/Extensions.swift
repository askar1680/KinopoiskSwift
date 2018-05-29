//
//  Extensions.swift
//  FinalProject
//
//  Created by Аскар on 06.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit
import Kingfisher
import YouTubePlayer

let cache = NSCache<AnyObject, AnyObject>()

extension UIView{
    func anchorFullSize(to view: UIView){
        
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero){
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top{
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let leading = leading{
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let bottom = bottom{
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        if let trailing = trailing{
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        if size.width != 0{
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0{
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    func addConstraintsWithFormat(_ format: String, views: UIView... ) {
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}

//let cache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImageUsingKingfisherWithUrlString(urlString: String){
        self.image = nil
        
        // check cache for image
        
        if let cachedImage = cache.object(forKey: urlString as AnyObject) as? ImageResource{
            self.kf.setImage(with: cachedImage)
            return
        }
        
        DispatchQueue.main.async {
            let url = URL.init(string: urlString)
            let resource = ImageResource(downloadURL: url!)
            cache.setObject(resource as AnyObject, forKey: url as AnyObject)
            self.kf.setImage(with: resource)
        }
    }
}



