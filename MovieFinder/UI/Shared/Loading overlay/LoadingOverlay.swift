//
//  LoadingOverlay.swift
//  spot2d-dev
//
//  Created by Alexandr Nadtoka on 10/18/18.
//  Copyright © 2018 gmoby-dev. All rights reserved.
//

import UIKit
import SnapKit

class LoadingOverlay: UIView {

    let animationDuration: Double = 0.3
    
    private var indicatorView = UIActivityIndicatorView(style: .whiteLarge)
    private var successIndicatorView = SuccessIndicator(frame: CGRect(x: 0, y: 0, width: 140, height: 140))
    private var failureIndicatorView = FailureIndicator(frame: CGRect(x: 0, y: 0, width: 140, height: 140))
    private var titleLabel: UILabel = {
        let _titleLabel = UILabel()
        _titleLabel.font = UIFont.systemFont(ofSize: 14)
        _titleLabel.textColor = UIColor.white
        _titleLabel.textAlignment = .center
        return _titleLabel
    }()
    
    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    private lazy var tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
    
    var actionOnTap: (() -> ())? = nil {
        didSet {
            if actionOnTap != nil {
                self.isUserInteractionEnabled = true
                self.addGestureRecognizer(tap)
            } else {
                self.isUserInteractionEnabled = false
                self.removeGestureRecognizer(tap)
            }
            
        }
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard let action = actionOnTap else { return  }
        action()
        self.actionOnTap = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear

        
        indicatorView.backgroundColor = UIColor.clear
        indicatorView.layer.cornerRadius = 10

        self.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(180)
        }
        
        
        successIndicatorView.alpha = 0
        successIndicatorView.backgroundColor = UIColor.clear
        successIndicatorView.layer.cornerRadius = 10
        
        self.addSubview(successIndicatorView)
        successIndicatorView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(self.indicatorView)
        }
        
        
        failureIndicatorView.alpha = 0
        failureIndicatorView.backgroundColor = UIColor.clear
        failureIndicatorView.layer.cornerRadius = 10
        
        self.addSubview(failureIndicatorView)
        failureIndicatorView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(self.indicatorView)
        }
        
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.indicatorView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder aDecoder: NSCoder) not implemented")
    }
    
    func startAnimating() {
        self.indicatorView.startAnimating()
    }
    
    func stopAnimation() {
        self.indicatorView.stopAnimating()
    }
    
    func showSuccess(compeltion: (() -> ())? = nil) {
        self.indicatorView.alpha = 0
        self.successIndicatorView.alpha = 1
        self.successIndicatorView.animate(duration: animationDuration)
        if let completion = compeltion {
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration + 0.1) {
                completion()
            }
        }
    }
    
    func showFail(compeltion: (() -> ())? = nil) {
        self.indicatorView.alpha = 0
        self.failureIndicatorView.alpha = 1
        self.failureIndicatorView.animate(duration: animationDuration)
        if let completion = compeltion {
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration + 0.2) {
                completion()
            }
        }
    }
    
    
}
