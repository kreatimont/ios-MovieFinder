//
//  Constants.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 11/19/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

struct Constants {
    
    struct Api {
        static let baseUrl = "https://api.themoviedb.org"
        static let apiVersion = "3"
        static let imageUrl = "https://image.tmdb.org/t/p/"
        static let thumbnailImageSize = "w300"
        static let defaultImageSize = "w500"
        static let originalImageSize = "original"
        
        struct ParameterKey {
            static let lang = "language"
            static let apiKey = "api_key"
            static let page = "page"
            static let appendToResponse = "append_to_response"
            
            static let username = "username"
            static let password = "password"
            static let email = "email"
            
        }
        
    }
    
}
