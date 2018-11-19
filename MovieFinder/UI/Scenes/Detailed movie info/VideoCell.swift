//
//  VideoCell.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 11/19/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import UIKit
import SnapKit

class VideoCell: UICollectionViewCell {
    
    static let `identifier` = "video-cell"
    
    lazy var videoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = Color.separator.cgColor
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.mainText
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.mainText
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 10, weight: .thin)
        return label
    }()
    

    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    var duration: String? {
        didSet {
            self.timeLabel.text = duration
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.videoImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(videoImageView)
        videoImageView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.videoImageView.snp.bottom).offset(4)
            make.left.right.equalToSuperview()
        }
        
        self.contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(4)
            make.right.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
