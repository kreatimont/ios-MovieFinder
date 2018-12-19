//
//  AbstractClient.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 12/16/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import Alamofire

protocol MoviesAbstractClient {
    
    func top(page: Int, completion: ((MovieResponse?, String?) -> ())?)
    func details(id: Int, completion: ((Movie?, String?) -> ())?)
    
}


extension DataRequest {
    
    func log() -> Self {
        return responseData(completionHandler: { (data) in
            print("[Network] \(self.request?.httpMethod ?? "") \(self.request?.url?.absoluteString ?? "") \(data.result.isSuccess ? "✅" : "❌") \(!data.result.isSuccess ? (data.result.error?.localizedDescription ?? "") : "")")
        })
    }
    
}

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
