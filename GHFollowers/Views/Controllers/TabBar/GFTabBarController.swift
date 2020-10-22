//
//  GFTabBarController.swift
//  GHFollowers
//
//  Created by Ufuk Canlı on 22.10.2020.
//  Copyright © 2020 Ufuk Canlı. All rights reserved.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [
            createSearchNavigationController(),
            createFavoritesNavigationController()
        ]
        
        UITabBar.appearance().tintColor = .systemGreen
    }
    
    func createSearchNavigationController() -> UINavigationController {
        let searchViewController = SearchViewController()
        searchViewController.title = "Search"
        searchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        return UINavigationController(rootViewController: searchViewController)
    }
    
    func createFavoritesNavigationController() -> UINavigationController {
        let favoritesViewController = FavoritesViewController()
        favoritesViewController.title = "Favorites"
        favoritesViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        return UINavigationController(rootViewController: favoritesViewController)
    }

}
