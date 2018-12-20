//
//  TextFieldCell.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 12/20/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import UIKit
import SnapKit

class TextFieldCell: UITableViewCell {
    
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.rightViewMode = .whileEditing
        tf.textColor = Color.secondaryText
        tf.textAlignment = .right
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.textLabel?.text = "s"
        
        self.contentView.addSubview(self.textField)
        self.textField.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            if self.textLabel != nil {
                make.left.equalTo(self.textLabel!.snp.right).offset(8)
            }
            make.height.equalTo(40)
        }
        
        self.textLabel?.snp.makeConstraints({ (make) in
            make.width.equalTo(120)
            make.height.equalTo(40)
            make.left.equalToSuperview().inset(16)
        })
        
        self.textField.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - actions
    
}


extension TextFieldCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Settings.shared.localUrl = textField.text ?? ""
        textField.endEditing(true)
        return true
    }
    
}
