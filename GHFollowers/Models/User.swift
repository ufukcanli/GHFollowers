//
//  User.swift
//  GHFollowers
//
//  Created by Ufuk Canlı on 19.09.2020.
//  Copyright © 2020 Ufuk Canlı. All rights reserved.
//

import Foundation

struct User: Codable {
    let login: String
    let avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    let following: Int
    let followers: Int
    let createdAt: String
}
