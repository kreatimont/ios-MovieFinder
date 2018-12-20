//
//  BuyButton.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 12/19/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import UIKit

class BuyButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        self.layer.cornerRadius = 5
        self.layer.borderColor = Color.colorAccent.cgColor
        self.layer.borderWidth = 2
        
        self.setTitleColor(Color.colorAccent, for: .normal)
        self.setTitleColor(Color.background, for: .highlighted)
        
        self.titleLabel?.textColor = Color.colorAccent
        self.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.backgroundColor = self.tintColor
            } else {
                self.backgroundColor = UIColor.clear
            }
        }
    }
    
}
