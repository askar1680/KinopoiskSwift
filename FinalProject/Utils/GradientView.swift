//
//  GradientView.swift
//  FinalProject
//
//  Created by Аскар on 07.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    private var gradientLayer: CAGradientLayer!
    
    var startPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var startPointY: CGFloat = 0.65 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var endPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var endPointY: CGFloat = 0.95 {
        didSet {
            setNeedsLayout()
        }
    }
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    var startColor: UIColor = UIColor.clear {
        didSet{
            setNeedsLayout()
        }
    }
    
    var middleColor: UIColor = UIColor.init(red: 21/255, green: 27/255, blue: 36/255, alpha: 0.3){
        didSet{
            setNeedsLayout()
        }
    }
    
    var endColor: UIColor = Colors.mainColor{
        didSet{
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        self.gradientLayer = self.layer as! CAGradientLayer
        self.gradientLayer.colors = [startColor.cgColor, middleColor.cgColor, endColor.cgColor]
        self.gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        self.gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
    }
}
