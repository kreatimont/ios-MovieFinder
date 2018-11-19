//
//  MovieCell.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 11/19/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import UIKit
import SnapKit

class MovieCell: UICollectionViewCell {
    
    static let `identifier` = "movie-cell"
    
    lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.mainText
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = Color.separator
        return view
    }()
    
    var posterImage: UIImage? {
        didSet {
            self.posterImageView.image = posterImage
        }
    }
    
    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.posterImage = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(posterImageView)
        posterImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(6)
            make.top.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
            make.width.equalTo(self.snp.height).multipliedBy(0.60)
        }
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.posterImageView.snp.top)
            make.left.equalTo(self.posterImageView.snp.right).offset(8)
            make.right.equalToSuperview().inset(16)
        }
        
        self.contentView.addSubview(separatorLine)
        separatorLine.snp.makeConstraints { (make) in
            make.left.equalTo(self.posterImageView.snp.left)
            make.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
