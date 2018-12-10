//
//  LogoutCell.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 12/10/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import UIKit
import SnapKit

class SwitchCell: UITableViewCell {
    
    private lazy var `switch`: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.addTarget(self, action: #selector(handleSwitch(_:)), for: .valueChanged)
        return uiSwitch
    }()
    
    var onSwitchAction: ((_ state: Bool) -> ())? = nil
    
    var isOn: Bool {
        get {
            return self.switch.isOn
        }
        set {
            self.switch.setOn(newValue, animated: false)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.switch)
        self.switch.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - actions
    
    @objc func handleSwitch(_ sender: Any?) {
        self.onSwitchAction?(self.switch.isOn)
    }
    
}

