//
//  FollowersViewController.swift
//  GHFollowers
//
//  Created by Ufuk Canlı on 19.09.2020.
//  Copyright © 2020 Ufuk Canlı. All rights reserved.
//

import UIKit

class FollowersViewController: UIViewController {
        
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}
