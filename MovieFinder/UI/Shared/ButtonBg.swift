//
//  Button.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 12/2/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import UIKit

class ButtonBg: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = Color.colorAccent
        self.titleLabel?.textColor = UIColor.white
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        self.layer.cornerRadius = 8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.backgroundColor = self.tintColor.withAlphaComponent(0.5)
            } else {
                self.backgroundColor = self.tintColor
            }
        }
    }
    
}
