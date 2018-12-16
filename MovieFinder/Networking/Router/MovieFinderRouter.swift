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
    
    private var method: HTTPMethod {
        switch self {
        case .top, .latest, .details, .search:
            return .get
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
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .top(let page), .latest(let page):
            return [Constants.Api.ParameterKey.page: page]
        case .details:
            return nil
        case .search(let name):
            return [Constants.Api.ParameterKey.searchName: name]
        }
    }
    
    private var baseUrl: String {
        switch self {
        case .top, .latest, .details, .search:
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
