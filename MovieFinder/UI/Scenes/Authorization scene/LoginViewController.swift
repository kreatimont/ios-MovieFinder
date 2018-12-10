//
//  LoginViewController.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 12/2/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController, Alertable {
    
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
    
    private lazy var usernameField: InputTextField = {
        let textField = InputTextField()
        textField.textColor = UIColor.white
        textField.backgroundColor = .clear
        textField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        textField.delegate = self
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        return textField
    }()
    
    private lazy var passwordField: InputTextField = {
        let textField = InputTextField()
        textField.textColor = UIColor.white
        textField.backgroundColor = .clear
        textField.isSecureTextEntry = true
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        textField.delegate = self
        textField.returnKeyType = .done
        return textField
    }()
    
    private lazy var loginButton: ButtonBg = {
        let button = ButtonBg()
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(handleLoginTap(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.gray, for: .highlighted)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.addTarget(self, action: #selector(handleSignUpTap(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 46, weight: .heavy)
        label.text = "Welcome to"
        label.textColor = UIColor.white
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 46, weight: .heavy)
        label.text = "Movie Finder"
        label.textColor = self.view.tintColor
        return label
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        fieldsContainer.addSubview(self.usernameField)
        usernameField.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(30)
        }
        
        fieldsContainer.addSubview(self.passwordField)
        passwordField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.usernameField.snp.bottom).offset(18)
            make.height.equalTo(30)
        }
        
        fieldsContainer.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.passwordField.snp.bottom).offset(18)
            make.height.equalTo(40)
        }
        
        self.view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { (make) in
            make.bottom.left.equalTo(self.view.safeAreaLayoutGuide).inset(16)
        }
        
        self.view.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
        }
        
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.welcomeLabel)
            make.top.equalTo(self.welcomeLabel.snp.bottom)
            make.right.lessThanOrEqualToSuperview().inset(16)
            make.bottom.lessThanOrEqualTo(fieldsContainer.snp.top).offset(16)
        }
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
    }
    
    //MARK: - action
    
    @objc func handleLoginTap(_ sender: Any?) {
        Navigator.shared.route(to: .popularMovies, wrap: .tabBar)
    }
    
    @objc func handleSignUpTap(_ sender: Any?) {
        self.present(SignUpViewController(), animated: true, completion: nil)
    }
    
}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.usernameField {
            self.passwordField.becomeFirstResponder()
            return true
        }
        if textField == self.passwordField {
            //procced login
            textField.endEditing(true)
            return true
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let inputTF = textField as? InputTextField {
            inputTF.hightlight(true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let inputTF = textField as? InputTextField {
            inputTF.hightlight(false)
        }
    }
    
}
