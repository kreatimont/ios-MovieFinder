//
//  AccountViewController.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 12/3/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import UIKit
import SnapKit

class AccountViewController: UIViewController, Alertable {
    
    private lazy var videoFrame: UIView = {
        let view = UIView()
        let imageView = UIImageView(image: UIImage(named: "test_img"))
        view.addSubview(imageView)
        imageView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        return view
    }()
    
    private lazy var blurOverlay: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let bluredView = UIVisualEffectView(effect: blurEffect)
        return bluredView
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.red, for: .normal)
        button.setTitleColor(UIColor.red.withAlphaComponent(0.5), for: .highlighted)
        button.setTitle("Logout", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.addTarget(self, action: #selector(handleLogoutTap(_:)), for: .touchUpInside)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Account"
        
        self.view.addSubview(videoFrame)
        videoFrame.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        self.view.addSubview(blurOverlay)
        blurOverlay.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        let fieldsContainer = UIView()
        self.view.addSubview(fieldsContainer)
        fieldsContainer.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalToSuperview().inset(16)
        }
        
        self.view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { (make) in
            make.bottom.left.equalTo(self.view.safeAreaLayoutGuide).inset(16)
        }
        
    }
    
    //MARK: - action
    
    @objc func handleLogoutTap(_ sender: Any?) {
        Navigator.shared.route(to: .login, wrap: .none)
    }
    
}
