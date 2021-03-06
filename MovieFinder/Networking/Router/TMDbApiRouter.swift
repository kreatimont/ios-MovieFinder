//
//  ApiRouter.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 19/1/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import Alamofire

enum TMDbRouter: URLRequestConvertible {
    
    case top(page: Int)
    case latest(page: Int)
    case details(id: Int)
    
    private var method: HTTPMethod {
        switch self {
        case .top, .latest, .details:
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .top:
            return "/movie/top_rated"
        case .latest:
            return "/movie/latest"
        case .details(let id):
            return "/movie/\(id)"
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .top(let page), .latest(let page):
            return [Constants.Api.ParameterKey.lang: Locale.current.languageCode ?? "en_US",
                    Constants.Api.ParameterKey.apiKey: valueForAPIKey(keyname: "tmdb-apiv3"),
                    Constants.Api.ParameterKey.page: page]
        case .details:
            return [Constants.Api.ParameterKey.lang: Locale.current.languageCode ?? "en_US",
                    Constants.Api.ParameterKey.apiKey: valueForAPIKey(keyname: "tmdb-apiv3"),
                    Constants.Api.ParameterKey.appendToResponse: "videos"]
        }
    }
    
    private var baseUrl: String {
        switch self {
        case .top, .latest, .details:
            return "\(Constants.Api.baseUrl)/\(Constants.Api.apiVersion)"
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
        return ["Authorization": AuthSession.current.authToken]
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
