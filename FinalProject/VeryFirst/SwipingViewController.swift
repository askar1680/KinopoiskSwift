//
//  SwipingViewController.swift
//  FinalProject
//
//  Created by Аскар on 06.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit


class SwipingViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var isNextEnabled = true
    
    let pages = [Page.init(imageName: "start2", title: "Бесплатный каталог", subtitle: "Тысячи фильмов, сериалов и мульфильмов, доступных совершенно бесплатно"),
                 Page.init(imageName: "start3", title: "Ежедневные новости", subtitle: "Ежедневные обновляемые новости от профессиональных журналистов Кинопоиск"),
                 Page.init(imageName: "start5", title: "Премьеры", subtitle: "Горячие новинки мирового кинопроката.")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.isPagingEnabled = true
        
        setupBottomControlls()
        
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_) in
            self.collectionViewLayout.invalidateLayout()
            let indexPath = IndexPath(item: self.pageControl.currentPage, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }, completion: { (b) in
            
            
        })
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PageCell
        cell.backgroundImageView.image = UIImage.init(named: pages[indexPath.row].imageName!)
        cell.tvDescription.text = pages[indexPath.row].title! + "\n\n" + pages[indexPath.row].subtitle!
        cell.page = pages[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        let current = Int(x / view.frame.width)
        pageControl.currentPage = current
        print(current)
        if current == pages.count-1{
            nextButton.setTitle("Пропустить", for: .normal)
            isNextEnabled = false
        }
        else {
            nextButton.setTitle("Далее", for: .normal)
            isNextEnabled = true
        }
    }
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(nextPressed), for: .touchUpInside)
        button.setTitle("Далее", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        //button.titleLabel?.textColor = UIColor.init(red: 80/255, green: 150/255, blue: 220/255, alpha: 1)
        button.setTitleColor(Colors.blueColor, for: .normal)
        return button
    }()
    
    @objc func nextPressed(){
        if !isNextEnabled{
            dismiss(animated: true, completion: nil)
        }
        let nextIndex = min(pageControl.currentPage + 1, pages.count-1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        if nextIndex == pages.count-1{
            nextButton.setTitle("Пропустить", for: .normal)
            isNextEnabled = false
            
        }
        else {
            nextButton.setTitle("Далее", for: .normal)
            isNextEnabled = true
        }
        pageControl.currentPage = nextIndex
        
    }
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = .lightGray
        pc.isUserInteractionEnabled = false
        return pc
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let firstColor = UIColor.init(red: 1, green: 78/255, blue: 137/255, alpha: 1)
        let attributedText = NSMutableAttributedString(string: "Sounds", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 28),
                                                                                   NSAttributedStringKey.foregroundColor: firstColor
            ])
        attributedText.append(NSAttributedString(string: "Well", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 28), NSAttributedStringKey.foregroundColor: UIColor.white]))
        
        label.attributedText = attributedText
        
        return label
    }()
    
    
    fileprivate func setupBottomControlls(){
        
        let bottomControlsStackView = UIStackView(arrangedSubviews: [pageControl, nextButton])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.distribution = .fillEqually
        bottomControlsStackView.axis = .horizontal
        
        view.addSubview(bottomControlsStackView)
        view.addSubview(nameLabel)
        
        
        
        NSLayoutConstraint.activate([
            bottomControlsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
            ])
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.frame.height/4),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
    }
    
}

