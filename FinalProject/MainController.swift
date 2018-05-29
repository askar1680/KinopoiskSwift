//
//  MainController.swift
//  FinalProject
//
//  Created by Аскар on 06.04.2018.
//  Copyright © 2018 askar.ulubayev168. All rights reserved.
//

import UIKit


class MainController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.mainColor
        
        let newsController = NewsController(collectionViewLayout: UICollectionViewFlowLayout())
        let navigationController0 = UINavigationController(rootViewController: newsController)
        navigationController0.tabBarItem = UITabBarItem.init(title: "Новости", image: UIImage.init(named: "news"), tag: 0)
        
        let moviesController = MoviesController()
        let navigationController1 = UINavigationController(rootViewController: moviesController)
        navigationController1.tabBarItem = UITabBarItem.init(title: "Фильмы", image: UIImage.init(named: "movies"), tag: 1)
        
        //let layout = UICollectionViewFlowLayout()
        //layout.scrollDirection = .vertical
        let searchController = SearchController()
        let navigationController2 = UINavigationController.init(rootViewController: searchController)
        navigationController2.tabBarItem = UITabBarItem.init(title: "Поиск", image: UIImage.init(named: "search"), tag: 2)
        
        let myMoviesController = MyMoviesController()
        let navigationController3 = UINavigationController(rootViewController: myMoviesController)
        navigationController3.tabBarItem = UITabBarItem.init(title: "Мои фильмы", image: UIImage.init(named: "my_movies"), tag: 3)
        
        
        
        let profilePageController = ProfilePageController()
        let navigationController4 = UINavigationController(rootViewController: profilePageController)
        navigationController4.tabBarItem = UITabBarItem.init(title: "Профиль", image: UIImage.init(named: "profile_page"), tag: 4)
        
        viewControllers = [navigationController0, navigationController1, navigationController2, navigationController3, navigationController4]
        tabBar.barTintColor = .black
        tabBar.backgroundColor = Colors.mainColor
        tabBar.tintColor = .white
        
    }
}
