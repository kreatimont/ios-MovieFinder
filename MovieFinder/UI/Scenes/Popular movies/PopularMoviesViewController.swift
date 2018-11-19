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
    
    private var itemsPerRow: CGFloat = 1
    private var sectionInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    }
    private var lineSpace: CGFloat = 8
    private var interitemSpace: CGFloat = 8
    
    private var movies = [Movie]()
    private var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Popular"
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.fetchMovies()
    }
    
    //MARK: - private
    
    private func fetchMovies(page: Int = 1) {
//        self.downloading = true
        MovieClient.popular(page: page) { (result) in
//            self.downloading = false
            switch result {
            case .success:
                guard let dataDict = result.value as? [String: AnyObject] else {
                    self.showAlert(title: nil, message: "Bad format", buttonTitle: "OK", handler: nil)
                    return
                }
                if let response = Response(with: dataDict) {
                    var insertIndexPaths = [IndexPath]()
                    for i in self.movies.count...(self.movies.count + response.results.count - 1) {
                        insertIndexPaths.append(IndexPath(row: i, section: 0))
                    }
                    self.movies.append(contentsOf: response.results)
                    DispatchQueue.main.async {
                        self.collectionView.performBatchUpdates({
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
        return CGSize(width: widthPerItem, height: 100)
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
        //TODO: show details about movie in new view controller
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.collectionView else { return }
        if scrollView.contentOffset.y >= (self.collectionView.contentSize.height - self.collectionView.bounds.size.height) - 160 {
            self.currentPage += 1
            self.fetchMovies(page: self.currentPage)
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
        cell.backdropImageView.kf.setImage(with: movies[indexPath.row].thumbnailUrl)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? MovieCell else { return }
        cell.backdropImageView.kf.cancelDownloadTask()
    }
    
}
