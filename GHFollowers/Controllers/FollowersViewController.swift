//
//  FollowersViewController.swift
//  GHFollowers
//
//  Created by Ufuk Canlı on 19.09.2020.
//  Copyright © 2020 Ufuk Canlı. All rights reserved.
//

import UIKit

protocol FollowersViewControllerDelegate: class {
    func didRequestFollowers(for username: String)
}

class FollowersViewController: UIViewController {
    
    enum Section { case main }
        
    var username: String!
    var followers = [Follower]()
    var filteredFollowers = [Follower]()
    var currentPage = 1
    var hasMoreFollowers = true
    var isSearching = false
    var isLoadingMoreFollowers = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureSearchController()
        configureCollectionView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        fetchFollowers(username: username, page: currentPage)
    }
    
    @objc func addButtonTapped() {
        
        showLoadingView()
        
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.dismissLoadingView()
            }
            
            switch result {
                case .success(let user):
                    
                    let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                    
                    PersistenceManager.update(with: favorite, actionType: .add) { [weak self] error in
                        
                        guard let self = self else { return }
                        
                        guard let error = error else {
                            self.presentGFAlertOnMainThread(title: "Success!", message: "You've successfully favorited this user.", buttonTitle: "Hooray!")
                            return
                        }
                        
                        self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                    }
                    
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func fetchFollowers(username: String, page: Int) {
        
        showLoadingView()
        isLoadingMoreFollowers = true
        
        NetworkManager.shared.getFollowers(for: username, page: currentPage) { [weak self] result in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.dismissLoadingView()
            }
            
            switch result {
            case .success(let followers):
                if followers.count < 100 {
                    self.hasMoreFollowers = false
                }
                self.followers.append(contentsOf: followers)
                
                if self.followers.isEmpty {
                    let message = "This user doesn't have any followers."
                    DispatchQueue.main.async {
                        self.showGFEmptyStateView(with: message, in: self.view)
                    }
                    return
                }
                self.updateData(on: self.followers)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
            }
            
            self.isLoadingMoreFollowers = false
        }
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }

    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseIdentifier)
        
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        
        view.addSubview(collectionView)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseIdentifier, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
}


extension FollowersViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - screenHeight {
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
            currentPage += 1
            fetchFollowers(username: username, page: currentPage)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let follower = isSearching ? filteredFollowers[indexPath.item] : followers[indexPath.item]
        
        let destinationViewController = UserInfoViewController()
        destinationViewController.username = follower.login
        destinationViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: destinationViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
}

extension FollowersViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        
        isSearching = true
        
        filteredFollowers = followers.filter { $0.login.lowercased().contains(searchText.lowercased()) }
        
        updateData(on: filteredFollowers)
    }
    
}

extension FollowersViewController: FollowersViewControllerDelegate {
    
    func didRequestFollowers(for username: String) {
        self.username = username
        currentPage = 1
        title = username
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        fetchFollowers(username: username, page: currentPage)
    }
    
}
