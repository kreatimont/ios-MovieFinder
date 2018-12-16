//
//  TMDbClient.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 12/16/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import Alamofire

class TMDbClient: MoviesAbstractClient {
    
    func top(page: Int, completion: ((MovieResponse?, String?) -> ())?) {
        _ = Alamofire.request(TMDbRouter.top(page: page)).responseJSON { (response: DataResponse) in
            
            switch response.result {
            case .success(let data):
                guard let dataDict = data as? [String: Any?] else {
                    completion?(nil, "Bad response format")
                    return
                }
                if let mResponse = MovieResponse(with: dataDict) {
                    completion?(mResponse, nil)
                }
            case .failure(let error):
                completion?(nil, error.localizedDescription)
            }
            
        }.log()
    }
    
    func details(id: Int, completion: ((Movie?, String?) -> ())?) {
        _ = Alamofire.request(TMDbRouter.details(id: id)).responseJSON { (response: DataResponse) in
            
            switch response.result {
            case .success(let data):
                guard let dataDict = data as? [String: Any?] else {
                    completion?(nil, "Bad response format")
                    return
                }
                if let mResponse = Movie(with: dataDict) {
                    completion?(mResponse, nil)
                }
            case .failure(let error):
                completion?(nil, error.localizedDescription)
            }
            
        }.log()
    }
    
}


