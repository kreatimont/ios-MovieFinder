//
//  Response.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 11/19/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

class MovieResponse: Codable {
    
    let page: Int
    let totalResults: Int?
    let totalPages: Int?
    let results: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results = "results"
    }
    
    init?(with dict: [String: Any?]) {
        guard let page = dict[CodingKeys.page.rawValue] as? Int else { return nil }
        self.page = page
        
        self.totalResults = dict[CodingKeys.totalResults.rawValue] as? Int
        self.totalPages = dict[CodingKeys.totalPages.rawValue] as? Int
        
        guard let results = dict[CodingKeys.results.rawValue] as? [[String: AnyObject]] else { return nil }
        var movies = [Movie]()
        for result in results {
            if let movie = Movie(with: result) { movies.append(movie) }
        }
        self.results = movies
    }
    
}
