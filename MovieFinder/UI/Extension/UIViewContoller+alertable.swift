//
//  UIViewContoller+alertable.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 11/19/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import UIKit

protocol Alertable {
    func showAlert(title: String?, message: String?, buttonTitle: String?, handler: ((UIAlertAction) -> ())?)
}

extension Alertable where Self: UIViewController {
    
    func showAlert(title: String?, message: String?, buttonTitle: String?, handler: ((UIAlertAction) -> ())?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: handler))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}

