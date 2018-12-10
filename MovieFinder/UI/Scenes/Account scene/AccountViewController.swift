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
        Navigator.shared.route(to: .login, wrap: .none)
    }
    
}

extension AccountViewController: UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            self.handleLogoutTap(nil)
        }
    }
    
}

extension AccountViewController: UITableViewDataSource {
    
    func generateBgViewForSelectedCell() -> UIView {
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = UIColor.darkGray
        return selectedBackground
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
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
            cell.textLabel?.text = "Name"
            cell.detailTextLabel?.text = "Alexandr"
            
            cell.textLabel?.textColor = Color.mainText
            cell.backgroundColor = Color.cellBackground
            cell.selectedBackgroundView = generateBgViewForSelectedCell()
            
            return cell
        } else if indexPath.section == 1 {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            if indexPath.row == 0 {
                cell.textLabel?.text = "Notifications"
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Data and storage"
                
            }
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
