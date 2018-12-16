//
//  User.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 12/17/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import Foundation

class User {
    
    let id: Int
    let email: String
    let serverId: String?
    let passwordHash: String?
    var watchlaterMoviesIds: [Int]
    
    init?(with dict: [String: Any?]) {
        guard let id = dict["userId"] as? Int else { return nil }
        self.id = id
        
        guard let email = dict["email"] as? String else { return nil }
        self.email = email
        
        if let serverId = dict["_id"] as? String {
            self.serverId = serverId
        } else {
            self.serverId = nil
        }
        
        if let passwordHash = dict["passwordHash"] as? String {
            self.passwordHash = passwordHash
        } else {
            self.passwordHash = nil
        }
        
        if let moviesIDs = dict["movies_to_watch"] as? [Int] {
            self.watchlaterMoviesIds = moviesIDs
        } else {
            self.watchlaterMoviesIds = []
        }
        
    }
    
}
