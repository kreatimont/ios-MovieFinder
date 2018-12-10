//
//  PopularMoviesViewController.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 11/19/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class PopularMoviesViewController: UIViewController, Alertable {
    
    private lazy var collectionView: UICollectionView = {
        let cvLayout = UICollectionViewFlowLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: cvLayout)
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshCtrl = UIRefreshControl()
        refreshCtrl.tintColor = Color.mainText
        refreshCtrl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshCtrl
    }()
    
    private lazy var loadingView: UIView = {
        let _loadingView = UIView()
        
        let activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.startAnimating()
        
        let label = UILabel()
        label.text = "Loading"
        label.textColor = Color.mainText
        
        let stackView = UIStackView(arrangedSubviews: [activityIndicator, label])
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.axis = .horizontal
        
        _loadingView.addSubview(stackView)
        stackView.snp.makeConstraints({ (make) in
            make.centerX.centerY.equalToSuperview()
        })
        
        return _loadingView
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
    
    private var movies = [Movie]()
    private var currentPage = 1
    
    var downloading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Popular"
        
        self.view.backgroundColor = Color.background
        collectionView.backgroundColor = Color.background
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        collectionView.refreshControl = refreshControl
        
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.showLoading()
        self.fetchMovies()
    }
    
    //MARK: - actions
    
    @objc func handleRefresh(_ sender: Any?) {
        //TODO: implement swipe to refesh
        self.fetchMovies()
    }
    
    //MARK: - private
    
    private func showLoading() {
        self.collectionView.backgroundView = self.loadingView
    }
    
    private func showEmptyStub() {
        self.collectionView.backgroundView = self.emptyStubView
    }
    
    private func showCollectionView() {
        self.collectionView.backgroundView = nil
    }
    
    private func fetchMovies(page: Int = 1) {
        self.downloading = true
        MovieClient.popular(page: page) { (result) in
            self.downloading = false
            self.showCollectionView()
            self.refreshControl.endRefreshing()
            switch result {
            case .success:
                guard let dataDict = result.value as? [String: AnyObject] else {
                    self.showAlert(title: nil, message: "Bad format", buttonTitle: "OK", handler: nil)
                    return
                }
                if let response = Response(with: dataDict) {
                    var deletePaths = [IndexPath]()
                    if page == 1 {
                        for i in 0..<self.movies.count {
                            deletePaths.append(IndexPath(row: i, section: 0))
                        }
                        self.movies.removeAll()
                    }
                    var insertIndexPaths = [IndexPath]()
                    for i in self.movies.count...(self.movies.count + response.results.count - 1) {
                        insertIndexPaths.append(IndexPath(row: i, section: 0))
                    }
                    self.movies.append(contentsOf: response.results)
                    DispatchQueue.main.async {
                        self.collectionView.performBatchUpdates({
                            self.collectionView.deleteItems(at: deletePaths)
                            self.collectionView.insertItems(at: insertIndexPaths)
                        }, completion: nil)
                    }
                }
            case .failure(let error):
                self.showAlert(title: nil, message: error.localizedDescription, buttonTitle: "OK", handler: nil)
            }
        }
        
    }
    
}


extension PopularMoviesViewController: UICollectionViewDelegateFlowLayout {
    
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

extension PopularMoviesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsMovieContoller = DetailsMovieViewController(movie: self.movies[indexPath.item])
        self.navigationController?.pushViewController(detailsMovieContoller, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.collectionView else { return }
        if scrollView.contentOffset.y >= (self.collectionView.contentSize.height - self.collectionView.bounds.size.height) - 160 {
            if !downloading {
                self.currentPage += 1
                self.fetchMovies(page: self.currentPage)
            }
            
        }
    }
    
}


extension PopularMoviesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        cell.title = movies[indexPath.row].title
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
