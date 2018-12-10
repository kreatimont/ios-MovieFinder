//
//  ApiManager.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 19/11/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import Alamofire

class MovieClient {
    
    static func popular(page: Int, completion: @escaping (Result<Any>)->Void) -> DataRequest {
        return Alamofire.request(MovieRouter.popular(page: page)).responseJSON { (response: DataResponse) in
            completion(response.result)
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


