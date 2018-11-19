//
//  Video.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 11/19/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import Foundation

class Video: Codable {
    
    let id: String
    let key: String
    let name: String
    let site: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case key = "key"
        case name = "name"
        case site = "site"
    }
    
    init?(with dict: [String: AnyObject]) {
        guard let id = dict[CodingKeys.id.rawValue] as? String else { return nil }
        self.id = id
        
        guard let name = dict[CodingKeys.name.rawValue] as? String else { return nil }
        self.name = name
        
        guard let key = dict[CodingKeys.key.rawValue] as? String else { return nil }
        self.key = key
        
        guard let site = dict[CodingKeys.site.rawValue] as? String else { return nil }
        self.site = site
    }
    
}

extension Video {
    
    var videoUrl: URL? {
        if site.lowercased() == "youtube" {
            return URL(string: "https://www.youtube.com/watch?v=\(key)")
        }
        return nil
    }
    
    var thumbnailUrl: URL? {
        if site.lowercased() == "youtube" {
            return URL(string: "https://img.youtube.com/vi/\(key)/hqdefault.jpg")
        }
        return nil
    }
    
}
