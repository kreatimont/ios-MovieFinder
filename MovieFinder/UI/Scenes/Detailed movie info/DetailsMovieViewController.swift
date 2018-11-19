//
//  DetailsMovieViewController.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 11/19/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import UIKit
import SnapKit
import XCDYouTubeKit
import AVKit

class DetailsMovieViewController: UIViewController, Alertable {
 
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        label.textColor = Color.mainText
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var trailersCollectionView: UICollectionView = {
        let cvLayout = UICollectionViewFlowLayout()
        cvLayout.scrollDirection = .horizontal
        let cv =  UICollectionView(frame: .zero, collectionViewLayout: cvLayout)
        cv.backgroundColor = .clear
        return cv
    }()
    
    private lazy var trailersSectionView: UIView = {
        let view = UIView()
        
        let label = UILabel()
        label.textColor = Color.mainText
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "Trailers"
        
        view.addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.top.left.equalToSuperview().inset(8)
        })
        
        view.addSubview(self.trailersCollectionView)
        trailersCollectionView.snp.makeConstraints({ (make) in
            make.left.equalToSuperview()
            make.top.equalTo(label.snp.bottom).offset(8)
            make.right.bottom.equalToSuperview()
        })
        
        return view
    }()
    
    private lazy var aboutTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.mainText
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 1
        label.text = "About the Film"
        return label
    }()
    
    private lazy var aboutLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.secondaryText
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var aboutSection: UIView = {
        let view = UIView()
        view.addSubview(self.aboutTitleLabel)
        aboutTitleLabel.snp.makeConstraints({ (make) in
            make.left.top.equalToSuperview().inset(8)
        })
        view.addSubview(self.aboutLabel)
        aboutLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.aboutTitleLabel.snp.left)
            make.top.equalTo(self.aboutTitleLabel.snp.bottom).offset(4)
            make.right.bottom.equalToSuperview().inset(8)
        })
        return view
    }()
    
    var itemsPerRow: CGFloat = 1
    var sectionInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
    }
    var interitemSpace: CGFloat = 8
    
    var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Color.background
        
        self.view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let blurEffect = UIBlurEffect(style: .dark)
        let bluredView = UIVisualEffectView(effect: blurEffect)
        
        //        VIBRANCY -- NEED TO TEST
        //        bluredView.translatesAutoresizingMaskIntoConstraints = false
        //        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        //        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        //        vibrancyView.frame = self.view.frame
        //        bluredView.contentView.addSubview(vibrancyView)
        
        
        bluredView.frame = self.view.frame
    
        self.view.insertSubview(bluredView, aboveSubview: backgroundImageView)
        bluredView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(posterImageView)
        posterImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(8)
            make.left.equalToSuperview().inset(12)
            make.height.equalTo(120)
            make.width.equalTo(posterImageView.snp.height).multipliedBy(0.60)
        }
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.posterImageView.snp.top)
            make.left.equalTo(self.posterImageView.snp.right).offset(8)
            make.right.equalToSuperview().inset(8)
        }
        
        let separator = UIView()
        separator.backgroundColor = Color.separator
        
        self.view.addSubview(separator)
        separator.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.posterImageView.snp.bottom).offset(8)
            make.height.equalTo(0.5)
        }
        
        self.view.addSubview(trailersSectionView)
        trailersSectionView.snp.makeConstraints { (make) in
            make.top.equalTo(separator.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.height.equalTo(160)
        }
        
        let separator2 = UIView()
        separator2.backgroundColor = Color.separator
        
        self.view.addSubview(separator2)
        separator2.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.trailersSectionView.snp.bottom).offset(8)
        }
        
        self.view.addSubview(aboutSection)
        aboutSection.snp.makeConstraints { (make) in
            make.top.equalTo(separator2.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
        }
        
        trailersCollectionView.register(VideoCell.self, forCellWithReuseIdentifier: VideoCell.identifier)
        
        self.trailersCollectionView.delegate = self
        self.trailersCollectionView.dataSource = self
        
        self.posterImageView.kf.indicatorType = .activity
        
        self.backgroundImageView.kf.setImage(with: movie.thumbnailUrl)
        self.posterImageView.kf.setImage(with: movie.posterUrl)
        self.titleLabel.text = movie.title
        self.aboutLabel.text = movie.description ?? ""
        self.fetchDetails(id: movie.id)
        
    }
    
    //MARK: - private
    
    func fetchDetails(id: Int) {
        MovieClient.details(id: id) { (result) in
            switch result {
            case .success:
                guard let dataDict = result.value as? [String: AnyObject] else {
                    self.showAlert(title: nil, message: "Bad format error", buttonTitle: "OK", handler: nil)
                    return
                }
                if let response = Movie(with: dataDict) {
                    self.movie = response
                    DispatchQueue.main.async {
                        self.trailersCollectionView.reloadData()
                    }
                }
            case .failure(let error):
                self.showAlert(title: nil, message: error.localizedDescription, buttonTitle: "OK", handler: nil)
            }
        }
    }
    
}


extension DetailsMovieViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableHieght = self.trailersCollectionView.frame.height - (sectionInsets.top + sectionInsets.bottom)
        return CGSize(width: self.trailersCollectionView.frame.width / 2, height: availableHieght)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interitemSpace
    }
    
}

extension DetailsMovieViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //todo: play video
        let playerController = AVPlayerViewController()
        self.present(playerController, animated: true, completion: nil)
        XCDYouTubeClient.default().getVideoWithIdentifier(movie.videos[indexPath.row].key) { [weak playerController] (video, error) in
            if let safeVideo = video {
                let streamURLs = safeVideo.streamURLs as! [UInt: URL]
                print("Stream urls: \(streamURLs)")

                _ = streamURLs[XCDYouTubeVideoQuality.HD720.rawValue] ?? streamURLs[XCDYouTubeVideoQuality.medium360.rawValue] ?? streamURLs[XCDYouTubeVideoQuality.small240.rawValue]

                if let url = streamURLs.first?.value {
                    playerController?.player = AVPlayer(url: url)
                    playerController?.player?.play()
                } else {
                    playerController?.dismiss(animated: true, completion: nil)
                }

            } else {
                playerController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}

extension DetailsMovieViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movie.videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.identifier, for: indexPath) as! VideoCell
        cell.videoImageView.kf.indicatorType = .activity
        cell.title = "\(movie.videos[indexPath.item].name)(\(movie.videos[indexPath.item].site))"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? VideoCell else { return }
        cell.videoImageView.kf.setImage(with: movie.videos[indexPath.item].thumbnailUrl)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? VideoCell else { return }
        cell.videoImageView.kf.cancelDownloadTask()
    }
    
}
