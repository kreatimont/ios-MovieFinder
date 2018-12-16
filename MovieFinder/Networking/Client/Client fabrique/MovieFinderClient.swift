//
//  MovieFinderClient.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 12/16/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import Alamofire

class MovieFinderClient: MoviesAbstractClient {
    
    func details(id: Int, completion: ((Movie?, String?) -> ())?) {
        _ = Alamofire.request(MovieFinderRouter.details(id: id)).responseData { (response: DataResponse) in
            
            switch response.result {
            case .success(let data):
                
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any?], let safeJson = json {
                    if let resp = Movie(with: safeJson) {
                        completion?(resp, nil)
                    } else {
                        completion?(nil, "Bad response format")
                    }
                } else {
                    completion?(nil, "Bad response format")
                }
                
            case .failure(let error):
                completion?(nil, error.localizedDescription)
            }
            
        }.log()
    }
    
    
    func top(page: Int, completion: ((MovieResponse?, String?) -> ())?) {
        _ = Alamofire.request(MovieFinderRouter.top(page: page)).responseData { (response: DataResponse) in
            
            switch response.result {
            case .success(let data):
                
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any?], let safeJson = json {
                    if let resp = MovieResponse(with: safeJson) {
                        completion?(resp, nil)
                    } else {
                        completion?(nil, "Bad response format")
                    }
                } else {
                    completion?(nil, "Bad response format")
                }
                
            case .failure(let error):
                completion?(nil, error.localizedDescription)
            }
            
        }.log()
    }
    
    static func register(email: String, user: String, password: String, completion: ((_ token: String?, _  error: String?) -> ())?) -> DataRequest {
        return Alamofire.request(MovieFinderAuthRouter.signup(username: user, password: password, email: email)).responseData { (response: DataResponse) in
            
            switch response.result {
            case .success(let data):
                
                if let headers = response.response?.allHeaderFields, let authToken = headers["Authorization"] as? String {
                    completion?(authToken, nil)
                } else {
                    
                    if let error = String(data: data, encoding: .utf8) {
                        completion?(nil, error)
                    } else {
                        completion?(nil, "bad response")
                    }
                    
                }
                
            case .failure(let error):
                completion?(nil, error.localizedDescription)
            }
            
        }.log()
    }
    
}
