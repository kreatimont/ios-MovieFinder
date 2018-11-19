//
//  NavigationController+lightContent.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 11/19/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import UIKit

class NavigationControllerLightStatusBar: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        navigationBar.isTranslucent = true
        navigationBar.barStyle = .black
    }
    
}

