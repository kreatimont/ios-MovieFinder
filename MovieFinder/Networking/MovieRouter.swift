//
//  ApiRouter.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 19/1/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import Alamofire

enum MovieRouter: URLRequestConvertible {
    
    case popular(page: Int)
    case latest(page: Int)
    case details(id: Int)
    
    private var method: HTTPMethod {
        switch self {
        case .popular, .latest, .details:
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .popular:
            return "/movie/popular"
        case .latest:
            return "/movie/latest"
        case .details(let id):
            return "/movie/\(id)"
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .popular(let page), .latest(let page):
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
        case .popular, .latest, .details:
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
    
    func asURLRequest() throws -> URLRequest {
        let baseUrlString = baseUrl.appending(path)
        let url = try baseUrlString.asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        print("[Network] \(self.method.rawValue.uppercased()) \(self.baseUrl)\(self.path) ⬆️")
        
        if let parameters = parameters {
            return try encoding.encode(urlRequest, with: parameters)
        } else {
            return urlRequest
        }
        
    }
    
}
