//
//  ApiManager.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 19/11/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import Alamofire

enum CustomError: String, Error {
    case badResponse
}

class AccessTokenAdapter: RequestAdapter {
    private let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        
        return urlRequest
    }
}

class MovieClient {
    
    static func popular(page: Int, completion: ((MovieResponse?, String?) -> Void)?) -> DataRequest {
        return Alamofire.request(MovieRouter.popular(page: page)).responseData { (response: DataResponse) in
            
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
    
    static func details(id: Int, completion: @escaping (Result<Data>)->Void) -> DataRequest {
        return Alamofire.request(MovieRouter.details(id: id)).responseData { (response: DataResponse) in
            completion(response.result)
        }.log()
    }
    
}

class AuthClient {
    
    static func register(email: String, user: String, password: String, completion: ((_ token: String?, _  error: String?) -> ())?) -> DataRequest {
        return Alamofire.request(AuthRouter.signup(username: user, password: password, email: email)).responseData { (response: DataResponse) in
            
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
    
    static func details(id: Int, completion: @escaping (Result<Any>)->Void) -> DataRequest {
        return Alamofire.request(MovieRouter.details(id: id)).responseJSON { (response: DataResponse) in
            completion(response.result)
            }.log()
    }
    
}

extension DataRequest {
    
    func log() -> Self {
        print("[Network] \(request?.httpMethod ?? "") \(request?.url?.absoluteString ?? "") ✅")
        return self
    }
    
}


