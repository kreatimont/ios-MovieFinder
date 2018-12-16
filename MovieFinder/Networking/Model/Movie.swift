//
//  Movie.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 11/19/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import Foundation

class Movie: Codable {
    
    let id: Int
    let title: String
    let backdropPath: String?
    let posterPath: String?
    let description: String?
    let year: Date?
    let videos: [Video]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case backdropPath = "backdrop_path"
        case description = "overview"
        case year = "release_date"
        case posterPath = "poster_path"
        case videos = "videos"
    }
    
    init?(with dict: [String: Any?]) {
        guard let id = dict[CodingKeys.id.rawValue] as? Int else { return nil }
        self.id = id
        guard let title = dict[CodingKeys.title.rawValue] as? String else { return nil }
        self.title = title
        self.backdropPath = dict[CodingKeys.backdropPath.rawValue] as? String
        self.posterPath = dict[CodingKeys.posterPath.rawValue] as? String
        self.description = dict[CodingKeys.description.rawValue] as? String
        
        if let date = dict[CodingKeys.year.rawValue] as? String {
            self.year = self.dateFormatter.date(from: date)
        } else {
            self.year = nil
        }
        
        var tmpVideos = [Video]()
        if let videos = dict[CodingKeys.videos.rawValue] as? [String: AnyObject], let results = videos["results"] as? [[String: AnyObject]] {
            for result in results {
                if let video = Video(with: result) {
                    tmpVideos.append(video)
                }
            }
        }
        self.videos = tmpVideos
        
    }
    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-mm-dd"
        return dateFormatter
    }()
    
}

extension Movie {
    
    var thumbnailUrl: URL? {
        if let path = backdropPath {
            return URL(string: "\(Constants.Api.imageUrl)/\(Constants.Api.thumbnailImageSize)\(path)")
        }
        return nil
    }
    
    var backdropUrl: URL? {
        if let path = backdropPath {
            return URL(string: "\(Constants.Api.imageUrl)/\(Constants.Api.originalImageSize)\(path)")
        }
        return nil
    }
    
    var posterUrl: URL? {
        if let path = posterPath {
            return URL(string: "\(Constants.Api.imageUrl)/\(Constants.Api.defaultImageSize)\(path)")
        }
        return nil
    }
    
}
