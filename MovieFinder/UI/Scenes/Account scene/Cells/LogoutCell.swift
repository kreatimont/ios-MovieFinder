//
//  LogoutCell.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 12/10/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import UIKit
import SnapKit

class LogoutCell: UITableViewCell {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.textLabel?.removeFromSuperview()
        
        let logoutLabel = UILabel()
        logoutLabel.text = "Log out"
        logoutLabel.textColor = Color.destructive
        logoutLabel.font = UIFont.systemFont(ofSize: 17)
        
        self.contentView.addSubview(logoutLabel)
        logoutLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
