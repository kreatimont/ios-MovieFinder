//
//  Auth.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 12/10/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import Foundation
import Alamofire

class AuthSession {
    
    static let current = AuthSession()
    
    init() {
    }
    
    func update(authToken: String, username: String? = nil) {
        self.authToken = authToken
        self.username = username
    }
    
    var authToken: String? {
        get {
            let defaults = UserDefaults.standard
            let value: String? = defaults.value(forKey: "auth-token") as? String
            return value
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "auth-token")
            defaults.synchronize()
        }
    }
    
    var username: String? {
        get {
            let defaults = UserDefaults.standard
            let value: String? = defaults.value(forKey: "username") as? String
            return value
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "username")
            defaults.synchronize()
        }
    }
    
}

extension AuthSession {
    
    func isActive() -> Bool {
        return self.authToken != nil
    }
    
    func close(rememberCredetionals: Bool = true) {
        self.authToken = nil
        Alamofire.SessionManager.default.session.getAllTasks { (tasks) in tasks.forEach { $0.cancel() } }
        if !rememberCredetionals {
            self.username = nil
        }
    }
    
    
}
