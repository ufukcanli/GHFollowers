//
//  Follower.swift
//  GHFollowers
//
//  Created by Ufuk Canlı on 19.09.2020.
//  Copyright © 2020 Ufuk Canlı. All rights reserved.
//

import Foundation

struct Follower: Codable, Hashable {
    let login: String
    let avatarUrl: String
}
