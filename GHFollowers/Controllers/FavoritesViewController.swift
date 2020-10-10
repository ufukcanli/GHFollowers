//
//  FavoritesViewController.swift
//  GHFollowers
//
//  Created by Ufuk Canlı on 5.10.2020.
//  Copyright © 2020 Ufuk Canlı. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        PersistenceManager.retrieveFavorites { result in
            switch result {
                case .success(let favorites):
                    print(favorites)
                case .failure(let error):
                    break
            }
        }
    }

}
