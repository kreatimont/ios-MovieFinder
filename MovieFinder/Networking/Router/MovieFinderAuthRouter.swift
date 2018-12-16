//
//  AuthRouter.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 12/10/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import Alamofire

enum MovieFinderAuthRouter: URLRequestConvertible {
    
    case login(email: String, password: String)
    case signup(username: String, password: String, email: String)
    
    private var method: HTTPMethod {
        switch self {
        case .login, .signup:
            return .post
        }
    }
    
    private var path: String {
        switch self {
        case .login:
            return "/login"
        case .signup:
            return "/register"
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .login(let username, let password):
            return [Constants.Api.ParameterKey.email: username,
                    Constants.Api.ParameterKey.password: password]
        case .signup(let username, let password, let email):
            return [Constants.Api.ParameterKey.username: username,
                    Constants.Api.ParameterKey.password: password,
                    Constants.Api.ParameterKey.email: email]
        }
    }
    
    private var baseUrl: String {
        switch self {
        case .login, .signup:
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
    
    func asURLRequest() throws -> URLRequest {
        let baseUrlString = baseUrl.appending(path)
        let url = try baseUrlString.asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        print("[Network] \(self.method.rawValue.uppercased()) \(self.baseUrl)\(self.path) \(self.parameters ?? [:]) ⬆️")
        
        if let parameters = parameters {
            return try encoding.encode(urlRequest, with: parameters)
        } else {
            return urlRequest
        }
        
    }
    
}
