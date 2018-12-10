//
//  Navigator.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 12/2/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import UIKit

enum Route {
    
    case login
    case popularMovies
    
}

enum Wrap {
    case none
    case navigation
    case tabBar
}

class Navigator {
    
    static let shared = Navigator()
    
    private init() {}
    
    func route(to route: Route, wrap: Wrap = .none) {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        var destinationController: UIViewController!
        
        switch route {
        case .login:
            destinationController = LoginViewController()
        case .popularMovies:
            destinationController = PopularMoviesViewController()
        }
        
        if wrap == .navigation {
            destinationController = NavigationControllerLightStatusBar(rootViewController: destinationController)
        } else if wrap == .tabBar {
            destinationController = assemblyTabBar()
        }
        
        weak var previousRootVC = window.rootViewController
        
        if let rootVC = previousRootVC {
            destinationController.view.frame = rootVC.view.frame
        }
        destinationController.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = destinationController
        }) { (finished) in
            previousRootVC?.children.forEach { $0.removeFromParent() }
        }
    }
    
    func assemblyTabBar() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.barStyle = .black
        
        let popular = PopularMoviesViewController()
        popular.tabBarItem = UITabBarItem(title: "Popular", image: UIImage(named: "ic_popular"), selectedImage: nil)
        
        let account = AccountViewController()
        account.tabBarItem = UITabBarItem(title: "Account", image: UIImage(named: "ic_person"), selectedImage: nil)
        
        let viewControllers = [popular, account]
        tabBarController.viewControllers = viewControllers.map { return NavigationControllerLightStatusBar(rootViewController: $0) }
        
        return tabBarController
    }
    
}

