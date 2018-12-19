//
//  SearchResultViewController.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 12/16/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import UIKit
import SnapKit

protocol SearchResultViewControllerDelegate: class {
    func didClickOnItem(movie: Movie)
}

class SearchResultViewController: UIViewController, Alertable {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private lazy var tableView = UITableView()
    
    var movies = [Movie]()
    
    let client = MovieFinderClient()
    
    var timer: Timer?
    
    weak var delegate: SearchResultViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Color.background
        self.tableView.backgroundColor = Color.cellBackground
        self.tableView.separatorColor = Color.separator
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - action
    
}

extension SearchResultViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        print("SearchResultViewController :updateSearchResults searchBarText: \(searchController.searchBar.text ?? "")")
        self.timer?.invalidate()
        let currentText = searchController.searchBar.text ?? ""
        if currentText.count > 0 {
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
                self.client.search(name: currentText, completion: { (movies, error) in
                    if error == nil {
                        self.movies = movies
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                })
            })
        }
    }
    
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = self.movies[indexPath.row]
        self.delegate?.didClickOnItem(movie: movie)
        print("SearchResultViewController :didSelect movie: \(movie.title)")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let movie = self.movies[indexPath.row]
        cell.textLabel?.text = movie.title
        cell.textLabel?.textColor = Color.mainText
        cell.backgroundColor = Color.cellBackground
        cell.selectionStyle = .none
        return cell
    }
    
}




