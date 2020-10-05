//
//  UserInfoViewController.swift
//  GHFollowers
//
//  Created by Ufuk Canlı on 5.10.2020.
//  Copyright © 2020 Ufuk Canlı. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {
    
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = doneButton
        
        print(username!)
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
}
