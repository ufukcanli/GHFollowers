//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Ufuk Canlı on 20.09.2020.
//  Copyright © 2020 Ufuk Canlı. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    let baseURL = "https://api.github.com"
    
    private init() {}
    
    func getFollowers(for username: String, page: Int, completion: @escaping ([Follower]?, String?) -> Void) {
        
        let endpoint = "\(baseURL)/users/\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completion(nil, "Try another username.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completion(nil, "Check your network connection.")
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil, "Invalid response. Try again.")
                return
            }
            
            guard let data = data else {
                completion(nil, "Couldn't get the data from the server.")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completion(followers, nil)
            } catch {
                completion(nil, "Data received from the server is invalid.")
            }
        }
        
        task.resume()
    }
    
}
