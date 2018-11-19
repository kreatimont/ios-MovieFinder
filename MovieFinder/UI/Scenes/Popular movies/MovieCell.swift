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
    
    lazy var backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.textColor
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    var backdropImage: UIImage? {
        didSet {
            self.backdropImageView.image = backdropImage
        }
    }
    
    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backdropImage = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(backdropImageView)
        backdropImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(4)
            make.width.equalTo(self.contentView.snp.height).multipliedBy(0.5)
        }
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.backdropImageView.snp.top)
            make.left.equalTo(self.backdropImageView.snp.right).offset(8)
            make.right.equalToSuperview().inset(16)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
