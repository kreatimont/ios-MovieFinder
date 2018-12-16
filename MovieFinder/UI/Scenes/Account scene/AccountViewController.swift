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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Color.background
        tableView.backgroundColor = Color.background
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Account"
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.tableView.separatorColor = Color.separator
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    //MARK: - action
    
    @objc func handleLogoutTap(_ sender: Any?) {
        AuthSession.current.close(rememberCredetionals: true)
        Navigator.shared.route(to: .login, wrap: .none)
    }
    
}

extension AccountViewController: UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 2 {
                UIPasteboard.general.string = AuthSession.current.authToken
            }
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                
            } else if indexPath.row == 1 {
                self.showAlert(title: nil, message: "Bought movies section is currently unavailable", buttonTitle: "OK", handler: nil)
            }
        }
        if indexPath.section == 2 {
            self.handleLogoutTap(nil)
        }
    }
    
}

extension AccountViewController: UITableViewDataSource {
    
    func generateBgViewForSelectedCell() -> UIView {
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = Color.separator
        return selectedBackground
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else if section == 1 {
            return 2
        } else if section == 2 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            
            if indexPath.row == 0 {
                cell.textLabel?.text = "Email"
                cell.detailTextLabel?.text = AuthSession.current.email
                cell.selectionStyle = .none
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "User id"
                cell.detailTextLabel?.text = "\(AuthSession.current.userId ?? -1)"
                cell.selectionStyle = .none
            } else if indexPath.row == 2 {
                let textCell = TextViewCell(style: .default, reuseIdentifier: "textViewCell")
                textCell.backgroundColor = Color.cellBackground
                textCell.selectedBackgroundView = generateBgViewForSelectedCell()
                textCell.textLabel?.text = AuthSession.current.authToken ?? ""
                textCell.textLabel?.textColor = Color.mainText
                textCell.textLabel?.numberOfLines = 5
                textCell.textLabel?.font = UIFont(name: "Courier", size: 15)
                textCell.selectedBackgroundView = generateBgViewForSelectedCell()
                return textCell
            }
            
            cell.textLabel?.textColor = Color.mainText
            cell.backgroundColor = Color.cellBackground
            
            return cell
        } else if indexPath.section == 1 {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            if indexPath.row == 0 {
                cell.textLabel?.text = "Watchlater list"
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Bought movies"
                
            }
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.textColor = Color.mainText
            cell.backgroundColor = Color.cellBackground
            cell.selectedBackgroundView = generateBgViewForSelectedCell()
            return cell
        } else if indexPath.section == 2 {
            let cell = LogoutCell(style: .value1, reuseIdentifier: "cell")
            cell.textLabel?.textColor = Color.mainText
            cell.backgroundColor = Color.cellBackground
            cell.selectedBackgroundView = generateBgViewForSelectedCell()
            return cell
        }
        fatalError("cellForRow not implemented")
    }
    
}
