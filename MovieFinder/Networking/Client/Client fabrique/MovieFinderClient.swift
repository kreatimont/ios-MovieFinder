//
//  MovieFinderClient.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 12/16/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import Alamofire

typealias LoginCompletion = ((_ token: String?, _ userId: Int?, _ error: String?) -> ())
typealias RegisterCompletion = ((_ success: Bool, _ error: String?) -> ())

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
    
    static func register(email: String, user: String, password: String, completion: RegisterCompletion?) -> DataRequest {
        return Alamofire.request(MovieFinderAuthRouter.signup(username: user, password: password, email: email)).responseData { (response: DataResponse) in

            switch response.result {
            case .success(let data):
                if let code = response.response?.statusCode {
                    switch code {
                        case 200...299: completion?(true, nil)
                        default: completion?(false, String(data: data, encoding: .utf8))
                    }
                    
                } else {
                    completion?(false, nil)
                }
            case .failure(let error):
                completion?(false, error.localizedDescription)
            }
            
        }.log()
    }
    
    static func login(email: String, password: String, completion: LoginCompletion?) -> DataRequest {
        return Alamofire.request(MovieFinderAuthRouter.login(email: email, password: password)).responseData { (response: DataResponse) in
            
            switch response.result {
            case .success(let data):
                
                if let headers = response.response?.allHeaderFields,
                    let authToken = headers["Authorization"] as? String,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any?],
                    let safeJson = json, let userData = safeJson["data"] as? [String: Any?],
                    let userId = userData["userId"] as? Int {
                    
                    completion?(authToken, userId, nil)
                    
                } else {
                    
                    if let error = String(data: data, encoding: .utf8) {
                        completion?(nil, nil, error)
                    } else {
                        completion?(nil, nil, "bad response")
                    }
                    
                }
                
            case .failure(let error):
                completion?(nil, nil, error.localizedDescription)
            }
            
            }.log()
    }
    
}
