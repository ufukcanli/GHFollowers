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
        
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                print(user)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
            
        }
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
}
