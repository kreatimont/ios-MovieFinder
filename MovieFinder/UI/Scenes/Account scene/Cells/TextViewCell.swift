//
//  TextViewCEll.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 12/17/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import UIKit
import SnapKit

class TextViewCell: UITableViewCell {
    
    lazy var textView = UITextView()
    lazy var label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.snp.makeConstraints { (make) in
            make.height.equalTo(140)
        }
//        
//        label.textColor = Color.mainText
//        label.numberOfLines = 5
//        
//        self.contentView.addSubview(label)
//        label.snp.makeConstraints { (make) in
//            make.left.top.equalToSuperview().inset(16)
//        }
//        
//        textView.textColor = Color.secondaryText
//        textView.font = UIFont(name: "Courier", size: 16)
//        
//        self.contentView.addSubview(textView)
//        textView.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().inset(8)
//            make.top.equalTo(self.label.snp.bottom).offset(8)
//            make.bottom.equalToSuperview().inset(8)
//        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
