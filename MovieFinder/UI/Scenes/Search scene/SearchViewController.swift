//
//  SearchViewController.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 12/16/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController, Alertable {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private lazy var collectionView: UICollectionView = {
        let cvLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cvLayout)
        cv.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private lazy var emptyStubView: UIView = {
        let _emptyStubView = UIView()
        
        let label = UILabel()
        label.text = "No data".uppercased()
        label.textColor = UIColor.gray
        
        _emptyStubView.addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.centerX.centerY.equalToSuperview()
        })
        
        return _emptyStubView
    }()
    
    private var itemsPerRow: CGFloat = 1
    private var sectionInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 0.0)
    }
    private var lineSpace: CGFloat = 0
    private var interitemSpace: CGFloat = 8
    
    var movies = [Movie]()
    
    let client = MovieFinderClient()
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Color.background
        collectionView.backgroundColor = Color.background
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Search"
        
        let res = SearchResultViewController()
        res.delegate = self
        let searchController = UISearchController(searchResultsController: res)
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchResultsUpdater = res
        searchController.searchBar.keyboardAppearance = .dark
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        self.searchController = searchController
        
        self.definesPresentationContext = true
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.showEmptyStub()
    }
    
    private func showEmptyStub() {
        self.collectionView.backgroundView = self.emptyStubView
    }
    
    private func showCollectionView() {
        self.collectionView.backgroundView = nil
    }
    
    //MARK: - action
    
    private func searchMovies(name: String) {
        self.client.search(name: name) { (movies, error) in
            DispatchQueue.main.async {
                self.movies = movies
                self.collectionView.reloadData()
            }
        }
    }
    
}

extension SearchViewController: SearchResultViewControllerDelegate {
    
    func didClickOnItem(movie: Movie) {
        DispatchQueue.main.async {
            self.searchController.searchResultsController?.view.isHidden = true
            self.searchController.searchBar.endEditing(true)
            self.movies = [movie]
            self.showCollectionView()
            self.collectionView.reloadData()
        }
    }
    
}


extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.searchController.searchResultsController?.view.isHidden = true
        }
        let currentText = searchBar.text ?? ""
        if currentText.count > 0 {
            self.client.search(name: currentText) { (movies, error) in
                if error == nil {
                    self.movies = movies
                    DispatchQueue.main.async {
                        self.showCollectionView()
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.movies = []
        DispatchQueue.main.async {
            self.showEmptyStub()
            self.collectionView.reloadData()
        }
    }
    
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = (sectionInsets.left + sectionInsets.right) + ((itemsPerRow - 1) * interitemSpace)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interitemSpace
    }
    
}

extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsMovieContoller = DetailsMovieViewController(movie: self.movies[indexPath.item], client: TMDbClient())
        self.navigationController?.pushViewController(detailsMovieContoller, animated: true)
    }
    
}


extension SearchViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        cell.title = movies[indexPath.item].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? MovieCell else { return }
        cell.posterImageView.kf.setImage(with: movies[indexPath.row].posterUrl)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? MovieCell else { return }
        cell.posterImageView.kf.cancelDownloadTask()
    }
    
}
