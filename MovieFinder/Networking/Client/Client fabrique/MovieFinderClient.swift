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
typealias SearchCompletion = ((_ movies: [Movie], _ error: String?) -> ())
typealias ProfileCompletion = ((_ user: User?, _ error: String?) -> ())

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
    
    func search(name: String, completion: SearchCompletion?) {
        _ = Alamofire.request(MovieFinderRouter.search(name: name)).responseData { (response: DataResponse) in
            
            switch response.result {
            case .success(let data):
                
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any?]], let safeJson = json {
                    
                    var movies = [Movie]()
                    
                    for rawMovieData in safeJson {
                        if let movie = Movie(with: rawMovieData) {
                            movies.append(movie)
                        }
                    }
                    completion?(movies, nil)
                    
                } else {
                    completion?([], "Bad response format")
                }
                
            case .failure(let error):
                completion?([], error.localizedDescription)
            }
            
            }.log()
    }
    
    func profile(id: Int, completion: ProfileCompletion?) -> DataRequest {
        return Alamofire.request(MovieFinderRouter.userProfile(id: id)).responseData { (response: DataResponse) in
            
            switch response.result {
            case .success(let data):
                
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any?], let safeJson = json {
                    
                    if let user = User(with: safeJson) {
                        completion?(user, nil)
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
    
    func addToWatchLater(movieId: Int, completion: RegisterCompletion?) -> DataRequest {
        return Alamofire.request(MovieFinderRouter.addToWatchLater(movieId: movieId)).responseData { (response: DataResponse) in
            
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
    
    func removeFromWatchLater(movieId: Int, completion: RegisterCompletion?) -> DataRequest {
        return Alamofire.request(MovieFinderRouter.removeFromWatchLater(movieId: movieId)).responseData { (response: DataResponse) in
            
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
    
    
    //AUTH PART
    
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
