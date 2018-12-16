//
//  ApiRouter.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 19/1/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import Alamofire

enum MovieFinderRouter: URLRequestConvertible {
    
    case top(page: Int)
    case latest(page: Int)
    case details(id: Int)
    case search(name: String)
    case addToWatchLater(movieId: Int)
    case removeFromWatchLater(movieId: Int)
    case userProfile(id: Int)
    
    private var method: HTTPMethod {
        switch self {
        case .top, .latest, .details, .search, .userProfile:
            return .get
        case .addToWatchLater, .removeFromWatchLater:
            return .post
        }
    }
    
    private var path: String {
        switch self {
        case .top:
            return "/movies/top"
        case .latest:
            return "/movies/latest"
        case .details(let id):
            return "/movies/\(id)"
        case .search:
            return "/movies/search"
        case .userProfile(let id):
            return "/profile/\(id)"
        case .addToWatchLater:
            return "/profile/addWatchLater"
        case .removeFromWatchLater:
            return "/profile/removeWatchLater"
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .top(let page), .latest(let page):
            return [Constants.Api.ParameterKey.page: page]
        case .details, .userProfile:
            return nil
        case .search(let name):
            return [Constants.Api.ParameterKey.searchName: name]
        case .addToWatchLater(let movieId), .removeFromWatchLater(let movieId):
            return [Constants.Api.ParameterKey.userId: AuthSession.current.userId!,
                Constants.Api.ParameterKey.movieId: movieId]
        }
    }
    
    private var baseUrl: String {
        switch self {
        case .top, .latest, .details, .search, .userProfile, .addToWatchLater, .removeFromWatchLater:
            return "\(Constants.Api.localUrl)"
        }
    }
    
    private var encoding: ParameterEncoding {
        switch self.method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    private var headers: [String: String?] {
        return [:]
    }
    
    func asURLRequest() throws -> URLRequest {
        let baseUrlString = baseUrl.appending(path)
        let url = try baseUrlString.asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        for header in self.headers {
            if let value = header.value {
                urlRequest.addValue(value, forHTTPHeaderField: header.key)
            }
        }
        
        print("[Network] \(self.method.rawValue.uppercased()) \(self.baseUrl)\(self.path) \(self.parameters ?? [:]) ⬆️")
        
        if let parameters = parameters {
            return try encoding.encode(urlRequest, with: parameters)
        } else {
            return urlRequest
        }
        
    }
    
}
