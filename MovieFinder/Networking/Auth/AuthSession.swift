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
    
    func update(authToken: String, email: String? = nil, userId: Int? = nil) {
        self.authToken = authToken
        self.email = email
        self.userId = userId
        Alamofire.SessionManager.default.adapter = AccessTokenAdapter(accessToken: authToken)
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
    
    var email: String? {
        get {
            let defaults = UserDefaults.standard
            let value: String? = defaults.value(forKey: "email") as? String
            return value
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "email")
            defaults.synchronize()
        }
    }
    
    var userId: Int? {
        get {
            let defaults = UserDefaults.standard
            return defaults.integer(forKey: "user-id")
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "user-id")
            defaults.synchronize()
        }
    }
    
}

extension AuthSession {
    
    func isActive() -> Bool {
        return self.authToken != nil && self.userId != nil
    }
    
    func close(rememberCredetionals: Bool = true) {
        self.authToken = nil
        self.userId = nil
        Alamofire.SessionManager.default.session.getAllTasks { (tasks) in tasks.forEach { $0.cancel() } }
        Alamofire.SessionManager.default.adapter = nil
        if !rememberCredetionals {
            self.email = nil
        }
    }
    
    
}
