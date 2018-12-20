//
//  Settings.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 12/20/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import Foundation

class Settings: NSObject {
    
    static let shared = Settings()
    private override init() {}
    
    
    private let userDefaults = UserDefaults.standard
    
    var localUrl: String {
        get {
            if let url = self.userDefaults.string(forKey: "local-url"), url.count > 0 {
                return url
            } else {
                return Constants.Api.localUrl
            }
        }
        set {
            self.userDefaults.set(newValue, forKey: "local-url")
            self.userDefaults.synchronize()
        }
    }
    
    var watchlistUpdated: Bool {
        get {
            if let watchlist = self.userDefaults.object(forKey: "watchlist") as? Bool {
                return watchlist
            } else {
                return true
            }
        }
        set {
            self.userDefaults.set(newValue, forKey: "watchlist")
            self.userDefaults.synchronize()
            NotificationCenter.default.post(name: .didWatchlistUpdated, object: nil)
        }
    }
    
}
