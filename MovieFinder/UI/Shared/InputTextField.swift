//
//  InputTextField.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 12/2/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import UIKit

class InputTextField: UITextField {
    
    private lazy var underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        self.addSubview(underlineView)
        underlineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hightlight(_ isHighlighted: Bool) {
        if isHighlighted {
            underlineView.backgroundColor = self.tintColor
        } else {
            underlineView.backgroundColor = UIColor.darkGray
        }
    }
    
}
