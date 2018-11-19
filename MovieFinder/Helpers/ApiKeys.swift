//
//  ApiKeys.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 11/19/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import Foundation

func valueForAPIKey(keyname:String) -> String {
    let filePath = Bundle.main.path(forResource: "keys", ofType: "plist")
    let plist = NSDictionary(contentsOfFile: filePath!)
    
    if let value = plist?.object(forKey: keyname) as? String {
        return value
    } else {
        fatalError("API KEY REQUIRED!")
    }
}
